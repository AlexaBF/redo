-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: OTROS (O)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la creacion de una nueva frecuencia de asistencia
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createFrequency` (IN Frequency VARCHAR(20))
BEGIN
    -- Creacion de una nueva frecuencia de asistencia
    INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`)
    VALUES (UPPER(Frequency));
END$$

DELIMITER ;



-- Rutina para la actualizacion de una frecuencia de asistencia segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateFrequency` (IN IdFrequency INT, IN Frequency VARCHAR(20))
BEGIN
    -- Actualizacion de una frecuencia de asistencia segun su id
    UPDATE `REDO_MAKMA`.`FrecuenciaVisita`
    SET `frecuencia` = UPPER(Frequency)
    WHERE `idFrecuenciaVisita` = IdFrequency;
END$$

DELIMITER ;



-- Rutina para la eliminacion de una frecuencia de asistencia
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteFrequency` (IN IdFrequency INT)
BEGIN
    -- Eliminacion de una frecuencia de asistencia
    DELETE FROM `REDO_MAKMA`.`FrecuenciaVisita`
    WHERE `idFrecuenciaVisita` = IdFrequency;
END$$

DELIMITER ;



-- Rutina para la creacion de un nuevo grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createDay` (IN Day VARCHAR(20))
BEGIN
    -- Creacion de un nuevo grupo de beneficiarios basado en el dia que recogen su paquete
    INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`)
    VALUES (UPPER(Day));
END$$

DELIMITER ;



-- Rutina para la actualizacion de un grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateDay` (IN Id INT, IN Day VARCHAR(20))
BEGIN
    -- Actualizacion de un grupo de beneficiarios basado en el dia que recogen su paquete
    UPDATE `REDO_MAKMA`.`GrupoDia`
    SET `grupo` = UPPER(Day)
    WHERE `idGrupoDia` = Id;
END$$

DELIMITER ;



-- Rutina para la eliminacion de un grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteDay` (IN Id INT)
BEGIN
    -- Eliminacion de un grupo de beneficiarios basado en el dia que recogen su paquete
    DELETE FROM `REDO_MAKMA`.`GrupoDia`
    WHERE `idGrupoDia` = Id;
END$$

DELIMITER ;



-- Rutina para la eliminacion de un beneficiario segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteBeneficiary` (IN IdBeneficiary INT)
BEGIN
    -- Eliminacion de un beneficiario segun su id
    DELETE FROM `REDO_MAKMA`.`Beneficiario`
    WHERE `idBeneficiario` = IdBeneficiary;
END$$

DELIMITER ;




-- Rutina para la creacion de un nuevo municipio que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createTown`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createTown` (IN Name VARCHAR(60), IN IdState INT)
BEGIN
    -- Creacion de un nuevo municipio que atiende el BAMX
    INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`)
    VALUES (Name, IdState);
END$$

DELIMITER ;



-- Rutina para la visualización de los datos relevantes de un usuario por sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUsersBranch`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUsersBranch` (IN IdBranch INT)
BEGIN
    -- Visualización de los datos relevantes de un usuario por sucursales
    SELECT 	u.idUsuario Id,
              u.nombre Nombre,
              u.correo Correo,
              u.telefono Numero,
              r.tipo Rol,
              u.rol_idRol IdRol,
              s.nombre Sucursal,
              u.sucursal_idSucursal IdSucursal
    FROM 	Usuario u
                LEFT JOIN Rol r
                          ON 		u.rol_idRol = r.idRol
                LEFT JOIN Sucursal s
                          ON 		u.sucursal_idSucursal = s.idSucursal
    WHERE 	u.sucursal_idSucursal IN (IdBranch);
END$$

DELIMITER ;



-- Rutina para visualizacion de todos los beneficiarios de una sucursal
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaries` (IN IdBranch INT)
BEGIN
    -- Visualizacion de todos los beneficiarios y su informacion que sean de una sucursal especifica o que no tenga ninguna
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status, -- Status en formato descriptivo
           b.status IdStatus, -- Status en formato numerico
           IF( b.beca, "CON BECA", "SIN BECA") Beca,  -- Beca en formato descriptivo
           b.beca IdBeca, -- Beca en formato numerico
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           b.telefono Telefono,
           f.frecuencia Frecuencia, -- Frecuencia en formato descriptivo
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia, -- Frecuencia en formato numerico
           g.grupo Dia, -- Grupo dia en formato descriptivo
           b.grupoDia_idGrupoDia IdDia, -- Grupo dia en formato numerico
           s.nombre Sucursal, -- Sucursal en formato descriptivo
           b.sucursal_idSucursal IdSucursal -- Sucursal en formato numerico
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
    WHERE b.Sucursal_idSucursal = IdBranch
       OR b.sucursal_idSucursal IS NULL;
END$$

DELIMITER ;



-- Rutina para la obtencion de todos los archivos de credenciales de los beneficiarios.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaryDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaryDocs` (IN IdBranch INT)
BEGIN
    -- visualizacion de las credenciales de todos los beneficiarios.
    SELECT c.idCredencial IdCredencial,
           c.beneficiario_idBeneficiario IdBeneficiario,
           c.nombre Nombre,
           c.data Data,
           c.size Size,
           c.mimetype Mimetype
    FROM Credencial c
             LEFT JOIN Beneficiario b
                       ON b.idBeneficiario = c.beneficiario_idBeneficiario
    WHERE b.status = 1
      AND b.sucursal_idSucursal = IdBranch;
