-- Insertar/crear un nuevo Usuario del sistema

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createUser` (IN Name VARCHAR(80), IN Email VARCHAR(140), IN Password VARCHAR(56),
								IN PhoneNumber VARCHAR(12),IN NumRole INT, IN NumBranch INT)
BEGIN
	INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
    VALUES (UPPER(Name), UPPER(Email), sha2(Password,224), PhoneNumber, NumRole, NumBranch);
END$$

DELIMITER ;