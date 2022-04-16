USE `REDO_MAKMA`;
DROP procedure IF EXISTS `visualizarSucursales`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `visualizarSucursales` ()
BEGIN
	SELECT idSucursal Id, nombre Sucursal FROM Sucursal;
END$$

DELIMITER ;