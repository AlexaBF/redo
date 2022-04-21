USE `REDO_MAKMA`;
DROP procedure IF EXISTS `visualizarUsuarios`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `visualizarUsuarios` ()
BEGIN
	SELECT u.idUsuario Id, u.nombre Nombre, u.correo Correo, 
		   u.telefono Numero, r.tipo Rol, s.nombre Sucursal 
	FROM Usuario u LEFT JOIN Rol r 
    ON u.rol_idRol = r.idRol 
    LEFT JOIN Sucursal s
    ON u.sucursal_idSucursal = s.idSucursal;
END$$

DELIMITER ;