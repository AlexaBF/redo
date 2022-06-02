-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: ASISTENCIA EN COMUNIDADES (AEC)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *28.1 Rutina para la visualización de las peticiones de paquetes por parte de las comunidades
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readRequests`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readRequests` (IN IdBranch INT)
BEGIN
    -- Visualización de las peticiones de paquetes por parte de las comunidades
    SELECT	p.idPeticion Id,
              DATE_FORMAT(p.fecha, '%d-%m-%Y') Fecha,
              p.cantPaquetesEnv PaquetesEnviados,
              c.nombre Comunidad,
              m.nombre MiembroComite,
              m.telefono Telefono
    FROM Peticion p
             LEFT JOIN Comunidad c
                       ON p.comunidad_idComunidad = c.idComunidad
             LEFT JOIN MiembroComite m
                       ON p.miembroComite_idMiembroComite = m.idMiembroComite
    WHERE p.fecha < LAST_DAY(NOW())
      AND p.fecha > CAST(DATE_FORMAT(NOW(),'%Y-%m-01') AS DATE)
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL)
    ORDER BY p.fecha DESC;
END$$

DELIMITER ;



-- *46.1 Rutina para la visualizacion de la informacion mensual de asistencia en comunidad (SIN TERMINAR EL REPORTE).
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
              rm.fechaInicio FechaInicio,
              rm.fechaFinal FechaFinal,
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
      AND c.sucursal_idSucursal = IdBranch
    GROUP BY rm.comunidad_idComunidad
    ORDER BY rm.fechaFinal, rm.comunidad_idComunidad ASC;
END$$

DELIMITER ;



-- *47.1 Rutina para la visualizacion de la informacion mensual de asistencia en comunidad (FINALIZADO EL REPORTE).
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readInactiveCommunityAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readInactiveCommunityAttendance`(IN IdBranch INT)
BEGIN
    -- Visualizacion de la informacion mensual de asistencia en comunidad (FINALIZADO EL REPORTE).
    -- Se rescatan los valores esperados en la tabla del sistema, ademñas de calcular el valor de los paquetes
    -- enviados a comunidad en el tiempo que duro el reporte activo.
    -- Se agrupa por comunidad y el id de reporte mensual debido a que pueden existir multiples reportes de la misma comunidad.
    -- Se calcula la cantidad de paquetes enviados dependiendo las fechas de inicio y fin de los reportes.
    SELECT 	rm.idReporteMensual Id,
              rm.fechaInicio FechaInicio,
              rm.fechaFinal FechaFinal,
              c.nombre Comunidad,
              rm.comunidad_idComunidad idComunidad,
              SUM(p.cantPaquetesEnv) PaquetesTotales,
              rm.cantFirmas AsistenciasTotales
    FROM ReporteMensual rm
             LEFT JOIN Comunidad c
                       ON rm.comunidad_idComunidad = c.idComunidad
             LEFT JOIN Peticion p
                       ON p.comunidad_idComunidad = rm.comunidad_idComunidad
    WHERE rm.status = 0
      AND p.fecha BETWEEN rm.fechaInicio AND rm.fechaFinal
      AND c.sucursal_idSucursal = IdBranch
    GROUP BY rm.comunidad_idComunidad, rm.idReporteMensual
    ORDER BY rm.fechaFinal DESC, rm.comunidad_idComunidad ASC;
END$$

DELIMITER ;



-- *25.1 Rutina para la visualización de las comunidades activas
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommunities`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommunities` (IN IdBranch INT)
    -- Cambio nombre: readActiveCommunities -> readCommunities
-- 25.1 Rutina para la visualización de las comunidades activas
BEGIN
    SELECT 	c.idComunidad Id,
              c.nombre Comunidad,
              m.idMunicipio IdMunicipio,
              m.municipio Municipio,
              e.idEstado IdEstado,
              e.estado Estado
    FROM Comunidad c
             LEFT JOIN Municipio m
                       ON c.municipio_idMunicipio = m.idMunicipio
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado
    WHERE c.status = 1
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL);
END$$

DELIMITER ;



-- *31.1 Rutina para la creacion de un nuevo municipio que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createTown`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createTown` (IN Name VARCHAR(60), IN IdState INT)
-- 31.1 Rutina para la creacion de un nuevo municipio que atiende el BAMX
BEGIN
    INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`)
    VALUES (UPPER(Name), IdState);
END$$

DELIMITER ;



-- *32.1 Rutina para la visualización del catalogo de estados que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readStates`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readStates` ()
-- 32.1 Rutina para la visualización del catalogo de estados que atiende el BAMX
BEGIN
    SELECT 	idEstado Id,
              estado Estado
    FROM Estado;
END$$

DELIMITER ;



-- *33.1 Rutina para la visualización del catalogo de municipios que atiende el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readTowns`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readTowns` ()
-- 33.1 Rutina para la visualización del catalogo de municipios que atiende el BAMX
BEGIN
    SELECT 	m.idMunicipio Id,
              m.municipio Municipio,
              e.estado Estado
    FROM Municipio m
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado;
END$$

DELIMITER ;



-- *34.1 Rutina para la creacion de comunidad que es o sera atendida por el BAMX
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createCommunity`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createCommunity` (IN Name VARCHAR(40), IN IdBranch INT, IN IdTown INT, IN IdFrequency INT)
-- 34.1 Rutina para la creacion de comunidad que es o sera atendida por el BAMX
BEGIN
    INSERT INTO `REDO_MAKMA`.`Comunidad`
    (`nombre`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
    VALUES (UPPER(Name), IdBranch, IdTown, IdFrequency);
END$$

DELIMITER ;



-- *35.1 Rutina para la visualizacion del catalogo de miembros de comite de cada comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommitteeMembers`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommitteeMembers` (IN idCommunity INT)
-- 35.1 Rutina para la visualizacion del catalogo de miembros de comite de cada comunidad.
BEGIN
    SELECT 	idMiembroComite Id,
              nombre Nombre,
              telefono Telefono
    FROM MiembroComite
    WHERE 	(comunidad_idComunidad = idCommunity
        OR comunidad_idComunidad IS NULL);
END$$

DELIMITER ;




-- *36.1 Rutina para la creacion de una peticion hecha por una comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createRequest`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createRequest` (IN QuantityOfPackages INT, IN IdCommunity INT, IN IdCommitteeMember INT)
-- 36.1 Rutina para la creacion de una peticion hecha por una comunidad.
BEGIN
    INSERT INTO `REDO_MAKMA`.`Peticion`
    (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`)
    VALUES( CURDATE(), QuantityOfPackages, IdCommunity, IdCommitteeMember);
END$$

DELIMITER ;



-- *37.1 Rutina para la creacion de miembros de comite de cada comunidad.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createCommitteeMember`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createCommitteeMember`(IN Name VARCHAR(60), IN PhoneNumber VARCHAR(12), IN IdCommunity INT)
-- 37.1 Rutina para la creacion de miembros de comite de cada comunidad.
BEGIN
    INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`)
    VALUES (UPPER(Name), PhoneNumber, IdCommunity);
END $$

DELIMITER ;