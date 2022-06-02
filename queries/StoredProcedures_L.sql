-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: LOGIN (L)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 8.1 Rutina para hacer el login
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `loginUser`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `loginUser`(IN email VARCHAR(100), IN pass VARCHAR(56))
BEGIN
    DECLARE Cant INT;
    DECLARE Id INT;
    DECLARE IdRole INT;
    DECLARE IdBranch INT;
    DECLARE Name VARCHAR(60);
    DECLARE Role VARCHAR(30);
    SELECT COUNT(*) INTO Cant
    FROM Usuario
    WHERE correo = UPPER(email)
      AND password = SHA2(pass, 224);

    SELECT 	u.idUsuario,
              u.rol_idRol,
              u.sucursal_idSucursal,
              u.nombre,
              r.tipo
    INTO Id, IdRole, IdBranch, Name, Role
    FROM Usuario u
             LEFT JOIN Rol r
                       ON u.rol_idRol = r.idRol
    WHERE u.correo = UPPER(email)
      AND u.password = SHA2(pass, 224);

    SELECT Cant, Id, IdRole, IdBranch, Name, Role;
END$$

DELIMITER ;