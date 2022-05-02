-- Visualización del catalogo de sucursales del BAMX

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBranches`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBranches` ()
BEGIN
	SELECT idSucursal Id, nombre Sucursal FROM Sucursal;
END$$

DELIMITER ;