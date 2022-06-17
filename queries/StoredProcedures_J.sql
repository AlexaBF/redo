-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: JUSTIFICACIONES (J)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualización de todas las justificaciones mensuales hechas por los beneficiario (historico)
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readJustificationRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readJustificationRecord` (IN IdBranch INT)
BEGIN
    -- Visualización de todas las justificaciones mensuales hechas por los beneficiario (historico)
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
    DECLARE Status VARCHAR (10);
    DECLARE Flag BOOLEAN DEFAULT TRUE; -- Indicador de termino del cursor
    -- Declaracion del cursor con su respectiva query que es para para obtener la informacion todas las justificaciones
    -- que se han hecho en un mes y la informacion de los beneficiarios que las realizaron.
    DECLARE Justification_cursor CURSOR FOR
        SELECT 	j.idJustificacion,
                  b.idBeneficiario,
                  b.folio,
                  b.nombre,
                  b.telefono,
                  j.fechaJustificada,
                  m.motivo Razon,
                  IF( b.status, "ACTIVO", "INACTIVO")
        FROM Justificacion j
                 LEFT JOIN Beneficiario b
                           ON j.beneficiario_idBeneficiario = b.idBeneficiario
                 LEFT JOIN Motivo m
                           ON j.motivo_idMotivo = m.idMotivo
        WHERE 	j.fechaJustificada >= CAST(DATE_FORMAT(NOW(),'%Y-%m-01') AS DATE)
          AND (b.sucursal_idSucursal = IdBranch OR b.sucursal_idSucursal IS NULL)
        ORDER BY b.folio DESC, j.fechaJustificada DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Flag = FALSE;
    -- Declaracion de tabla temporal que se llenara al recorrer el cursor, al guardarlo en una tabla facilita la
    -- forma de mostrar los datos como los requiere la tabla del sistema.
    DROP TEMPORARY TABLE IF EXISTS `Justifications`;
    CREATE TEMPORARY TABLE IF NOT EXISTS `Justifications`(
                                                             `id` INT NOT NULL AUTO_INCREMENT,
                                                             `IdJustificacion` INT,
                                                             `IdBeneficiario` INT,
                                                             `Folio` VARCHAR(13),
                                                             `Nombre` VARCHAR(60),
                                                             `Telefono` VARCHAR(12),
                                                             `Fecha` DATETIME,
                                                             `CanJustif` INT,
                                                             `Razon` VARCHAR(30),
                                                             `Status` VARCHAR(30),
                                                             PRIMARY KEY (`id`)
    );
    -- Abertura del cursor para empezar a recorrer lo que contiene de la query
    OPEN Justification_cursor;
    FETCH Justification_cursor INTO IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon, Status;
    WHILE Flag = TRUE DO
            IF i = 0 THEN -- Cada vez que el contador de justificaciones es 0,
            -- significa que necesita contar las justificaciones de un nuevo beneficiario determinado en IdB
                SELECT COUNT(*) INTO i
                FROM Justificacion j
                         LEFT JOIN Beneficiario b
                                   ON j.beneficiario_idBeneficiario = b.idBeneficiario
                WHERE b.idBeneficiario = IdB
                  AND j.fechaJustificada >= CAST(DATE_FORMAT(NOW(),'%Y-%m-01') AS DATE);
            END IF;
            -- Sin importar si se acaba de rellenar el contador o no se hace la insercion en la tabla temporal del la info que tiene el cursor
            -- ademas del contador que va decrementando con cada insercion que se hace.
            INSERT INTO `REDO_MAKMA`.`Justifications`
            (`IdJustificacion`, `IdBeneficiario`, `Folio`, `Nombre`, `Telefono`, `Fecha`, `Razon`, `CanJustif`,`Status`)
            VALUES (IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon, i, Status);
            SELECT i - 1 INTO i;
            FETCH Justification_cursor INTO IdJ, IdB, Folio, Nombre, Telefono, Fecha, Razon, Status;
        END WHILE;
    CLOSE Justification_cursor;
    -- Select de todo lo de la tabla excepto el id de la misma para mandar la info a la tabla del sistema.
    SELECT jr.IdJustificacion, jr.IdBeneficiario, jr.Folio, jr.Nombre, jr.Telefono,
           DATE_FORMAT(jr.Fecha, '%d-%m-%Y') Fecha, jr.CanJustif, jr.Razon, jr.Status FROM Justifications jr
    ORDER BY jr.Folio, jr.CanJustif DESC;
    DROP TEMPORARY TABLE  IF EXISTS `JustificationRecord`;
END$$

DELIMITER ;



-- Rutina para la creacion de justificacion de un beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `createJustification`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `createJustification` (IN JustifiedDate DATE, IN Folio VARCHAR(13), IN Reason INT, IN TextReason VARCHAR(30))
BEGIN
    -- Creacion de justificacion de un beneficiario
    -- Declaracion de variables para auxiliar las validaciones de creacion o eliminacion de asistencias.
    DECLARE IdBeneficiary INT;
    DECLARE idJustification INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE idFrequency INT;
    DECLARE cAbsence INT;
    DECLARE isJustification INT;
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    -- Se obtiene el id del beneficiario y su frecuencia de visita a traves de su folio, se usa el id y la frecuencia para
    -- el registro y eliminacion de asistencias y procedimientos necesarios por consecuencia.
    SELECT b.idBeneficiario, b.frecuenciaVisita_idFrecuenciaVisita INTO IdBeneficiary, idFrequency
    FROM Beneficiario b WHERE b.folio = Folio;
    -- Se revisa si tiene una justificacion previa por parte del beneficiario para ese mismo dia.
    SELECT COUNT(*) INTO isJustification
    FROM Justificacion
    WHERE `fechaJustificada` = JustifiedDate AND `beneficiario_idBeneficiario` = IdBeneficiary;
    IF (isJustification = 0) THEN -- Procedimiento a seguir si el beneficiartio no tiene una justificion para el mismo dia
    -- Obtencion del marco de tiempo en fechas de la frecuencia de tiempo especifica del beneficiario.
        CALL readFrequencyDateByDate(IdFrequency, StartDate, EndDate, JustifiedDate);
        -- Se revisa si tiene una falta previa por parte del beneficiario en su marco de tiempo.
        SELECT COUNT(*) INTO cAbsence
        FROM Falta f
        WHERE f.beneficiario_idBeneficiario = IdBeneficiary
          AND f.fecha BETWEEN StartDate AND EndDate;
        -- Se crea la justificacion
        INSERT INTO `REDO_MAKMA`.`Justificacion`
        (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`)
        VALUES (CURDATE(), JustifiedDate, IdBeneficiary, Reason);
        -- Proceso extra si el motivo registrado es "OTROS"
        IF (Reason = 7) THEN
            SELECT idJustificacion INTO idJustification -- Se obtiene el id de la justificacion recien creada
            FROM Justificacion
            WHERE `fechaJustificada` = JustifiedDate AND `beneficiario_idBeneficiario` = IdBeneficiary;
            -- Se crea el extra registro del texto paras describir otros.
            INSERT INTO `REDO_MAKMA`.`JustificacionOtro` (`motivo`, `justificacion_idJustificacion`)
            VALUES (UPPER(TextReason), idJustification);
        END IF;
        -- Se elimina la falta si existe previamente.
        IF (cAbsence >= 1) THEN
            CALL `REDO_MAKMA`.`deleteAbsence`(IdBeneficiary, StartDate, EndDate);
        END IF;
        UPDATE `REDO_MAKMA`.`Falta` SET `status`='0'
        WHERE `beneficiario_idBeneficiario` = IdBeneficiary AND `fecha` <= JustifiedDate;
        SELECT TRUE done, "Se registra correctamente la justificación" message;
    ELSE -- Procedimiento a seguir si el beneficiartio tiene una justificion para el mismo dia
        SELECT FALSE done, "El beneficiario ya tiene una justificación registrada en esa fecha" message;
    END IF;
END$$

DELIMITER ;