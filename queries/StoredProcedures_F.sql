-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: FALTAS (F)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *26.1 Rutina para la visualización de los faltas hechas por cada beneficiario (general)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readGeneralAbsences`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readGeneralAbsences` (IN IdBranch INT)
    -- 26.1 Rutina para la visualización de los faltas hechas por cada beneficiario (general)
-- REVISAR ENDPOINT Y EL STORED PROCEDURE --
BEGIN
    SELECT 	b.idBeneficiario Id,
              b.folio Folio,
              b.nombre Nombre,
              b.colonia Colonia,
              b.telefono Telefono,
              COUNT(*) CantFaltas
    FROM Falta f
             LEFT JOIN Beneficiario b
                       ON f.beneficiario_idBeneficiario = b.idBeneficiario
    WHERE f.status = 1
      AND (b.sucursal_idSucursal = IdBranch
        OR b.sucursal_idSucursal IS NULL)
    GROUP BY b.idBeneficiario;
END$$

DELIMITER ;



-- *27.1 Rutina para la visualización de todas las faltas activas hechas por los beneficiario (historico)
DROP procedure IF EXISTS `readAbsencesRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAbsencesRecord` ()
    -- 27.1 Rutina para la visualización de todas las faltas activas hechas por los beneficiario (historico)
-- REVISAR ENDPOINT Y EL STORED PROCEDURE --
BEGIN
    DECLARE i INT DEFAULT 0;

    DECLARE IdF INT;
    DECLARE IdB INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Nombre VARCHAR(60);
    DECLARE Colonia VARCHAR(40);
    DECLARE Telefono VARCHAR(12);
    DECLARE Fecha DATETIME;
    DECLARE Razon VARCHAR(30);

    DECLARE Flag BOOLEAN DEFAULT TRUE;

    DECLARE Absences_cursor CURSOR FOR
        SELECT 	f.idFalta IdF,
                  b.idBeneficiario IdB,
                  b.folio Folio,
                  b.nombre Nombre,
                  b.colonia Colonia,
                  b.telefono Telefono,
                  f.fecha Fecha,
                  m.motivo Razon
        FROM Falta f
                 LEFT JOIN Beneficiario b
                           ON f.beneficiario_idBeneficiario = b.idBeneficiario
                 LEFT JOIN Motivo m
                           ON f.motivo_idMotivo = m.idMotivo
        WHERE f.status = 1
          AND b.status = 1 -- prueba
          AND (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        ORDER BY b.folio,f.fecha DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;

    DROP TEMPORARY TABLE IF EXISTS `AbsencesRecord`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `AbsencesRecord`(
                                                             `id` INT NOT NULL AUTO_INCREMENT,
                                                             `IdF` INT,
                                                             `IdB` INT,
                                                             `Folio` VARCHAR(13),
                                                             `Nombre` VARCHAR(60),
                                                             `Colonia` VARCHAR(40),
                                                             `Telefono` VARCHAR(12),
                                                             `Fecha` DATETIME,
                                                             `Razon` VARCHAR(30),
                                                             `CanFaltas` INT,
                                                             PRIMARY KEY (`id`)
    );

    OPEN Absences_cursor;
    -- FETCH Absences_cursor INTO IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon;
    WHILE Flag = TRUE DO
            FETCH Absences_cursor INTO IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon;
            IF i = 0 THEN
                SELECT 	COUNT(*) INTO i
                FROM Falta f
                         LEFT JOIN Beneficiario b
                                   ON f.beneficiario_idBeneficiario = b.idBeneficiario
                WHERE f.status = 1
                  AND b.status = 1 -- prueba
                  AND b.idBeneficiario = IdB;
            END IF;
            INSERT INTO `REDO_MAKMA`.`AbsencesRecord` (`IdF`, `IdB`, `Folio`, `Nombre`, `Colonia`, `Telefono`, `Fecha`, `Razon`, `CanFaltas`) VALUES (IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon, i);
            SELECT i - 1 INTO i;
            -- FETCH Absences_cursor INTO IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon;
        END WHILE;
    CLOSE Absences_cursor;
    SELECT a.IdF, a.IdB, a.Folio, a.Nombre, a.Colonia, a.Telefono, DATE_FORMAT(a.Fecha, '%d-%m-%Y') Fecha, a.Razon, a.CanFaltas FROM AbsencesRecord a;
    DROP TABLE IF EXISTS `AbsencesRecord`;
END$$

DELIMITER ;



-- *41.1 Rutina para la actualizar una falta para añadir un motivo por el que no se justifica.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateAbsence`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateAbsence` (IN Reason INT, IN IdAbsence INT)
-- 41.1 Rutina para la actualizar una falta para añadir un motivo por el que no se justifica.
BEGIN
    UPDATE `REDO_MAKMA`.`Falta`
    SET `motivo_idMotivo` = Reason
    WHERE `idFalta` = IdAbsence;
END$$

DELIMITER ;



-- *30.1 Rutina para la visualización del catalogo de motivos para justificar o no una falta
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readReasons`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readReasons` (IN IdTypeReason INT)
-- 30.1 Rutina para la visualización del catalogo de motivos para justificar o no una falta
BEGIN
    SELECT	idMotivo Id,
              motivo Motivo
    FROM Motivo
    WHERE motivoTipo_idMotivoTipo = IdTypeReason; -- 1->Justificacion y 2->Faltas
END$$

DELIMITER ;
