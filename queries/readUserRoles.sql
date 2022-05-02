-- Visualización del catalogo de roles de usuario del sistema.

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readUserRoles`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readUserRoles` ()
BEGIN
	SELECT idRol Id, tipo Rol FROM Rol;
END$$

DELIMITER ;