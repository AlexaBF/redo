-- Borrar a un usuario del sistema por su id

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteUser` (IN Id INT)
BEGIN
	DELETE FROM `REDO_MAKMA`.`Usuario` WHERE `idUsuario`=Id;
END$$

DELIMITER ;