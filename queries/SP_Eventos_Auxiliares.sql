-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES y EVENTOS DEL SISTEMA AUXILIARES
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *45.1 Rutina para la obtencion de fechas de inicio y fin dependiendo de la frecuencia del beneficiario.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readFrequencyDates`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readFrequencyDates`(IN IdFrequency INT, OUT StartDate DATE, OUT EndDate DATE)
-- 45.1 Rutina para la obtencion de fechas de inicio y fin dependiendo de la frecuencia del beneficiario.
BEGIN
    -- Se obtiene la fecha de inicio y final del intervalo de tiempo en que se revisan las asistencias,
    -- el intervalo de tiempo es dependiente de la frecuencia de visita del beneficiario.
    IF IdFrequency = 1 THEN
        SELECT	ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    ELSEIF IdFrequency = 2 THEN
        SELECT	SUBDATE(ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    ELSE
        SELECT	SUBDATE(ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY), INTERVAL 21 DAY),
                  ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO StartDate, EndDate;
    END IF;
END$$

DELIMITER ;



-- *39.1 Rutina para la creacion de asistencia de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createAttendance` (IN idBeneficiary INT)
-- 39.1 Rutina para la creacion de asistencia de un beneficiario
BEGIN
    INSERT INTO `REDO_MAKMA`.`AsistenciaPunto`
    (`fecha`, `beneficiario_idBeneficiario`)
    VALUES
        (CURDATE(), idBeneficiary);
END$$

DELIMITER ;



-- *43.1 Rutina para la eliminacion de asistencia de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `deleteAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `deleteAttendance` (IN Id INT)
-- 43.1 Rutina para la eliminacion de asistencia de un beneficiario
BEGIN
    DECLARE WeekStart DATE;
    DECLARE WeekEnd DATE;
    SELECT ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY),
           ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO WeekStart, WeekEnd;
    DELETE FROM `REDO_MAKMA`.`AsistenciaPunto`
    WHERE beneficiario_idBeneficiario = Id
      AND fecha BETWEEN WeekStart AND WeekEnd;
END$$

DELIMITER ;




-- 50.1 Rutina para la creacion de faltas de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createAbsence`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createAbsence`()
BEGIN
    DECLARE IdBeneficiary INT;
    DECLARE IdFrequency INT;

    DECLARE StartDate DATE;
    DECLARE EndDate DATE;

    DECLARE IsAbsence TINYINT(1);

    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor
    DECLARE Absence_cursor CURSOR FOR
        SELECT b.idBeneficiario,
               b.frecuenciaVisita_idFrecuenciaVisita
        FROM Beneficiario b
                 LEFT JOIN AsistenciaPunto ap
                           ON ap.beneficiario_idBeneficiario = b.idBeneficiario
        WHERE 	b.status = 1
          AND grupoDia_idGrupoDia = WEEKDAY(CURDATE())+1
        GROUP BY b.idBeneficiario
        ORDER BY b.folio ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;

    OPEN Absence_cursor;
    FETCH Absence_cursor INTO IdBeneficiary, IdFrequency;
    WHILE Flag = TRUE DO
            CALL readFrequencyDates (IdFrequency, StartDate, EndDate);

            SELECT 	IF(ap.fecha >= StartDate
                             AND ap.fecha <= EndDate,
                         0, IF(j.fechaJustificada >= StartDate
                                   AND j.fechaJustificada <= EndDate,0,1))
            INTO IsAbsence
            FROM Beneficiario b
                     LEFT JOIN AsistenciaPunto ap
                               ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                                   AND ap.fecha >= StartDate
                     LEFT JOIN Justificacion j
                               ON b.idBeneficiario = j.beneficiario_idBeneficiario
                                   AND j.fechaJustificada >= StartDate
            WHERE 	b.idBeneficiario = IdBeneficiary;
            IF IsAbsence=1 THEN
                INSERT INTO `REDO_MAKMA`.`Falta`
                (`fecha`,`status`,`beneficiario_idBeneficiario`)
                VALUES
                    (CURDATE(),1,IdBeneficiary);
            END IF;
            FETCH Absence_cursor INTO IdBeneficiary, IdFrequency;
        END WHILE;
    CLOSE Absence_cursor;
END$$
DELIMITER ;



-- 52.1 Rutina para la creacion de un nuevo beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createBeneficiary` (IN Folio VARCHAR(13), IN Name VARCHAR(60), IN Address VARCHAR(40), IN IdDay INT, IN StartDate DATE,
                                      IN EndDate DATE, IN Status TINYINT(1), IN aGrant TINYINT(1), IN IdFrequency INT,
                                      IN PhoneNumber VARCHAR(12), IN IdBranch INT)
BEGIN
    INSERT INTO `REDO_MAKMA`.`Beneficiario`
    (`folio`,`nombre`,`status`,`beca`,`fRegistro`,`fVencimiento`,`colonia`,
     `telefono`,`frecuenciaVisita_idFrecuenciaVisita`,`grupoDia_idGrupoDia`,`sucursal_idSucursal`)
    VALUES
        (Folio, Name, Status, aGrant, CAST(DATE_FORMAT(StartDate,'%d-%m-%y')AS DATE), CAST(DATE_FORMAT(StartDate,'%d-%m-%y')AS DATE),
         Address, PhoneNumber, IdFrequency, IdDay, IdBranch);
END$$

DELIMITER ;




-- 53.1 Rutina para la actualizacion de un beneficiario existente
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiary`(IN Folio VARCHAR(13), IN Name VARCHAR(60), IN Address VARCHAR(40), IN IdDay INT, IN StartDate DATE,
                                     IN EndDate DATE, IN Status TINYINT(1), IN aGrant TINYINT(1), IN IdFrequency INT,
                                     IN PhoneNumber VARCHAR(12), IN IdBranch INT, IN Id INT)
BEGIN
    UPDATE `REDO_MAKMA`.`Beneficiario`
    SET
        `nombre` = Name,
        `status` = Status,
        `beca` = aGrant,
        `fRegistro` = CAST(DATE_FORMAT(StartDate,'%d-%m-%y')AS DATE),
        `fVencimiento` = CAST(DATE_FORMAT(EndDate,'%d-%m-%y')AS DATE),
        `colonia` = Address,
        `telefono` = CAST(PhoneNumber AS character),
        `frecuenciaVisita_idFrecuenciaVisita` = IdFrequency,
        `grupoDia_idGrupoDia` = IdDay,
        `sucursal_idSucursal` = IdBranch
    WHERE `folio` = Folio AND `idBeneficiario` = Id;
END$$

DELIMITER ;




-- 54.1 Rutina para la inactivacion del status de todos los beneficiarios.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `inactivateBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `inactivateBeneficiaries`()
BEGIN
    UPDATE `REDO_MAKMA`.`Beneficiario`
    SET
        `status` = 0
    WHERE `idBeneficiario` >= 1;
END$$

DELIMITER ;