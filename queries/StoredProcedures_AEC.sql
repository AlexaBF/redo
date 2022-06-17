-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: ASISTENCIA EN COMUNIDADES (AEC)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualización de las peticiones de paquetes por parte de las comunidades
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readRequests`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readRequests` (IN IdBranch INT)
BEGIN
    DECLARE IdCommunityOfReport INT;
    DECLARE StartDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor.
    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion necesaria de los reportes validos.
    DECLARE readRequests_cursor CURSOR FOR
        SELECT 	rm.fechaInicio, rm.comunidad_idComunidad
        FROM ReporteMensual rm
                 LEFT JOIN Comunidad c
                           ON rm.comunidad_idComunidad = c.idComunidad
        WHERE	(c.sucursal_idSucursal = IdBranch
            OR c.sucursal_idSucursal IS NULL)
          AND rm.status = 1
        ORDER BY rm.fechaInicio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    OPEN readRequests_cursor;
    FETCH readRequests_cursor INTO StartDate, IdCommunityOfReport;
    WHILE Flag = TRUE DO
        -- Obtencion de todas las peticiones de ese reporte activo, se hace con otro procedure por que al ponder ser mas de
        -- una peticion hasta que cierre el reporte, no se podria hacer todo el proceso en uno solo.
            CALL `REDO_MAKMA`.`readRequest`(StartDate, IdCommunityOfReport);
            FETCH readRequests_cursor INTO StartDate, IdCommunityOfReport;
        END WHILE;
    CLOSE readRequests_cursor;
    -- Visualizacion de todo el contenido insertado en la tabla exceptuando el id de la misma.
    SELECT 	r.IdPeticion Id, DATE_FORMAT(r.Fecha, '%d-%m-%Y') Fecha, r.PaquetesEnviados, r.Comunidad, r.MiembroComite, r.Telefono
    FROM readRequests r
    ORDER BY r.Fecha DESC;
    -- Eliminacion de la tabla para que no ocupe espacio extra en el servidor donde se aloja la BD.
    DROP TABLE IF EXISTS `readRequests`;
END$$

DELIMITER ;



-- Rutina para la visualizacion de la informacion mensual de asistencia en comunidad (SIN TERMINAR EL REPORTE).
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readActiveCommunityAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readActiveCommunityAttendance` (IN IdBranch INT)
BEGIN
    -- Visualizacion de la informacion mensual de asistencia en comunidad (SIN TERMINAR EL REPORTE).
    -- Se rescatan los valores esperados en la tabla del sistema, ademas de calcular el valor de los paquetes
    -- enviados a comunidad desde el ultimo reporte cerrado hasta la fecha.
    -- Se agrupa solamente por comunidad y el calculo de la cantidad de paquetes es despues del inicio del reporte activo del mes.
    SELECT 	rm.idReporteMensual Id,
              DATE_FORMAT(rm.fechaInicio, '%d-%m-%Y') FechaInicio,
              DATE_FORMAT(rm.fechaFinal, '%d-%m-%Y') FechaFinal,
              c.nombre Comunidad,
              rm.comunidad_idComunidad idComunidad,
              SUM(p.cantPaquetesEnv) PaquetesTotales,
              rm.cantFirmas AsistenciasTotales
    FROM ReporteMensual rm
             LEFT JOIN Comunidad c
                       ON rm.comunidad_idComunidad = c.idComunidad
             LEFT JOIN Peticion p
                       ON p.comunidad_idComunidad = rm.comunidad_idComunidad
    WHERE rm.status = 1
      AND p.fecha >= rm.fechaInicio
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL)
    GROUP BY rm.comunidad_idComunidad
    ORDER BY rm.fechaFinal DESC, rm.comunidad_idComunidad ASC;
END$$

DELIMITER ;



-- Rutina para la insercion de listas de asistencia de un reporte especifico.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateCommunityReportDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateCommunityReportDocs` (IN IdReport INT, IN Signatures INT, IN Name VARCHAR(70), IN Data MEDIUMBLOB, IN Size DOUBLE, IN Mimetype VARCHAR(20))
BEGIN
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Insercion del archivo de listas de asistencia para completar los reportes de comunidades por peticiones de paquetes.
    INSERT INTO `REDO_MAKMA`.`ListaAsistencia`
    (`nombre`, `data`, `size`, `mimetype`, `reporteMensual_idReporteMensual`)
    VALUES (Name, Data, Size, Mimetype, IdReport);

    UPDATE 	`REDO_MAKMA`.`ReporteMensual`
    SET 	`fechaFinal` = CURDATE(),
           `status` = 0,
           `cantFirmas` = Signatures
    WHERE 	`idReporteMensual` = IdReport;
