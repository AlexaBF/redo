USE `REDO_MAKMA`;
DROP procedure IF EXISTS `visualizarUsuario`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `visualizarUsuario` ()
BEGIN
	SELECT u.idUsuario Id, u.nombre Nombre, u.apellidos Apellidos, u.correo Correo, 
		   u.telefono Numero, r.tipo Rol, s.nombre Sucursal 
	FROM Usuario u LEFT JOIN Rol r 
    ON u.rol_idRol = r.idRol 
    LEFT JOIN Sucursal s
    ON u.sucursal_idSucursal = s.idSucursal;
END$$

DELIMITER ;