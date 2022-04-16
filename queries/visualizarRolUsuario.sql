USE `REDO_MAKMA`;
DROP procedure IF EXISTS `visualizarRolUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `visualizarRolUsuario` ()
BEGIN
	SELECT idRol Id, tipo Rol FROM Rol;
END$$

DELIMITER ;