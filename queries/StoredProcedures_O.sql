-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: OTROS (O)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *18.1 Rutina para la creacion de una nueva frecuencia de asistencia
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createFrequency` (IN Frequency VARCHAR(20))
-- 18.1 Rutina para la creacion de una nueva frecuencia de asistencia
BEGIN
    INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`)
    VALUES (UPPER(Frequency));
END$$

DELIMITER ;



-- *19.1 Rutina para la actualizacion de una frecuencia de asistencia segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateFrequency` (IN Id INT, IN Frequency VARCHAR(20))
-- 19.1 Rutina para la actualizacion de una frecuencia de asistencia segun su id
BEGIN
    UPDATE `REDO_MAKMA`.`FrecuenciaVisita`
    SET `frecuencia` = UPPER(Frequency)
    WHERE `idFrecuenciaVisita` = Id;
END$$

DELIMITER ;



-- *20.1 Rutina para la eliminacion de una frecuencia de asistencia
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteFrequency`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteFrequency` (IN Id INT)
-- 20.1 Rutina para la eliminacion de una frecuencia de asistencia
BEGIN
    DELETE FROM `REDO_MAKMA`.`FrecuenciaVisita`
    WHERE `idFrecuenciaVisita` = Id;
END$$

DELIMITER ;



-- *21.1 Rutina para la creacion de un nuevo grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createDay` (IN Day VARCHAR(20))
-- 21.1 Rutina para la creacion de un nuevo grupo de beneficiarios basado en el dia que recogen su paquete
BEGIN
    INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`)
    VALUES (UPPER(Day));
END$$

DELIMITER ;



-- *22.1 Rutina para la actualizacion de un grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateDay` (IN Id INT, IN Day VARCHAR(20))
-- 22.1 Rutina para la actualizacion de un grupo de beneficiarios basado en el dia que recogen su paquete
BEGIN
    UPDATE `REDO_MAKMA`.`GrupoDia`
    SET `grupo` = UPPER(Day)
    WHERE `idGrupoDia` = Id;
END$$

DELIMITER ;



-- *23.1 Rutina para la eliminacion de un grupo de beneficiarios basado en el dia que recogen su paquete
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteDay`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteDay` (IN Id INT)
-- 23.1 Rutina para la eliminacion de un grupo de beneficiarios basado en el dia que recogen su paquete
BEGIN
    DELETE FROM `REDO_MAKMA`.`GrupoDia`
    WHERE `idGrupoDia` = Id;
END$$

DELIMITER ;



-- 10.1 Rutina para la eliminacion de un beneficiario segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteBeneficiaries` (IN Id INT)
BEGIN
    DELETE FROM `REDO_MAKMA`.`Beneficiario`
    WHERE `idBeneficiario` = Id;
END$$

DELIMITER ;



-- ***************************************************************
-- *24.1 Rutina para la visualización de los beneficiarios activos
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readActiveBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readActiveBeneficiaries` (IN IdBranch INT)
-- 24.1 Rutina para la visualización de los beneficiarios activos
BEGIN
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status,
           b.status IdStatus,
           IF( b.beca, "CON BECA", "SIN BECA") Beca,
           b.beca IdBeca,
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro,
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento,
           b.telefono Telefono,
           f.frecuencia Frecuencia,
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia,
           g.grupo Dia,
           b.grupoDia_idGrupoDia IdDia,
           s.nombre Sucursal,
           b.sucursal_idSucursal IdSucursal
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
    WHERE b.status = 1
      AND (
                b.Sucursal_idSucursal = IdBranch
            OR b.Sucursal_idSucursal IS NULL
        );
END$$

DELIMITER ;



-- 15.1 Rutina para la visualización de los datos relevantes de un usuario por sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUsersBranch`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUsersBranch` (IN IdBranch INT)
BEGIN
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