-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: JUSTIFICACIONES (J)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *40.1 Rutina para la creacion de justificacion de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createJustification`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createJustification` (IN JustifiedDate DATE, IN IdBeneficiary INT, IN Reason INT)
-- 40.1 Rutina para la creacion de justificacion de un beneficiario
BEGIN
    INSERT INTO `REDO_MAKMA`.`Justificacion`
    (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`)
    VALUES (CURDATE(), JustifiedDate, IdBeneficiary, Reason);
END$$

DELIMITER ;




-- *48.1 Rutina para la visualización de todas las justificaciones mensuales hechas por los beneficiario (historico)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readJustificationRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readJustificationRecord` (IN IdBranch INT)
-- 48.1 Rutina para la visualización de todas las justificaciones mensuales hechas por los beneficiario (historico)
BEGIN
    -- Declaracion de variables a utilizar durante el procedimiento
    DECLARE i INT DEFAULT 0; -- Contador de justificaciones por beneficiario
    -- Variables que se necesitan en la tabla del sistema
    DECLARE IdJ INT;
    DECLARE IdB INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Nombre VARCHAR(60);
    DECLARE Telefono VARCHAR(12);
    DECLARE Fecha DATETIME;
    DECLARE Razon VARCHAR(30);
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor

    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion todas las justificaciones
    -- que se han hecho en un mes y la informacion de los beneficiarios que las realizaron.
    DECLARE Justification_cursor CURSOR FOR
        SELECT 	j.idJustificacion IdJ,
                  b.idBeneficiario IdB,
                  b.folio Folio,
                  b.nombre Nombre,
                  b.telefono Telefono,
                  j.fechaJustificada Fecha,
                  m.motivo Razon
        FROM Justificacion j
                 LEFT JOIN Beneficiario b
                           ON j.beneficiario_idBeneficiario = b.idBeneficiario
                 LEFT JOIN Motivo m
                           ON j.motivo_idMotivo = m.idMotivo
        WHERE 	b.status = 1
          AND j.fechaJustificada <= LAST_DAY(NOW())
          AND j.fechaJustificada >= CAST(DATE_FORMAT(NOW(),'%Y-%m-01') AS DATE)
          AND (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        ORDER BY b.folio,j.fechaJustificada DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere la tabla del sistema.
    DROP TEMPORARY TABLE IF EXISTS `Justifica tionRecord`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `JustificationRecord`(
                                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                                  `IdJustificacion` INT,
                                                                  `IdBeneficiario` INT,
                                                                  `Folio` VARCHAR(13),
                                                                  `Nombre` VARCHAR(60),
                                                                  `Telefono` VARCHAR(12),
                                                                  `Fecha` DATETIME,
                                                                  `CanJustif` INT,
                                                                  `Razon` VARCHAR(30),
                                                                  PRIMARY KEY (`id`)
    );
    -- Abertura del cursor para empezar a recorrer lo que contiene de la query
    OPEN Justification_cursor;
    FETCH Justification_cursor INTO IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon;
    WHILE Flag = TRUE DO
            IF i = 0 THEN -- Cada vez que el contador de justificaciones es 0,
            -- significa que necesita contar las justificaciones de un nuevo beneficiario determinado en IdB
                SELECT 	COUNT(*) INTO i
                FROM Justificacion j
                         LEFT JOIN Beneficiario b
                                   ON j.beneficiario_idBeneficiario = b.idBeneficiario
                WHERE b.status = 1
                  AND j.fechaJustificada <= LAST_DAY(NOW())
                  AND j.fechaJustificada >= CAST(DATE_FORMAT(NOW(),'%Y-%m-01') AS DATE)
                  AND b.idBeneficiario = IdB;
            END IF;
            -- Sin importar si se acaba de rellenar el contador o no se hace la insercion en la tabla temporal del la info que tiene el cursor
            -- ademas del contador que va decrementando con cada insercion que se hace.
            INSERT INTO `REDO_MAKMA`.`JustificationRecord`
            (`IdJustificacion`, `IdBeneficiario`, `Folio`, `Nombre`, `Telefono`, `Fecha`, `Razon`, `CanJustif`)
            VALUES (IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon, i);
            SELECT i - 1 INTO i;
            FETCH Justification_cursor INTO IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon;
        END WHILE;
    CLOSE Justification_cursor;
    -- Select de todo lo de la tabla excepto el id de la misma para mandar la info a la tabla del sistema.
    SELECT j.IdJustificacion, j.IdBeneficiario, j.Folio, j.Nombre, j.Telefono,
           DATE_FORMAT(j.Fecha, '%d-%m-%Y') Fecha, j.CanJustif, j.Razon FROM JustificationRecord j;
    DROP TABLE IF EXISTS `JustificationRecord`;
END$$

DELIMITER ;