END$$

DELIMITER ;



-- Rutina para la actualizacion datos generales (General Data) del beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiaryGD`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiaryGD` (IN IdBeneficiary INT, IN aGrant TINYINT(1), IN PhoneNumber VARCHAR(12), IN IdDay INT, IN IdFrequency INT)
BEGIN
    -- Actualizacion de los datos generales de un beneficiario que son opcionales de poner/cambiar en el sistema
    UPDATE 	`REDO_MAKMA`.`Beneficiario`
    SET 	`beca` = aGrant,
           `telefono` = PhoneNumber,
           `grupoDia_idGrupoDia`= IdDay,
           `frecuenciaVisita_idFrecuenciaVisita`= IdFrequency
    WHERE 	`idBeneficiario` = IdBeneficiary;
END$$

DELIMITER ;



-- Rutina para visualizacion de uno de los beneficiarios segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiary` (IN IdBeneficiary INT)
BEGIN
    -- Visualizacion de uno los beneficiarios y su informacion que sean de una sucursal especifica o que no tenga ninguna
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status, -- Status en formato descriptivo
           b.status IdStatus, -- Status en formato numerico
           IF( b.beca, "CON BECA", "SIN BECA") Beca,  -- Beca en formato descriptivo
           b.beca IdBeca, -- Beca en formato numerico
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           b.telefono Telefono,
           f.frecuencia Frecuencia, -- Frecuencia en formato descriptivo
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia, -- Frecuencia en formato numerico
           g.grupo Dia, -- Grupo dia en formato descriptivo
           b.grupoDia_idGrupoDia IdDia, -- Grupo dia en formato numerico
           s.nombre Sucursal, -- Sucursal en formato descriptivo
           b.sucursal_idSucursal IdSucursal -- Sucursal en formato numerico
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
    WHERE b.idBeneficiario = IdBeneficiary;
END$$

DELIMITER ;



-- Rutina para la visualizacion del catálogo de grupo por dias de asistencia de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readDays`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readDays` ()
BEGIN
    -- Visualizacion del catálogo de grupo por dias de asistencia de los beneficiarios
    SELECT	idGrupoDia Id,
              grupo Grupo
    FROM GrupoDia;
END$$

DELIMITER ;



-- Rutina para la obtencion de todos los archivos de listas de asistencia de reportes activos.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommunityReportDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommunityReportDocs` (IN IdBranch INT, IN Status TINYINT)
BEGIN
    -- Obtencion de todos los archivos de listas de asistencia de reportes dependiendo status y sucursal.
    SELECT l.idListaAsistencia IdListaAsistencia,
           l.reporteMensual_idReporteMensual IdReporteMensual,
           l.nombre Nombre,
           l.data Data,
           l.size Size,
           l.mimetype Mimetype
    FROM ReporteMensual r
             LEFT JOIN ListaAsistencia l
                       ON r.idReporteMensual = l.reporteMensual_idReporteMensual
             LEFT JOIN Comunidad c
                       ON r.comunidad_idComunidad = c.idComunidad
    WHERE r.status = Status
      AND c.sucursal_idSucursal = IdBranch;
END$$

DELIMITER ;



-- Rutina para la visualización del catalogo de municipios que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readTowns`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readTowns` ()
BEGIN
    -- Visualización del catalogo de todos municipios
    SELECT 	m.idMunicipio Id,
              m.municipio Municipio,
              e.estado Estado
    FROM Municipio m
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado;
END$$

DELIMITER ;



