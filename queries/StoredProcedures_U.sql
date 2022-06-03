-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: USUARIOS (U)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *1.1 Rutina para la visualizacion de todos los usuarios de todas las sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUsers`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUsers` ()
-- 1.1 Rutina para la visualizacion de todos los usuarios de todas las sucursales
BEGIN
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



-- *2.1 Rutina para la creacion de nuevos usuarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createUser` (IN Name VARCHAR(60), IN Email VARCHAR(100), IN Password VARCHAR(60),
                               IN PhoneNumber VARCHAR(12),IN NumRole INT, IN NumBranch INT)
-- 2.1 Rutina para la creacion de nuevos usuarios
BEGIN
    INSERT INTO `REDO_MAKMA`.`Usuario`
    (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
    VALUES
        (UPPER(Name), UPPER(Email), sha2(Password,224), PhoneNumber, NumRole, NumBranch);
END$$

DELIMITER ;



-- *3.1 Rutina para la visualizacion del catalogo de sucursales
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBranches`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBranches` ()
-- 3.1 Rutina para la visualizacion del catalogo de sucursales
BEGIN
    SELECT 	idSucursal Id,
              nombre Sucursal
    FROM Sucursal;
END$$

DELIMITER ;



-- *4.1 Rutina para la visualizacion del catalogo de roles de usuario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUserRoles`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUserRoles` ()
-- 4.1 Rutina para la visualizacion del catalogo de roles de usuario
BEGIN
    SELECT 	idRol Id,
              tipo Rol
    FROM Rol;
END$$

DELIMITER ;



-- *5.1 Rutina para la visualizacion de un usuario segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUser` (IN Id INT)
-- 5.1 Rutina para la visualizacion de un usuario segun su id
BEGIN
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
    WHERE u.idUsuario = Id;
END$$

DELIMITER ;



-- *6.1 Rutina para la actualizacion de los datos de un usuario (sin contraseña)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateUser` (IN Name VARCHAR(60), IN Email VARCHAR(100), IN PhoneNumber VARCHAR(12),
                               IN IdRole INT, IN IdBranch INT, IN Id INT)
-- 6.1 Rutina para la actualizacion de los datos de un usuario (sin contraseña)
BEGIN
    UPDATE `REDO_MAKMA`.`Usuario`
    SET `nombre` = UPPER(Name),
        `correo` = UPPER(Email),
        `telefono` = PhoneNumber,
        `rol_idRol` = IdRole,
        `sucursal_idSucursal` = IdBranch
    WHERE `idUsuario` = Id;
END$$

DELIMITER ;



-- *7.1 Rutina para la eliminacion de un usuario segun el id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteUser` (IN Id INT)
-- 7.1 Rutina para la eliminacion de un usuario segun el id
BEGIN
    DELETE FROM `REDO_MAKMA`.`Usuario`
    WHERE `idUsuario` = Id;
END$$

DELIMITER ;





-- 42.1 Rutina para la actualizacion de la contraseña de un usuario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateUserPassword`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateUserPassword` (IN Password VARCHAR(60), IN IdUser INT)
-- 42.1 Rutina para la actualizacion de la contraseña de un usuario
BEGIN
    UPDATE `REDO_MAKMA`.`Usuario`
    SET `password` = SHA2(Password,224)
    WHERE `idUsuario` = IdUser;
END$$

DELIMITER ;