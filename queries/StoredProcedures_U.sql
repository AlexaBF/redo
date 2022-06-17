-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: USUARIOS (U)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualizacion de todos los usuarios de todas las sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUsers`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUsers` ()
BEGIN
    -- Visualizacion de todos los usuarios de todas las sucursales
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
                       ON u.sucursal_idSucursal = s.idSucursal;
END$$

DELIMITER ;



-- Rutina para la actualizacion de los datos de un usuario (sin contraseña)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateUser` (IN Name VARCHAR(60), IN Email VARCHAR(100), IN PhoneNumber VARCHAR(12),
                               IN IdRole INT, IN IdBranch INT, IN IdUser INT)
BEGIN
    -- Actualizacion de los datos de un usuario (sin contraseña)
    UPDATE `REDO_MAKMA`.`Usuario`
    SET `nombre` = UPPER(Name),
        `correo` = UPPER(Email),
        `telefono` = PhoneNumber,
        `rol_idRol` = IdRole,
        `sucursal_idSucursal` = IdBranch
    WHERE `idUsuario` = IdUser;
END$$

DELIMITER ;



-- Rutina para la visualizacion del catalogo de roles de usuario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUserRoles`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUserRoles` ()
BEGIN
    -- Visualizacion del catalogo de roles de usuario
    SELECT 	idRol Id,
              tipo Rol
    FROM Rol;
END$$

DELIMITER ;



-- Rutina para la visualizacion del catalogo de sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBranches`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBranches` ()
BEGIN
    -- Visualizacion del catalogo de sucursales
    SELECT 	idSucursal Id,
              nombre Sucursal
    FROM Sucursal;
END$$

DELIMITER ;



-- Rutina para la actualizacion de la contraseña de un usuario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateUserPassword`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateUserPassword` (IN Password VARCHAR(60), IN IdUser INT)
BEGIN
    -- Actualizacion de la contraseña de un usuario
    UPDATE `REDO_MAKMA`.`Usuario`
    SET `password` = SHA2(Password,224)
    WHERE `idUsuario` = IdUser;
END$$

DELIMITER ;



-- Rutina para la eliminacion de un usuario segun el id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteUser` (IN IdUser INT)
BEGIN
    -- Eliminacion de un usuario segun el id
    DELETE FROM `REDO_MAKMA`.`Usuario`
    WHERE `idUsuario` = IdUser;
END$$

DELIMITER ;



-- Rutina para la creacion de nuevos usuarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createUser` (IN Name VARCHAR(60), IN Email VARCHAR(100), IN Password VARCHAR(60),
                               IN PhoneNumber VARCHAR(12),IN NumRole INT, IN NumBranch INT)
BEGIN
    -- Creacion de nuevos usuarios
    INSERT INTO `REDO_MAKMA`.`Usuario`
    (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
    VALUES
        (UPPER(Name), UPPER(Email), sha2(Password,224), PhoneNumber, NumRole, NumBranch);
END$$

DELIMITER ;