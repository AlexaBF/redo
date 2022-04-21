USE `REDO_MAKMA`;
DROP procedure IF EXISTS `eliminarUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `eliminarUsuario` (IN Id INT)
BEGIN
	DELETE FROM `REDO_MAKMA`.`Usuario` WHERE `idUsuario`=Id;
END$$

DELIMITER ;