-- Rutina para la visualizacion de un usuario segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUser` (IN IdUser INT)
BEGIN
    -- Visualizacion de un usuario segun su id
    SELECT 	u.idUsuario Id,
              u.nombre Nombre,
              u.correo Correo,
              u.telefono Numero,
              r.tipo Rol,
              u.rol_idRol IdRol,
              s.nombre Sucursal,
              u.sucursal_idSucursal IdSucursal
    FROM Usuario u
             LEFT JOIN Rol r
                       ON u.rol_idRol = r.idRol
             LEFT JOIN Sucursal s
                       ON u.sucursal_idSucursal = s.idSucursal
    WHERE u.idUsuario = IdUser;
END$$

DELIMITER ;



-- Rutina para la visualizacion de asistencia de beneficiarios en Cajero
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readRollCall`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readRollCall` (IN IdBranch INT)
BEGIN
    -- Visualizacion de asistencia de beneficiarios en Cajero
    -- Declaracion de variables ha utilizar para obtener la informacion del cursor y auxiliares para
    -- obtener la asistencia de cada beneficiario dependiendo de la frecuencia con la que visita el BAMX.
    DECLARE IdBeneficiario INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Nombre VARCHAR(60);
    DECLARE IdAsistencia INT;
    DECLARE Asistencia VARCHAR(2);
    DECLARE IdJustificacion INT;
    DECLARE Justificacion VARCHAR(2);

    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor

    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion los beneficiarios
    DECLARE RollCall_cursor CURSOR FOR
        SELECT 	b.idBeneficiario,
                  b.folio,
                  b.nombre,
                  b.frecuenciaVisita_idFrecuenciaVisita
        FROM Beneficiario b
                 LEFT JOIN AsistenciaPunto ap
                           ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                 LEFT JOIN Justificacion j
                           ON b.idBeneficiario = j.beneficiario_idBeneficiario
        WHERE 	(b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
          AND b.status = 1
        GROUP BY b.idBeneficiario, b.folio
        ORDER BY b.folio, ap.fecha ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere la tabla del sistema.
    DROP TEMPORARY TABLE IF EXISTS `RollCall`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `RollCall`(
                                                       `id` INT NOT NULL AUTO_INCREMENT,
                                                       `IdBeneficiario` INT,
                                                       `Folio` VARCHAR(13),
                                                       `Nombre` VARCHAR(60),
                                                       `IdAsistencia` TINYINT(1),
                                                       `Asistencia` VARCHAR(2),
                                                       `IdJustificacion` TINYINT(1),
                                                       `Justificacion` VARCHAR(2),
                                                       PRIMARY KEY (`id`)
    );
    -- Apertura del cursor para empezar a recorrer lo que contiene de la query para saber datos generales del usuario sin meter la asistencia.
    OPEN RollCall_cursor;
    FETCH RollCall_cursor INTO IdBeneficiario, Folio, Nombre, IdFrequency;
    WHILE Flag = TRUE DO
            -- Obtencion del marco de tiempo en fechas de la frecuencia de tiempo de cada beneficiario
            CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
            -- Obtencion de si asistio o no dependiendo del tiempo en fechas obtenido previamente
            SELECT 	IF(ap.fecha >= StartDate
                             AND ap.fecha <= EndDate,1, 0),
                      IF(ap.fecha >= StartDate
                             AND ap.fecha <= EndDate,"Si", "No"),
                      IF (j.fechaJustificada >= StartDate
                              AND j.fechaJustificada <= EndDate, 1, 0),
                      IF (j.fechaJustificada >= StartDate
                              AND j.fechaJustificada <= EndDate, "Si", "No")
            INTO IdAsistencia, Asistencia, IdJustificacion, Justificacion
            FROM Beneficiario b
                     LEFT JOIN AsistenciaPunto ap
                               ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                                   AND ap.fecha >= StartDate
                     LEFT JOIN Justificacion j
                               ON b.idBeneficiario = j.beneficiario_idBeneficiario
                                   AND j.fechaJustificada >= StartDate
            WHERE 	(b.sucursal_idSucursal = IdBranch
                OR b.sucursal_idSucursal IS NULL)
              AND b.status = 1
              AND b.idBeneficiario = IdBeneficiario
            GROUP BY b.idBeneficiario, b.folio
            ORDER BY b.folio, ap.fecha ASC;
            -- Insercion en tabla temporal los datos generales y la informacion de asistencia unico de cada beneficiario.
            INSERT INTO `REDO_MAKMA`.`RollCall`
            (`IdBeneficiario`, `Folio`, `Nombre`, `IdAsistencia`, `Asistencia`, `IdJustificacion`, `Justificacion`)
            VALUES (IdBeneficiario, Folio, Nombre, IdAsistencia, Asistencia, IdJustificacion, Justificacion);
            FETCH RollCall_cursor INTO IdBeneficiario, Folio, Nombre, IdFrequency;
        END WHILE;
    CLOSE RollCall_cursor;
    -- Select de todo lo de la tabla excepto el id de la misma para mandar la info a la tabla del sistema.
    SELECT r.IdBeneficiario, r.Folio, r.Nombre, r.IdAsistencia, r.Asistencia, r.IdJustificacion, r.Justificacion FROM RollCall r;
    DROP TABLE IF EXISTS `RollCall`;
END$$

DELIMITER ;