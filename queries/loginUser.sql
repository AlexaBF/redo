-- Revisar si hay un usuario y cuantos son acorde a su correo y password,
-- para regresar esa cantidad, ademas de su id, rol y sucursal (login).

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `loginUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `loginUser`(IN email VARCHAR(140), IN pass VARCHAR(56))
BEGIN
	DECLARE cant INT;
    DECLARE id INT;
    DECLARE role INT;
    DECLARE branch INT;
	SELECT COUNT(*) INTO cant FROM Usuario WHERE correo = email AND password = SHA2(pass, 224);
	SELECT idUsuario, rol_idRol, sucursal_idSucursal INTO id, role, branch FROM Usuario WHERE correo=email AND password=SHA2(pass, 224);
    SELECT cant, id, role, branch;
END$$

DELIMITER ;