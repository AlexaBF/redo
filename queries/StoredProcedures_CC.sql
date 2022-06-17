-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: COMUNIDADES Y COMITÉS (CC)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualizacion del catalogo de miembros de comite de cada comunidad y su informacion.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommitteeMember`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommitteeMember` (IN IdBranch INT)
BEGIN
    -- Visualizacion del catalogo de miembros de comite de cada comunidad y su informacion segun la sucursal.
    SELECT 	m.nombre Nombre,
              m.telefono Telefono,
              c.nombre Comunidad
    FROM MiembroComite m
             LEFT JOIN Comunidad c
                       ON m.comunidad_idComunidad = c.idComunidad
    WHERE c.status = 1
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL)
    ORDER BY c.nombre DESC;
END$$

DELIMITER ;


-- Rutina para la visualización de las comunidades activas y su informacion
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommunity`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommunity` (IN IdBranch INT)
BEGIN
    -- Visualización de las comunidades activas
    SELECT 	c.idComunidad Id,
              c.nombre Comunidad,
              m.idMunicipio IdMunicipio,
              m.municipio Municipio,
              e.idEstado IdEstado,
              e.estado Estado,
              f.frecuencia Frecuencia
    FROM Comunidad c
             LEFT JOIN Municipio m
                       ON c.municipio_idMunicipio = m.idMunicipio
             LEFT JOIN Estado e
                       ON m.estado_idEstado = e.idEstado
             LEFT JOIN FrecuenciaVisita f
                       ON f.idFrecuenciaVisita = c.frecuenciaVisita_idFrecuenciaVisita
    WHERE c.status = 1
      AND (c.sucursal_idSucursal = IdBranch
        OR c.sucursal_idSucursal IS NULL)
    ORDER BY c.nombre DESC;
END$$

DELIMITER ;