-- Actualización de todos los campos de un usuario por su id

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateUser` (IN Name VARCHAR(80), IN Email VARCHAR(140), IN Password VARCHAR(56),
								IN PhoneNumber VARCHAR(12),IN NumRole INT, IN NumBranch INT, IN Id INT)
BEGIN
	UPDATE `REDO_MAKMA`.`Usuario`
	SET `nombre` = UPPER(Name), `correo` = UPPER(Email), `password` = Password,  `telefono` = PhoneNumber,
		`rol_idRol` = NumRole, `sucursal_idSucursal` = NumBranch
	WHERE `idUsuario`=Id;
END$$

DELIMITER ;