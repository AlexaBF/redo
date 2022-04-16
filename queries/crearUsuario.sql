USE `REDO_MAKMA`;
DROP procedure IF EXISTS `crearUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `crearUsuario` (IN Nombre varchar(40), IN Apellido varchar(40), IN Correo varchar(320),
								 IN Password varchar(40), IN tel varchar(12),IN Rol_num int(10), 
								 IN Sucursal_num int(15))
BEGIN
	INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `apellidos`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`) 
    VALUES (Nombre, Apellido, Correo, sha(Password), tel, Rol_num, Sucursal_num);
END$$

DELIMITER ;