END$$

DELIMITER ;



-- Rutina para la creacion de comunidad que es o sera atendida por el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createCommunity`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createCommunity` (IN Name VARCHAR(40), IN IdBranch INT, IN IdTown INT, IN IdFrequency INT)
BEGIN
    -- Creacion de comunidad que es o sera atendida por el BAMX
    INSERT INTO `REDO_MAKMA`.`Comunidad`
    (`nombre`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
    VALUES (UPPER(Name), IdBranch, IdTown, IdFrequency);
END$$

DELIMITER ;



-- Rutina para la visualización del catalogo de estados que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readStates`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readStates` ()
BEGIN
    -- Visualización del catalogo de estados que atiende el BAMX
    SELECT 	idEstado Id,
              estado Estado
    FROM Estado;
END$$

DELIMITER ;



-- Rutina para la visualización del catalogo de municipios que atiende el BAMX por estado
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readTownByState`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readTownByState` (IN IdState INT)
BEGIN
    -- Visualización del catalogo de municipios por Estados
    SELECT 	m.idMunicipio Id,
              m.municipio Municipio
    FROM Municipio m
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado
    WHERE e.idEstado = IdState
    ORDER BY m.municipio DESC;
END$$

DELIMITER ;



-- Rutina para la visualizacion del catálogo de frecuencias de asistencia de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readFrequencies`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readFrequencies` ()
BEGIN
    -- Visualizacion del catálogo de frecuencias de asistencia de los beneficiarios
    SELECT 	idFrecuenciaVisita Id,
              frecuencia Frecuencia
    FROM FrecuenciaVisita;
END$$

DELIMITER ;



-- Rutina para la creacion de miembros de comite de cada comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createCommitteeMember`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createCommitteeMember`(IN Name VARCHAR(60), IN PhoneNumber VARCHAR(12), IN IdCommunity INT)
BEGIN
    -- Creacion de miembros de comite de cada comunidad.
    INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`)
    VALUES (UPPER(Name), PhoneNumber, IdCommunity);
END $$

DELIMITER ;



-- Rutina para la visualización de las comunidades activas
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommunities`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommunities` (IN IdBranch INT)
BEGIN
    -- Visualización de las comunidades activas
    SELECT 	c.idComunidad Id,
              c.nombre Comunidad
    FROM Comunidad c
             LEFT JOIN Municipio m
                       ON c.municipio_idMunicipio = m.idMunicipio
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado
    WHERE c.status = 1
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL)
    ORDER BY c.nombre DESC;
END$$

DELIMITER ;



-- Rutina para la creacion de una peticion hecha por una comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createRequest`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createRequest` (IN QuantityOfPackages INT, IN IdCommunity INT, IN IdCommitteeMember INT)
BEGIN
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Creacion de una peticion hecha por una comunidad.
    INSERT INTO `REDO_MAKMA`.`Peticion`
    (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`)
    VALUES( CURDATE(), QuantityOfPackages, IdCommunity, IdCommitteeMember);
END$$

DELIMITER ;



-- Rutina para la visualizacion del catalogo de miembros de comite de cada comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommitteeMembers`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommitteeMembers` (IN idCommunity INT)
BEGIN
    -- Visualizacion del catalogo de miembros de comite de cada comunidad.
    SELECT 	idMiembroComite Id,
              nombre Nombre,
              telefono Telefono
    FROM MiembroComite
    WHERE 	(comunidad_idComunidad = idCommunity
        OR comunidad_idComunidad IS NULL)
    ORDER BY nombre DESC;
END$$

DELIMITER ;