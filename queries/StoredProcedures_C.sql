-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: CAJERO (C)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 49.1 Rutina para la visualizacion de asistencia de beneficiarios en Cajero
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readRollCall`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readRollCall` (IN IdBranch INT)
BEGIN
    -- Declaracion de variables ha utilizar para obtener la informacion del cursor y auxiliares para
    -- obtener la asistencia de cada beneficiario dependiendo de la frecuencia con la que visita el BAMX.
    DECLARE IdBeneficiario INT;
    DECLARE Folio VARCHAR(13);
    DECLARE Nombre VARCHAR(60);
    DECLARE IdAsistencia INT;
    DECLARE Asistencia VARCHAR(2);
    DECLARE IdJustificacion INT;
    DECLARE Justificacion VARCHAR(2);

    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor

    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion los beneficiarios
    DECLARE RollCall_cursor CURSOR FOR
        SELECT 	b.idBeneficiario,
                  b.folio,
                  b.nombre,
                  b.frecuenciaVisita_idFrecuenciaVisita
        FROM Beneficiario b
                 LEFT JOIN AsistenciaPunto ap
                           ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                 LEFT JOIN Justificacion j
                           ON b.idBeneficiario = j.beneficiario_idBeneficiario
        WHERE 	(b.sucursal_idSucursal = IdBranch
            OR b.sucursal_idSucursal IS NULL)
          AND b.status = 1
        GROUP BY b.idBeneficiario, b.folio
        ORDER BY b.folio, ap.fecha ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere la tabla del sistema.
    DROP TEMPORARY TABLE IF EXISTS `RollCall`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `RollCall`(
                                                       `id` INT NOT NULL AUTO_INCREMENT,
                                                       `IdBeneficiario` INT,
                                                       `Folio` VARCHAR(13),
                                                       `Nombre` VARCHAR(60),
                                                       `IdAsistencia` TINYINT(1),
                                                       `Asistencia` VARCHAR(2),
                                                       `IdJustificacion` TINYINT(1),
                                                       `Justificacion` VARCHAR(2),
                                                       PRIMARY KEY (`id`)
    );
    -- Apertura del cursor para empezar a recorrer lo que contiene de la query para saber datos generales del usuario sin meter la asistencia.
    OPEN RollCall_cursor;
    FETCH RollCall_cursor INTO IdBeneficiario, Folio, Nombre, IdFrequency;
    WHILE Flag = TRUE DO
            -- Obtencion del marco de tiempo en fechas de la frecuencia de tiempo de cada beneficiario
            CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
            -- Obtencion de si asistio o no dependiendo del tiempo en fechas obtenido previamente
            SELECT 	IF(ap.fecha >= StartDate
                             AND ap.fecha <= EndDate,1, 0),
                      IF(ap.fecha >= StartDate
                             AND ap.fecha <= EndDate,"Si", "No"),
                      IF (j.fechaJustificada >= StartDate
                              AND j.fechaJustificada <= EndDate, 1, 0),
                      IF (j.fechaJustificada >= StartDate
                              AND j.fechaJustificada <= EndDate, "Si", "No")
            INTO IdAsistencia, Asistencia, IdJustificacion, Justificacion
            FROM Beneficiario b
                     LEFT JOIN AsistenciaPunto ap
                               ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                                   AND ap.fecha >= StartDate
                     LEFT JOIN Justificacion j
                               ON b.idBeneficiario = j.beneficiario_idBeneficiario
                                   AND j.fechaJustificada >= StartDate
            WHERE 	(b.sucursal_idSucursal = IdBranch
                OR b.sucursal_idSucursal IS NULL)
              AND b.status = 1
              AND b.idBeneficiario = IdBeneficiario
            GROUP BY b.idBeneficiario, b.folio
            ORDER BY b.folio, ap.fecha ASC;
            -- Insercion en tabla temporal los datos generales y la informacion de asistencia unico de cada beneficiario.
            INSERT INTO `REDO_MAKMA`.`RollCall`
            (`IdBeneficiario`, `Folio`, `Nombre`, `IdAsistencia`, `Asistencia`, `IdJustificacion`, `Justificacion`)
            VALUES (IdBeneficiario, Folio, Nombre, IdAsistencia, Asistencia, IdJustificacion, Justificacion);
            FETCH RollCall_cursor INTO IdBeneficiario, Folio, Nombre, IdFrequency;
        END WHILE;
    CLOSE RollCall_cursor;
    -- Select de todo lo de la tabla excepto el id de la misma para mandar la info a la tabla del sistema.
    SELECT r.IdBeneficiario, r.Folio, r.Nombre, r.IdAsistencia, r.Asistencia, r.IdJustificacion, r.Justificacion FROM RollCall r;
    DROP TABLE IF EXISTS `RollCall`;
END$$

DELIMITER ;
