USE `REDO_MAKMA`;
DROP procedure IF EXISTS `crearUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `crearUsuario` (IN Nombre varchar(80), IN Correo varchar(140),
								 IN Password varchar(40), IN tel varchar(12),IN Rol_num int, 
								 IN Sucursal_num int)
BEGIN
	INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`) 
    VALUES (Nombre, Correo, sha2(Password,224), tel, Rol_num, Sucursal_num);
END$$

DELIMITER ;