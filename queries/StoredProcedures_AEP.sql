-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: ASISTENCIA EN PUNTO (AEP)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualizacion de beneficiarios que asistieron o justificaron en esa semana.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAttendance` (IN IdBranch INT)
BEGIN
    -- Visualizacion de beneficiarios que asistieron o justificaron en el periodo que le corresponde.
    -- Declaracion de variables ha utilizar para obtener la informacion del cursor durante el FETCH
    -- y auxiliares para el proceso y validaciones.
    DECLARE IdBeneficiary INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Name VARCHAR(60);
    DECLARE Frequency VARCHAR(20);
    DECLARE Day VARCHAR(20);
    DECLARE DayAttendance DATE;
    DECLARE IdAttendance INT;
    DECLARE Attendance VARCHAR(2);
    DECLARE IdJustification INT;
    DECLARE Justification VARCHAR(2);
    DECLARE IdDay INT;
    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor.
    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion beneficiarios validos.
    DECLARE Attendance_cursor CURSOR FOR
        SELECT 	b.idBeneficiario,
                  b.folio,
                  b.nombre,
                  f.frecuencia,
                  g.grupo,
                  b.grupoDia_idGrupoDia,
                  b.frecuenciaVisita_idFrecuenciaVisita
        FROM Beneficiario b
                 LEFT JOIN FrecuenciaVisita f
                           ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
                 LEFT JOIN GrupoDia g
                           ON b.grupoDia_idGrupoDia = g.idGrupoDia
        WHERE 	(b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
          AND b.status = 1
        GROUP BY b.idBeneficiario, b.folio
        ORDER BY b.folio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- manipulacion de los datos en API y FRONT.
    DROP TEMPORARY TABLE IF EXISTS `readAttendance`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `readAttendance`(
                                                             `id` INT NOT NULL AUTO_INCREMENT,
                                                             `IdBeneficiario` INT,
                                                             `Folio` VARCHAR(13),
                                                             `Nombre` VARCHAR(60),
                                                             `Frecuencia` VARCHAR(20),
                                                             `Dia` VARCHAR(20),
                                                             `IdAsistencia` TINYINT(1),
                                                             `Asistencia` VARCHAR(2),
                                                             `IdJustificacion` TINYINT(1),
                                                             `Justificacion` VARCHAR(2),
                                                             `IdD` INT,
                                                             PRIMARY KEY (`id`)
    );
    -- Apertura del cursor para empezar a recorrer lo que contiene el cursor. Se usa cursor por las diferentes frecuencias
    -- que maneja cada beneficiario.
    OPEN Attendance_cursor;
    FETCH Attendance_cursor INTO IdBeneficiary, Folio, Name, Frequency, Day, IdDay, IdFrequency;
    WHILE Flag = TRUE DO
            -- Obtencion del marco de tiempo en fechas de la frecuencia de tiempo especifica de cada beneficiario.
            CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
            -- Obtencion de si asistio o no (o si tiene o no justificacion) dependiendo del tiempo en fechas obtenido previamente.
            SELECT 	IF(ap.fecha >= StartDate AND ap.fecha <= EndDate,1, 0),
                      IF(ap.fecha >= StartDate AND ap.fecha <= EndDate,"Si", "No"),
                      IF(COUNT(j.fechaJustificada >= StartDate AND j.fechaJustificada <= EndDate) >= 1, 1, 0),
                      IF(COUNT(j.fechaJustificada >= StartDate AND j.fechaJustificada <= EndDate) >= 1, "Si", "No")
            INTO IdAttendance, Attendance, IdJustification, Justification
            FROM Beneficiario b
                     LEFT JOIN AsistenciaPunto ap
                               ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                                   AND ap.fecha >= StartDate
                     LEFT JOIN Justificacion j
                               ON b.idBeneficiario = j.beneficiario_idBeneficiario
                                   AND j.fechaJustificada >= StartDate
            WHERE b.idBeneficiario IN (IdBeneficiary);
            -- Insercion en tabla temporal los datos generales y la informacion de asistencia de cada beneficiario valido.
            INSERT INTO `REDO_MAKMA`.`readAttendance`
            (`IdBeneficiario`, `Folio`, `Nombre`, `Frecuencia`, `Dia`, `IdAsistencia`, `Asistencia`, `IdJustificacion`, `Justificacion`, `IdD`)
            VALUES (IdBeneficiary, Folio, Name, Frequency, Day, IdAttendance, Attendance, IdJustification, Justification, IdDay);
            FETCH Attendance_cursor INTO IdBeneficiary, Folio, Name, Frequency, Day, IdDay, IdFrequency;
        END WHILE;
    CLOSE Attendance_cursor;
    -- Visualizacion de todo el contenido insertado en la tabla exceptuando el id de la misma.
    SELECT 	a.IdBeneficiario, a.Folio, a.Nombre, a.Frecuencia, a.Dia, a.IdAsistencia,
              a.Asistencia, a.IdJustificacion, a.Justificacion
    FROM readAttendance a
    ORDER BY a.Folio ASC, a.IdBeneficiario ASC;
    -- Eliminacion (por si acaso, ya que es una tabla temporal) de la tabla para que no ocupe espacio extra en el servidor donde se aloja la BD.
    DROP TEMPORARY TABLE IF EXISTS `readAttendance`;
END$$

DELIMITER ;



-- Rutina para la Creacion y Eliminacion de asistencias en el sistema (Logica completa).
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `attendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `attendance` (IN Folio VARCHAR(13), IN Attendance TINYINT(1))
BEGIN
    -- Administracion para la creacion y eliminacion de asistencias en el sistema.
    -- Declaracion de variables para auxiliar las validaciones de creacion o eliminacion de asistencias.
    DECLARE IdBeneficiary INT;
    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE cAttendance INT;
    DECLARE cAbsence INT;
    DECLARE Status TINYINT(1);
    -- Se obtiene el id del beneficiario y su frecuencia de visita a traves de su folio, se usa el id y la frecuencia para
    -- el registro y eliminacion de asistencias y procedimientos necesarios por consecuencia.
    SELECT b.idBeneficiario, b.frecuenciaVisita_idFrecuenciaVisita, b.status INTO IdBeneficiary, IdFrequency, Status
    FROM Beneficiario b WHERE b.folio = Folio;
    -- Obtencion del marco de tiempo en fechas de la frecuencia de tiempo especifica del beneficiario.
    CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
    -- Se revisa si hay o no asistencia por parte del beneficiario.
    SELECT COUNT(*) INTO cAttendance
    FROM AsistenciaPunto ap
    WHERE ap.beneficiario_idBeneficiario = IdBeneficiary
      AND ap.fecha BETWEEN StartDate AND EndDate;
    -- Se revisa si tiene una falta previa por parte del beneficiario en su marco de tiempo.
    SELECT COUNT(*) INTO cAbsence
    FROM Falta f
    WHERE f.beneficiario_idBeneficiario = IdBeneficiary
      AND f.fecha BETWEEN StartDate AND EndDate;
    -- Se hace la logica de Crear o Eliminar una asistencia.
    IF Status = 0 THEN -- si el beneficiario esta activo o no.
        SELECT "El beneficiario esta inactivo" message,
               FALSE done;
    ELSEIF Attendance = 1 THEN -- 1 -> Si lo que se quiere hacer es registrar una asistencia.
        SET time_zone='America/Mexico_City';
        IF cAttendance = 0 THEN -- si no existe asistencia previa, ya que no puede haber mas de 1 asistencia por marco de tiempo.
            CALL `REDO_MAKMA`.`createAttendance`(IdBeneficiary);
            IF (cAbsence >= 1) THEN -- Se elimina la falta si existe previamente.
                CALL `REDO_MAKMA`.`deleteAbsence`(IdBeneficiary, StartDate, EndDate);
            END IF;
            CALL `REDO_MAKMA`.`updateAbscenceStatus`(0, IdBeneficiary); -- Stored procedure para actualizar de status las faltas, el 0 indica que se desactivan
            SELECT "Se registro correctamente la asistencia" message,
                   TRUE done;
        ELSE -- Si se tiene una asistencia previa, no se puede hacer el registro de asistencia.
            SELECT "El beneficiario ya tiene una asistencia reciente" message,
                   FALSE done;
        END IF;
    ELSEIF Attendance = 0 THEN -- 0 -> Si lo que se quiere hacer es eliminar una asistencia.
        IF cAttendance = 1 THEN -- Si existe una asistencia que eliminar en el marco de tiempo dado.
            CALL `REDO_MAKMA`.`deleteAttendance`(IdBeneficiary, StartDate, EndDate);
            CALL `REDO_MAKMA`.`updateAbscenceStatus`(1, IdBeneficiary); -- Stored procedure para actualizar de status las faltas, el 0 indica que se reactivan
            SELECT "Se elimino correctamente la asistencia" message,
                   TRUE done;
        ELSE -- Si no existe una asistencia que eliminar, entonces no se puede completar la accion de eliminar.
            SELECT "El beneficiario no tiene una asistencia reciente que eliminar" message,
                   FALSE done;
        END IF;
    END IF;
END$$

DELIMITER ;