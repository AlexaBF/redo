-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: ASISTENCIA EN PUNTO (AEP)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *38.1 Rutina para la visualizacion de beneficiarios que asistieron o justificaron en esa semana
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readAttendance` (IN IdBranch INT)
BEGIN
    -- 38.1 Rutina para la visualizacion de beneficiarios que asistieron o justificaron en esa semana
    DECLARE WeekStart DATE;
    DECLARE WeekEnd DATE;
    SELECT ADDDATE(CURDATE(), INTERVAL 0-WEEKDAY(CURDATE()) DAY),
           ADDDATE(CURDATE(), INTERVAL 6-WEEKDAY(CURDATE()) DAY) INTO WeekStart, WeekEnd;
    SELECT 	b.idBeneficiario Id,
              b.folio Folio,
              b.nombre Nombre,
              f.frecuencia Frecuencia,
              g.grupo Dia,
              IF(ap.fecha >= WeekStart
                     AND ap.fecha <= WeekEnd,1, 0) IdAsistencia,
              IF(ap.fecha >= WeekStart
                     AND ap.fecha <= WeekEnd,"Si", "No") Asistencia,
              IF (j.fechaJustificada >= WeekStart
                      AND j.fechaJustificada <= WeekEnd, 1, 0) IdJustificacion,
              IF (j.fechaJustificada >= WeekStart
                      AND j.fechaJustificada <= WeekEnd, "Si", "No") Justificacion
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN AsistenciaPunto ap
                       ON b.idBeneficiario = ap.beneficiario_idBeneficiario
                           AND ap.fecha >= WeekStart
             LEFT JOIN Justificacion j
                       ON b.idBeneficiario = j.beneficiario_idBeneficiario
                           AND j.fechaJustificada >= WeekStart
    WHERE 	(b.sucursal_idSucursal = IdBranch
        OR b.sucursal_idSucursal IS NULL)
      AND b.status = 1
      -- GROUP BY b.idBeneficiario, b.folio
    ORDER BY g.idGrupoDia, b.folio ASC;
END$$

DELIMITER ;



-- *44.1 Rutina para la Creacion y Eliminacion de asistencias en el sistema (Logica completa).
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `attendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `attendance` (IN Folio VARCHAR(13), IN Attendance TINYINT(1))
-- 44.1 Rutina para la Creacion y Eliminacion de asistencias en el sistema (Logica completa).
BEGIN
    -- Declaracion de variables.
    DECLARE Id INT;
    DECLARE IdFrequency INT;
    DECLARE StartDate DATE;
    DECLARE EndDate DATE;
    DECLARE cAttendance INT;
    DECLARE Status TINYINT(1);
    -- Se obtiene el id del beneficiario y su frecuencia de visita a traves de su folio, se usa el id y la frecuencia para
    -- el registro y eliminacion de asistencias y la logica de las mismas.
    SELECT b.idBeneficiario, b.frecuenciaVisita_idFrecuenciaVisita, b.status
    INTO Id, IdFrequency, Status
    FROM Beneficiario b
    WHERE b.folio = Folio;
    CALL readFrequencyDates (IdFrequency, StartDate, EndDate);
    -- Se revisa si hay o no asistencia por parte del beneficiario.
    SELECT COUNT(*)
    INTO cAttendance
    FROM AsistenciaPunto ap
    WHERE ap.beneficiario_idBeneficiario = Id
      AND ap.fecha BETWEEN StartDate AND EndDate;
    -- Se hace la logica de Crear o Eliminar una asistencia.
    IF Status = 0 THEN
        SELECT "El beneficiario esta inactivo" message,
               FALSE done;
    ELSEIF Attendance = 1 THEN
        IF cAttendance = 0 THEN
            CALL `REDO_MAKMA`.`createAttendance`(Id);
            SELECT "Se registro correctamente la asistencia" message,
                   TRUE done;
        ELSE
            SELECT "El beneficiario ya tiene una asistencia reciente" message,
                   FALSE done;
        END IF;
    ELSE
        IF cAttendance = 1 THEN
            CALL `REDO_MAKMA`.`deleteAttendance`(Id);
            SELECT "Se elimino correctamente la asistencia" message,
                   TRUE done;
        ELSE
            SELECT "El beneficiario no tiene una asistencia reciente que eliminar" message,
                   FALSE done;
        END IF;
    END IF;
END$$

DELIMITER ;