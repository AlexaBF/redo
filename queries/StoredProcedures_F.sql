-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: FALTAS (F)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualización de los faltas hechas por cada beneficiario (general)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readGeneralAbsences`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readGeneralAbsences` (IN IdBranch INT)
BEGIN
    -- Visualización de los faltas hechas por cada beneficiario (general y resumido)
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
    GROUP BY b.idBeneficiario
    ORDER BY CantFaltas DESC;
END$$

DELIMITER ;



-- Rutina para la visualización de todas las faltas activas hechas por los beneficiario (historico)
DROP procedure IF EXISTS `readAbsencesRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAbsencesRecord` (IN IdBranch INT)
BEGIN
    -- Visualización de todas las faltas activas hechas por los beneficiario (historico)
    -- Declaracion de variables ha utilizar para obtener la informacion del cursor durante el FETCH
    -- y auxiliares para el proceso y validaciones.
    DECLARE i INT DEFAULT 0;
    DECLARE IdF INT;
    DECLARE IdB INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Nombre VARCHAR(60);
    DECLARE Colonia VARCHAR(40);
    DECLARE Telefono VARCHAR(12);
    DECLARE Fecha DATETIME;
    DECLARE Razon VARCHAR(30);
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor.
    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion de beneficiarios validos (que tengan alguna falta).
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
          AND (b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
        ORDER BY b.folio DESC, f.fecha DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- manipulacion de los datos en API y FRONT.
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
    -- Apertura del cursor para empezar a recorrer lo que contiene el cursor. Se usa cursor por el conteo en secuencia de las faltas dependiendo del beneficiario
    OPEN Absences_cursor;
    FETCH Absences_cursor INTO IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon;
    WHILE Flag = TRUE DO
            IF i = 0 THEN
                SELECT COUNT(*) INTO i
                FROM Falta f
                         LEFT JOIN Beneficiario b
                                   ON f.beneficiario_idBeneficiario = b.idBeneficiario
                WHERE f.status = 1
                  AND b.idBeneficiario = IdB;
            END IF;
            -- Insercion en tabla temporal de la informacion de las faltas del beneficiario y su contador.
            INSERT INTO `REDO_MAKMA`.`AbsencesRecord` (`IdF`, `IdB`, `Folio`, `Nombre`, `Colonia`, `Telefono`, `Fecha`, `Razon`, `CanFaltas`) VALUES (IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon, i);
            SELECT i - 1 INTO i;
            FETCH Absences_cursor INTO IdF, IdB, Folio, Nombre, Colonia, Telefono, Fecha, Razon;
        END WHILE;
    CLOSE Absences_cursor;
    -- Visualizacion de todo el contenido insertado en la tabla exceptuando el id de la misma.
    SELECT a.IdF, a.IdB, a.Folio, a.Nombre, a.Colonia, a.Telefono, DATE_FORMAT(a.Fecha, '%d-%m-%Y') Fecha, a.Razon, a.CanFaltas FROM AbsencesRecord a
    ORDER BY jr.Folio, jr.CanJustif DESC;
    -- Eliminacion (por si acaso, ya que es una tabla temporal) de la tabla para que no ocupe espacio extra en el servidor donde se aloja la BD.
    DROP TABLE IF EXISTS `AbsencesRecord`;
END$$

DELIMITER ;




-- Rutina para la actualizar una falta para añadir un motivo por el que no se justifica.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateAbsence`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateAbsence` (IN Reason INT, IN IdAbsence INT, IN TextReason VARCHAR(30))
BEGIN
    -- Actualizacion una falta para añadir un motivo por el que no se justifica la falta.
    DECLARE cAbsence INT DEFAULT (0);
    DECLARE IdOtherAbsence INT;
    UPDATE `REDO_MAKMA`.`Falta`
    SET `motivo_idMotivo` = Reason
    WHERE `idFalta` = IdAbsence;
    -- Proceso extra si el motivo registrado es "OTROS"
    IF (Reason = 12) THEN
        -- se revisa si la falta se registro antes en categoria Otros
        SELECT COUNT(*), idFaltaOtro INTO cAbsence, IdOtherAbsence
        FROM FaltaOtro
        WHERE `idFaltaOtro` = IdAbsence;
        IF (cAbsence = 0) THEN -- si no la tenia previamente, se crea el registro en otros
            INSERT INTO `REDO_MAKMA`.`FaltaOtro` (`motivo`, `falta_idFalta`)
            VALUES (UPPER(TextReason), IdAbsence);
        ELSE -- si ya lo tenia, simplemente se actualiza.
            UPDATE `REDO_MAKMA`.`FaltaOtro`
            SET `motivo` = TextReason
            WHERE `idFaltaOtro` = IdAbsence;
        END IF;
    END IF;
END$$

DELIMITER ;




-- Rutina para la visualización del catalogo de motivos para justificar o no una falta
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readReasons`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readReasons` (IN IdTypeReason INT)
BEGIN
    -- Visualización del catalogo de motivos para justificar o no una falta (Falta justificada y falta no justificada)
    SELECT	idMotivo Id,
              motivo Motivo
    FROM Motivo
    WHERE motivoTipo_idMotivoTipo = IdTypeReason; -- 1->Justificacion y 2->Faltas
END$$

DELIMITER ;