-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA Y TRIGGERS DE APOYO
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~   APOYOS EN ASISTENCIA EN PUNTO   ~~~~~~~~
-- ~~~~~~~~ PARA: Crear/registrar asistencias ~~~~~~~~
-- ***45.1 Rutina para la obtencion de fechas de inicio y fin dependiendo de la frecuencia del beneficiario.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readFrequencyDates`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readFrequencyDates`(IN IdFrequency INT, OUT StartDate DATE, OUT EndDate DATE)
BEGIN
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Obtencion la fecha de inicio y final del intervalo de tiempo en que se revisan las asistencias,
    -- el intervalo de tiempo es dependiente de la frecuencia de visita del beneficiario.
    IF IdFrequency = 1 THEN -- intervalo de tiempo de una semana.
        SELECT	ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    ELSEIF IdFrequency = 2 THEN -- intervalo de tiempo de dos semanas.
        SELECT	SUBDATE(ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    ELSE -- intervalo de tiempo de un mes.
        SELECT	SUBDATE(ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY), INTERVAL 21 DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    END IF;
END$$

DELIMITER ;



-- Rutina para la creacion de asistencia de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createAttendance` (IN IdBeneficiary INT)
BEGIN
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Creacion de asistencia de un beneficiario
    INSERT INTO `REDO_MAKMA`.`AsistenciaPunto`
    (`fecha`, `beneficiario_idBeneficiario`)
    VALUES
        (CURDATE(), IdBeneficiary);
END$$

DELIMITER ;



-- Rutina para la eliminacion de una falta de un determinado beneficiario basado en su frecuencia de visita
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteAbsence`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteAbsence`(IN IdBeneficiary INT, IN StartDate DATE, IN EndDate DATE)
BEGIN
    -- Eliminacion de una falta de un determinado beneficiario basado en su frecuencia de visita
    DELETE FROM `REDO_MAKMA`.`Falta`
    WHERE `fecha` >= StartDate AND `fecha` <= EndDate
      AND `beneficiario_idBeneficiario` = IdBeneficiary;
END$$

DELIMITER ;



-- Rutina para hacer update del Status de las faltas de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateAbscenceStatus`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateAbscenceStatus`(IN Status TINYINT, IN IdBeneficiary INT)
BEGIN
    -- Actualizacion en el status de faltas de un beneficiario
    DECLARE LastDate DATE;
    SET time_zone='America/Mexico_City';
    IF (Status = 0) THEN -- Se utiliza cuando un beneficiario es reactivado y se desactivan sus faltas
        UPDATE `REDO_MAKMA`.`Falta`
        SET `status`='0'
        WHERE `beneficiario_idBeneficiario` = IdBeneficiary;

    ELSEIF (Status = 1) THEN -- Se utiliza cuando se quita una asistencia en punto y se necesitan reactivar las faltas
    -- Obtencion de la ultima fecha en la que asistio.
        SELECT MAX(fecha) INTO LastDate
        FROM AsistenciaPunto WHERE beneficiario_idBeneficiario = IdBeneficiary;
        -- Cambio en ultima fecha si es mas reciente la ultima vez que justifico.
        SELECT IF(MAX(fechaJustificada <= CURDATE()) >= LastDate, fechaJustificada, LastDate) INTO LastDate
        FROM Justificacion WHERE beneficiario_idBeneficiario = IdBeneficiary;
        IF (LastDate IS NULL) THEN -- Revision si existe una ultima vez que vino o justifico. Se activa todo si no existe
            UPDATE `REDO_MAKMA`.`Falta`
            SET `status`='1'
            WHERE `beneficiario_idBeneficiario` = IdBeneficiary;
        ELSE -- Si existe una fecha, se toma esa reactivan las faltas a partir de ahi
            UPDATE `REDO_MAKMA`.`Falta`
            SET `status`='1'
            WHERE `fecha` >= LastDate
              AND `beneficiario_idBeneficiario` = IdBeneficiary;
        END IF;
    END IF;
END$$

DELIMITER ;



-- ~~~~~~~~ PARA: Eliminar asistencias ~~~~~~~~
-- Rutina para la eliminacion de asistencia de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteAttendance` (IN IdBeneficiary INT, IN StartDate DATE, IN EndDate DATE)
BEGIN
    -- Eliminacion de asistencia de un beneficiario segun su frecuencia de visita
    DELETE FROM `REDO_MAKMA`.`AsistenciaPunto`
    WHERE beneficiario_idBeneficiario = IdBeneficiary
      AND fecha BETWEEN StartDate AND EndDate;
END$$

DELIMITER ;



-- TRIGGER para la creacion de faltas cuando se borra una asistencia y si no hay justificacion
USE `REDO_MAKMA`;
DROP TRIGGER IF EXISTS `createAnAbsence`;

DELIMITER //

USE `REDO_MAKMA`//
CREATE TRIGGER `createAnAbsence`
    AFTER DELETE ON AsistenciaPunto
    FOR EACH ROW
BEGIN
    -- TRIGGER para la creacion de faltas al borrar una asistencia del beneficiario.
    DECLARE cJustification INT DEFAULT 0;
    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Obtencion de la frecuencia para saber en que marco de tiempo para buscar la justificacion
    SELECT b.frecuenciaVisita_idFrecuenciaVisita INTO IdFrequency
    FROM Beneficiario b WHERE b.idBeneficiario = OLD.beneficiario_idBeneficiario;
    -- Obtencion del marco de tiempo para buscar la justificacion
    CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
    -- Conteo de faltas en ese tiempo
    SELECT COUNT(*) INTO cJustification
    FROM Justificacion j
    WHERE j.fechaJustificada >= StartDate
      AND j.fechaJustificada <= EndDate
      AND j.beneficiario_idBeneficiario = OLD.beneficiario_idBeneficiario;
    IF (cJustification = 0) THEN
        INSERT INTO `REDO_MAKMA`.`Falta`(`fecha`,`beneficiario_idBeneficiario`)
        VALUES (OLD.fecha, OLD.beneficiario_idBeneficiario);
    END IF;
END //
DELIMITER ;



-- ~~~~~~~~   APOYOS EN LISTA GLOBAL ~~~~~~~~
-- ~~~~~~~~ PARA: Registro masivo de beneficiarios ~~~~~~~~
-- Rutina para la creacion de un nuevo beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createBeneficiary` (IN Folio VARCHAR(13), IN Name VARCHAR(60), IN Address VARCHAR(40), IN IdDay INT, IN StartDate DATE,
                                      IN EndDate DATE, IN Status TINYINT(1), IN aGrant TINYINT(1), IN IdFrequency INT,
                                      IN PhoneNumber VARCHAR(12), IN IdBranch INT)
BEGIN
    -- Creacion de un nuevo beneficiario
    INSERT INTO `REDO_MAKMA`.`Beneficiario`
    (`folio`,`nombre`,`status`,`beca`,`fRegistro`,`fVencimiento`,`colonia`,
     `telefono`,`frecuenciaVisita_idFrecuenciaVisita`,`grupoDia_idGrupoDia`,`sucursal_idSucursal`)
    VALUES
        (UPPER(Folio), UPPER(Name), Status, aGrant, CAST(DATE_FORMAT(StartDate,'%d-%m-%y')AS DATE), CAST(DATE_FORMAT(EndDate,'%d-%m-%y')AS DATE),
         UPPER(Address), PhoneNumber, IdFrequency, IdDay, IdBranch);
END$$

DELIMITER ;




-- Rutina para la actualizacion de un beneficiario existente
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiary`(IN Folio VARCHAR(13), IN Name VARCHAR(60), IN Address VARCHAR(40), IN IdDay INT, IN StartDate DATE,
                                     IN EndDate DATE, IN Status TINYINT(1), IN aGrant TINYINT(1), IN IdFrequency INT,
                                     IN PhoneNumber VARCHAR(12), IN IdBranch INT, IN IdBeneficiary INT)
BEGIN
    -- Actualizacion de un beneficiario existente en todos sus datos
    DECLARE IsInactive INT DEFAULT (0);
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    UPDATE `REDO_MAKMA`.`Beneficiario`
    SET
        `nombre` = UPPER(Name),
        `status` = Status,
        `beca` = aGrant,
        `fRegistro` = CAST(DATE_FORMAT(StartDate,'%d-%m-%y')AS DATE),
        `fVencimiento` = CAST(DATE_FORMAT(EndDate,'%d-%m-%y')AS DATE),
        `colonia` = UPPER(Address),
        `telefono` = CAST(PhoneNumber AS character),
        `frecuenciaVisita_idFrecuenciaVisita` = IdFrequency,
        `grupoDia_idGrupoDia` = IdDay,
        `sucursal_idSucursal` = IdBranch
    WHERE `folio` = Folio AND `idBeneficiario` = IdBeneficiary;
    -- Cambio del signo especial por ñ, no se aceptan beneficiarios con acento en el sistema por que usan el mismo simbolo que con ñ
    UPDATE `REDO_MAKMA`.`Beneficiario` SET `nombre` = REPLACE(`nombre`,'�','Ñ') WHERE `idBeneficiario` = IdBeneficiary;
    -- Se verifica si cumple la primera condicion para que permanezca inactivo el beneficiario (4 faltas)
    SELECT IF(COUNT(*)>=4,1,0) INTO IsInactive
    FROM Falta
    WHERE beneficiario_idBeneficiario = IdBeneficiary
      AND status=1;
    IF (IsInactive=1) THEN  -- Se inactiva al beneficiario si cumple condicion
        UPDATE `REDO_MAKMA`.`Beneficiario`
        SET `status` = 0
        WHERE `folio` = Folio AND `idBeneficiario` = IdBeneficiary;
    ELSE
        -- Se verifica si cumple la segunda condicion para que permanezca inactivo el beneficiario (Fecha de vencimiento cumplida)
        SELECT IF(CURDATE()>fVencimiento,1,0) INTO IsInactive
        FROM Beneficiario
        WHERE idBeneficiario = IdBeneficiary;
        IF (IsInactive=1) THEN -- Se inactiva al beneficiario si cumple condicion
            UPDATE `REDO_MAKMA`.`Beneficiario`
            SET `status` = 0
            WHERE `folio` = Folio AND `idBeneficiario` = IdBeneficiary;
        END IF;
    END IF;
END$$

DELIMITER ;



-- Rutina para la inactivacion del status de todos los beneficiarios.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `inactivateBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `inactivateBeneficiaries`()
BEGIN
    -- inactivacion del status de todos los beneficiarios del sistema.
    UPDATE `REDO_MAKMA`.`Beneficiario`
    SET `status` = 0 WHERE `idBeneficiario` >= 1;
END$$

DELIMITER ;




-- ~~~~~~~~   APOYOS EN ASISTENCIA EN COMUNIDADES  ~~~~~~~~
-- ~~~~~~~~ PARA: Creacion de peticion de paquetes ~~~~~~~~
-- Obtencion de todos los registros por paquetes que se tienen segun la fecha del reporte activo y la comunidad de la que es el reporte
-- (de donde se envia la informacion de entrada, que es el stored procedure que apoya)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readRequest`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readRequest` (IN StartDate DATE, IdCommunityOfReport INT)
BEGIN
    -- Obtencion de todos los registros por paquetes que se tienen segun la fecha del reporte activo y la comunidad de la que es el reporte
    -- (de donde se envia la informacion de entrada, que es el stored procedure que apoya)
    DECLARE IdRequest INT;
    DECLARE aDate DATE;
    DECLARE Packages INT;
    DECLARE Community VARCHAR(40);
    DECLARE CommitteeMember VARCHAR(60);
    DECLARE PhoneNumber VARCHAR(12);
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor.
    -- Declaracion del cursor con su respectiva query que es para para peticiones de paquetes por parte de las comunidades validos.
    DECLARE readRequest_cursor CURSOR FOR
        -- Visualización de las peticiones de paquetes por parte de las comunidades
        SELECT	p.idPeticion,
                  p.fecha,
                  p.cantPaquetesEnv,
                  c.nombre,
                  m.nombre,
                  m.telefono
        FROM Peticion p
                 LEFT JOIN Comunidad c
                           ON p.comunidad_idComunidad = c.idComunidad
                 LEFT JOIN MiembroComite m
                           ON p.miembroComite_idMiembroComite = m.idMiembroComite
        WHERE 	c.idComunidad = IdCommunityOfReport
          AND p.fecha >= StartDate
        ORDER BY p.fecha DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- manipulacion de los datos en API y FRONT.
    CREATE TABLE IF NOT EXISTS `readRequests`(
                                                 `id` INT NOT NULL AUTO_INCREMENT,
                                                 `IdPeticion` INT,
                                                 `Fecha` DATE,
                                                 `PaquetesEnviados` INT,
                                                 `Comunidad` VARCHAR(40),
                                                 `MiembroComite` VARCHAR(60),
                                                 `Telefono` VARCHAR(12),
                                                 PRIMARY KEY (`id`)
    );
    OPEN readRequest_cursor;
    FETCH readRequest_cursor INTO IdRequest, aDate, Packages, Community, CommitteeMember, PhoneNumber;
    WHILE Flag = TRUE DO
            -- Insercion en tabla temporal los datos generales y la informacion de asistencia de cada beneficiario valido.
            INSERT INTO `REDO_MAKMA`.`readRequests`
            (`IdPeticion`, `Fecha`, `PaquetesEnviados`, `Comunidad`, `MiembroComite`, `Telefono`)
            VALUES (IdRequest, aDate, Packages, Community, CommitteeMember, PhoneNumber);
            FETCH readRequest_cursor INTO IdRequest, aDate, Packages, Community, CommitteeMember, PhoneNumber;
        END WHILE;
    CLOSE readRequest_cursor;
END$$

DELIMITER ;



-- TRIGGER para la creacion de reportes cuando se crea una peticion y aplican las condiciones para hacerlo
USE `REDO_MAKMA`;
DROP TRIGGER IF EXISTS `createCommunityReport`;

DELIMITER //

USE `REDO_MAKMA`//
CREATE TRIGGER `createCommunityReport`
    AFTER INSERT ON Peticion
    FOR EACH ROW
BEGIN
    -- TRIGGER para la creacion de reportes cuando se crea una peticion y aplican las condiciones para hacerlo
    DECLARE cReports INT DEFAULT 0;
    SELECT COUNT(*) INTO cReports
    FROM ReporteMensual rm
    WHERE rm.comunidad_idComunidad = NEW.comunidad_idComunidad
      AND status=1;
    IF (cReports = 0) THEN
        INSERT INTO `REDO_MAKMA`.`ReporteMensual`
        (`fechaInicio`, `comunidad_idComunidad`)
        VALUES
            (NEW.fecha, NEW.comunidad_idComunidad);
    END IF;
END //
DELIMITER ;


-- ~~~~~~~~   APOYOS EN REPORTES ~~~~~~~~
-- ~~~~~~~~ PARA: Cargar info en tabla de historico de asistencia ~~~~~~~~
-- Rutina para la obtencion de informacion sobre las asistencias para cargar la tabla
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readAttendanceReportRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAttendanceReportRecord`(IN IdBranch INT)
BEGIN
    -- Obtencion de informacion sobre las asistencias para cargar la tabla
    -- Cargado de la tabla de informacion sobre las asistencias
    -- Declaracion de variables para los cursores
    DECLARE CAttendance INT;
    DECLARE StartDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor,
    -- Declaracion de los cursores a ocupar para recopilar los datos
    DECLARE AttendanceRecord_cursor CURSOR FOR -- Cursor para recopilar informacion de asistencias
        SELECT COUNT(*), ADDDATE(ap.fecha, INTERVAL 0-WEEKDAY(fecha) DAY) fechaInicio
        FROM AsistenciaPunto ap
                 LEFT JOIN Beneficiario b
                           ON ap.beneficiario_idBeneficiario = b.idBeneficiario
        WHERE (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        GROUP BY fechaInicio
        ORDER BY fechaInicio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tablas temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere usar el sistema al final.
    DROP TABLE IF EXISTS `AttendanceReportRecord`; -- Tabla para el conteo de asistencias
    CREATE TABLE IF NOT EXISTS `AttendanceReportRecord`(
                                                           `id` INT NOT NULL AUTO_INCREMENT,
                                                           `NumAsistencias` INT,
                                                           `FechaInicial` DATE,
                                                           PRIMARY KEY (`id`) );
    -- Apertura del cursor para empezar cargar la tabla.
    OPEN AttendanceRecord_cursor;
    FETCH AttendanceRecord_cursor INTO CAttendance, StartDate;
    WHILE Flag = TRUE DO
            INSERT INTO `REDO_MAKMA`.`AttendanceReportRecord`
            (`NumAsistencias`, `FechaInicial`)
            VALUES (CAttendance, StartDate);
            FETCH AttendanceRecord_cursor INTO CAttendance, StartDate;
        END WHILE;
    CLOSE AttendanceRecord_cursor;
END$$

DELIMITER ;




-- Rutina para la obtencion de informacion sobre las faltas para cargar la tabla
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readAbsenceReportRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAbsenceReportRecord` (IN IdBranch INT)
BEGIN
    -- Obtencion de informacion sobre las faltas para cargar la tabla
    -- Cargado de la tabla de informacion sobre las faltas
    -- Declaracion de variables para los cursores
    DECLARE CAbsence INT;
    DECLARE StartDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor,
    -- Declaracion de los cursores a ocupar para recopilar los datos
    DECLARE AbsenceRecord_cursor CURSOR FOR -- Cursor para recopilar informacion de faltas
        SELECT COUNT(*), ADDDATE(f.fecha, INTERVAL 0-WEEKDAY(f.fecha) DAY) fechaInicio
        FROM Falta f
                 LEFT JOIN Beneficiario b
                           ON f.beneficiario_idBeneficiario = b.idBeneficiario
        WHERE (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        GROUP BY fechaInicio
        ORDER BY fechaInicio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tablas temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere usar el sistema al final.
    DROP TABLE IF EXISTS `AbsenceReportRecord`; -- Tabla para el conteo de faltas
    CREATE TABLE IF NOT EXISTS `AbsenceReportRecord`(
                                                        `id` INT NOT NULL AUTO_INCREMENT,
                                                        `NumFaltas` INT,
                                                        `FechaInicial` DATE,
                                                        PRIMARY KEY (`id`) );
    -- Apertura del cursor para empezar cargar la tabla.
    OPEN AbsenceRecord_cursor;
    FETCH AbsenceRecord_cursor INTO CAbsence, StartDate;
    WHILE Flag = TRUE DO
            INSERT INTO `REDO_MAKMA`.`AbsenceReportRecord`
            (`NumFaltas`, `FechaInicial`)
            VALUES (CAbsence, StartDate);
            FETCH AbsenceRecord_cursor INTO CAbsence, StartDate;
        END WHILE;
    CLOSE AbsenceRecord_cursor;
END$$

DELIMITER ;



-- Rutina para la obtencion de informacion sobre las justificaciones para cargar la tabla
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readJustificationReportRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readJustificationReportRecord` (IN IdBranch INT)
BEGIN
    -- Obtencion de informacion sobre las justificaciones para cargar la tabla
    -- Cargado de la tabla de informacion sobre las faltas
    -- Declaracion de variables para los cursores
    DECLARE CJustification INT;
    DECLARE StartDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor,
    DECLARE JustificationReportRecord_cursor CURSOR FOR -- Cursor para recopilar informacion de justificaciones
        SELECT COUNT(*), ADDDATE(j.fechaJustificada, INTERVAL 0-WEEKDAY(j.fechaJustificada) DAY) fechaInicio
        FROM Justificacion j
                 LEFT JOIN Beneficiario b
                           ON j.beneficiario_idBeneficiario = b.idBeneficiario
        WHERE   (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        GROUP BY fechaInicio
        ORDER BY fechaInicio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tablas temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere usar el sistema al final.
    DROP TABLE IF EXISTS `JustificationReportRecord`; -- Tabla para el conteo justificaciones
    CREATE TABLE IF NOT EXISTS `JustificationReportRecord`(
                                                              `id` INT NOT NULL AUTO_INCREMENT,
                                                              `NumJustificaciones` INT,
                                                              `FechaInicial` DATE,
                                                              PRIMARY KEY (`id`) );
    -- Apertura del cursor para empezar cargar la tabla.
    OPEN JustificationReportRecord_cursor;
    FETCH JustificationReportRecord_cursor INTO CJustification, StartDate;
    WHILE Flag = TRUE DO
            INSERT INTO `REDO_MAKMA`.`JustificationReportRecord`
            (`NumJustificaciones`, `FechaInicial`)
            VALUES (CJustification, StartDate);
            FETCH JustificationReportRecord_cursor INTO CJustification, StartDate;
        END WHILE;
    CLOSE JustificationReportRecord_cursor;
END$$

DELIMITER ;



-- ~~~~~~~~   APOYOS EN JUSTIFICACIONES  ~~~~~~~~
-- ~~~~~~~~~ PARA: Crear justificaciones ~~~~~~~~
-- Rutina para la obtencion de marcos de tiempo basado en una fecha especifica
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readFrequencyDateByDate`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readFrequencyDateByDate` (IN IdFrequency INT, OUT StartDate DATE, OUT EndDate DATE, IN Date DATE)
BEGIN
    -- Se obtiene la fecha de inicio y final del intervalo de tiempo en que se revisan las asistencias,
    -- el intervalo de tiempo es dependiente de la frecuencia de visita del beneficiario.
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    IF IdFrequency = 1 THEN
        SELECT	ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY),
                  ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY) INTO StartDate, EndDate;
    ELSEIF IdFrequency = 2 THEN
        SELECT	SUBDATE(ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY), INTERVAL 7 DAY),
                  ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY) INTO StartDate, EndDate;
    ELSE
        SELECT	SUBDATE(ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY), INTERVAL 21 DAY),
                  ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY) INTO StartDate, EndDate;
    END IF;
