USE `REDO_MAKMA`;
DROP procedure IF EXISTS `modificarUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `modificarUsuario` (IN Nombre VARCHAR(80), IN Correo VARCHAR(140), IN Password VARCHAR(56),
									 IN Tel VARCHAR(12),IN Rol_num INT, IN Sucursal_num INT, IN Id INT)
BEGIN
	UPDATE `REDO_MAKMA`.`Usuario` 
	SET `nombre` = Nombre, `correo` = Correo, `telefono` = Tel, `rol_idRol` = Rol_num, `sucursal_idSucursal` = Sucursal_num
	WHERE `idUsuario` = Id;
END$$

DELIMITER ;