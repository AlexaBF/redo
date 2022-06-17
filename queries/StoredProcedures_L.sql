-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: LOGIN (L)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para hacer el login
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `loginUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `loginUser`(IN email VARCHAR(100), IN pass VARCHAR(56))
BEGIN
    DECLARE Cant INT;
    DECLARE IdUser INT;
    DECLARE IdRole INT;
    DECLARE IdBranch INT;
    DECLARE Name VARCHAR(60);
    DECLARE Role VARCHAR(30);
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Conteo de beneficiarios que coinciden con ese usuario y contraseña
    SELECT COUNT(*) INTO Cant
    FROM Usuario
    WHERE correo = UPPER(email) AND password = SHA2(pass, 224);
    -- Se seleciona las caracteristicas del usuario necesarias por el sistema
    SELECT 	u.idUsuario, u.rol_idRol, u.sucursal_idSucursal, u.nombre,r.tipo
    INTO 	IdUser, IdRole, IdBranch, Name, Role
    FROM Usuario u
             LEFT JOIN Rol r
                       ON u.rol_idRol = r.idRol
    WHERE u.correo = UPPER(email) AND u.password = SHA2(pass, 224);
    -- Envio de la informacion recopilada
    SELECT Cant, Id, IdRole, IdBranch, Name, Role;
END$$

DELIMITER ;