END$$

DELIMITER ;















-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA Y EVENTOS DEL SISTEMA
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la creacion de faltas de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createAbsence`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createAbsence`()
BEGIN
    -- Creacion de faltas de los beneficiarios
    -- Declaracion de variables ha utilizar para obtener la informacion del cursor durante el FETCH
    -- y auxiliares para el proceso y validaciones.
    DECLARE IdBeneficiary INT;
    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE IsAbsence TINYINT(1);
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor
    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion de los beneficiarios validos.
    DECLARE Absence_cursor CURSOR FOR
        SELECT b.idBeneficiario,
               b.frecuenciaVisita_idFrecuenciaVisita
        FROM Beneficiario b
                 LEFT JOIN AsistenciaPunto ap
                           ON ap.beneficiario_idBeneficiario = b.idBeneficiario
        WHERE 	b.status = 1
          AND grupoDia_idGrupoDia = WEEKDAY(CURDATE())+1
        GROUP BY b.idBeneficiario
        ORDER BY b.folio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE; -- Bandera que indica si e cursor ya no tiene informacion
    -- Apertura del cursor para empezar a recorrer lo que contiene el cursor. Se usa cursor por las diferentes frecuencias
    -- que maneja cada beneficiario.
    OPEN Absence_cursor;
    FETCH Absence_cursor INTO IdBeneficiary, IdFrequency;
    WHILE Flag = TRUE DO
            CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
            SELECT 	IF(ap.fecha >= StartDate AND ap.fecha <= EndDate, 0,
                         IF(COUNT(j.fechaJustificada >= StartDate AND j.fechaJustificada <= EndDate) >= 1,0,1))
            INTO IsAbsence
            FROM Beneficiario b
                     LEFT JOIN AsistenciaPunto ap
                               ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                                   AND ap.fecha >= StartDate
                     LEFT JOIN Justificacion j
                               ON b.idBeneficiario = j.beneficiario_idBeneficiario
                                   AND j.fechaJustificada >= StartDate
                                   AND j.fechaJustificada <= EndDate
            WHERE 	b.idBeneficiario = IdBeneficiary;
            -- Insercion en tabla de faltas de los beneficiario valido.
            IF IsAbsence=1 THEN
                INSERT INTO `REDO_MAKMA`.`Falta`
                (`fecha`,`status`,`beneficiario_idBeneficiario`)
                VALUES
                    (CURDATE(),1,IdBeneficiary);
            END IF;
            FETCH Absence_cursor INTO IdBeneficiary, IdFrequency;
        END WHILE;
    CLOSE Absence_cursor;
END$$
DELIMITER ;

-- EVENTO para la creacion de faltas de los beneficiarios diario
DELIMITER //
CREATE EVENT createAbsences
    ON SCHEDULE EVERY 1 DAY
        STARTS '2022-06-17 17:00:00'
    COMMENT 'Registra las faltas diarias de los beneficiarios que aplique segun su dia en que asiste y la frecuencia con la que asiste'
    DO
    BEGIN
        SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
        CALL `REDO_MAKMA`.`createAbsence`(); -- Llamado al procedure para crear faltas.
    END //
DELIMITER ;



-- Rutina para la verificacion de que un beneficiario pueda estar activo o no
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `checkBeneficiaryStatus`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `checkBeneficiaryStatus` (IN IdBeneficiary INT)
BEGIN
    DECLARE IsInactive INT DEFAULT (0); -- Variable para checar si esta inactivo segun las condiciones para que cambie a inactivo
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    SELECT IF(COUNT(*)>=4,1,0) INTO IsInactive
    FROM Falta WHERE beneficiario_idBeneficiario = IdBeneficiary AND status=1;
    -- Se verifica si cumple la primera condicion para que este inactivo el beneficiario (4 faltas)
    IF (IsInactive=1) THEN -- Se inactiva al beneficiario si cumple la condicion
        UPDATE `REDO_MAKMA`.`Beneficiario`
        SET `status` = 0 WHERE`idBeneficiario` = IdBeneficiary;
    ELSE -- Se verifica si cumple la segunda condicion para que permanezca inactivo el beneficiario (Fecha de vencimiento cumplida)
        SELECT IF(CURDATE()>fVencimiento,1,0) INTO IsInactive
        FROM Beneficiario
        WHERE idBeneficiario = IdBeneficiary;
        IF (IsInactive=1) THEN -- Se inactiva al beneficiario si cumple la condicion
            UPDATE `REDO_MAKMA`.`Beneficiario`
            SET `status` = 0 WHERE`idBeneficiario` = IdBeneficiary;
        END IF;
    END IF;
END$$

DELIMITER ;

-- EVENTO semanal para desactivar los beneficiarios si cumplen las condiciones al final de la semana
USE `REDO_MAKMA`;
DROP EVENT IF EXISTS `checkBeneficiaries`;

DELIMITER //
CREATE EVENT checkBeneficiaries
    ON SCHEDULE EVERY 1 WEEK
        STARTS '2022-06-19 17:00:00'
    COMMENT 'Cambia el status de los beneficiarios si cumplen las condiciones al final de la semana'
    DO
    BEGIN
        DECLARE IdBeneficiary INT;
        DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor.
        DECLARE BeneficiaryRevision_cursor CURSOR FOR -- Cursor obtener los ids de los beneficiarios
            SELECT b.idBeneficiario
            FROM Beneficiario b
            WHERE b.status = 1;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
        SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
        -- Apertura del cursor para inactivar beneficiarios que cumplan las condiciones
        OPEN BeneficiaryRevision_cursor;
        FETCH BeneficiaryRevision_cursor INTO IdBeneficiary;
        WHILE Flag = TRUE DO
                CALL `REDO_MAKMA`.`checkBeneficiaryStatus`(IdBeneficiary);
                FETCH BeneficiaryRevision_cursor INTO IdBeneficiary;
            END WHILE;
        CLOSE BeneficiaryRevision_cursor;
    END //
DELIMITER ;