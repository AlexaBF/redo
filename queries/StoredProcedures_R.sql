-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: REPORTES (R)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualizacion de la informacion de las tres tablas cargadas de asistencias, justificaciones y faltas.
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `attendanceRecord`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `attendanceRecord` (IN IdBranch INT)
BEGIN
	SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
	-- Visualizacion de la informacion de las tres tablas cargadas de asistencias, justificaciones y faltas.
	CALL readAttendanceReportRecord (IdBranch);
    CALL readAbsenceReportRecord (IdBranch);
    CALL readJustificationReportRecord (IdBranch);
	 -- Visualizacion de la informacion de las tres tablas cargadas de asistencias, justificaciones y faltas.
    SELECT DATE_FORMAT(jr.FechaInicial, '%d-%m-%Y') FechaInicial,
    IF (NumAsistencias IS NULL,0, NumAsistencias) NumAsistencias,
    IF (NumFaltas IS NULL, 0, NumFaltas) NumFaltas,
    IF (NumJustificaciones IS NULL, 0, NumJustificaciones) NumJustificaciones
    FROM JustificationReportRecord jr
    LEFT JOIN AbsenceReportRecord abr
    ON jr.FechaInicial = abr.FechaInicial
    LEFT JOIN AttendanceReportRecord ar
    ON ar.FechaInicial = jr.FechaInicial
    ORDER BY jr.FechaInicial DESC;
    DROP TABLE IF EXISTS `AttendanceReportRecord`;
    DROP TABLE IF EXISTS `AbsenceReportRecord`;
    DROP TABLE IF EXISTS `JustificationReportRecord`;
END$$

DELIMITER ;



-- Rutina para la visualizacion del reporte de asistencia
 USE `REDO_MAKMA`;
DROP procedure IF EXISTS `attendanceReport`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `attendanceReport` (IN aDate VARCHAR(12), IN idBranch INT)
BEGIN
	-- Obtencion de los datos para hacer el reporte de asistencia
	DECLARE Date DATE;
    SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    SELECT STR_TO_DATE(aDate, "%d-%m-%Y") INTO Date;
	SELECT 	b.Folio Folio,
		b.nombre Nombre,
        f.frecuencia Frecuencia,
        g.grupo Dia,
        IF(b.beca, "CON BECA", "SIN BECA") Beca,
        DATE_FORMAT(ap.fecha, '%d-%m-%Y') FechaAsistencia,
        WEEKDAY(ap.fecha)+1 DiaAsistencia,
        IF(WEEKDAY(ap.fecha)+1 IN (1), "LUNES",
        IF(WEEKDAY(ap.fecha)+1 IN (2), "MARTES",
        IF(WEEKDAY(ap.fecha)+1 IN (3), "MIÉRCOLES",
        IF(WEEKDAY(ap.fecha)+1 IN (4), "JUEVES",
        IF(WEEKDAY(ap.fecha)+1 IN (5), "VIENES",
        IF(WEEKDAY(ap.fecha)+1 IN (6), "SÁBADO", "DOMINGO")))))) DiaSemana,
        CURTIME() Hora,
        DATE_FORMAT(CURDATE(), '%d-%m-%Y') Fecha
	FROM Beneficiario b
		LEFT JOIN FrecuenciaVisita f
		ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
		LEFT JOIN GrupoDia g
		ON b.grupoDia_idGrupoDia = g.idGrupoDia
		LEFT JOIN Sucursal s
		ON b.sucursal_idSucursal = s.idSucursal
		LEFT JOIN AsistenciaPunto ap
		ON b.idBeneficiario = ap.beneficiario_idBeneficiario
	WHERE ap.fecha >= ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY)
		  AND ap.fecha <= ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY)
          AND (b.sucursal_idSucursal = IdBranch
			  OR b.sucursal_idSucursal IS NULL)
	ORDER BY DiaAsistencia ASC;
END$$

DELIMITER ;



-- Rutina para la visualizacion del reporte de Faltas
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `absenceReport`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `absenceReport` (IN aDate VARCHAR(12), IN idBranch INT)
BEGIN
	-- Obtencion de los datos para hacer el reporte de faltas
	DECLARE Date DATE;
	SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    SELECT STR_TO_DATE(aDate, "%d-%m-%Y") INTO Date;
	SELECT 	b.Folio Folio,
			b.nombre Nombre,
			fv.frecuencia Frecuencia,
			g.grupo Dia,
            b.telefono Telefono,
			IF(b.beca, "CON BECA", "SIN BECA") Beca,
			DATE_FORMAT(f.fecha, '%d-%m-%Y') FechaFalta,
			IF(m.idMotivo = 12, CONCAT("OTRO: ",fo.motivo), m.motivo) MotivoFalta,
			WEEKDAY(f.fecha)+1 DiaFalta,
            IF(WEEKDAY(f.fecha)+1 IN (1), "LUNES",
			IF(WEEKDAY(f.fecha)+1 IN (2), "MARTES",
			IF(WEEKDAY(f.fecha)+1 IN (3), "MIÉRCOLES",
			IF(WEEKDAY(f.fecha)+1 IN (4), "JUEVES",
			IF(WEEKDAY(f.fecha)+1 IN (5), "VIENES",
			IF(WEEKDAY(f.fecha)+1 IN (6), "SÁBADO", "DOMINGO")))))) DiaSemana,
            CURTIME() Hora,
			DATE_FORMAT(CURDATE(), '%d-%m-%Y') Fecha
	FROM Beneficiario b
		LEFT JOIN FrecuenciaVisita fv
		ON b.frecuenciaVisita_idFrecuenciaVisita = fv.idFrecuenciaVisita
		LEFT JOIN GrupoDia g
		ON b.grupoDia_idGrupoDia = g.idGrupoDia
		LEFT JOIN Sucursal s
		ON b.sucursal_idSucursal = s.idSucursal
		LEFT JOIN Falta f
		ON b.idBeneficiario = f.beneficiario_idBeneficiario
		LEFT JOIN Motivo m
		ON m.idMotivo = f.motivo_idMotivo
        LEFT JOIN FaltaOtro fo
        ON fo.falta_idFalta = f.idFalta
	WHERE f.fecha >= ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY)
		  AND f.fecha <= ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY)
          AND (b.sucursal_idSucursal = IdBranch
			  OR b.sucursal_idSucursal IS NULL)
	ORDER BY DiaFalta ASC;
END$$

DELIMITER ;



-- Rutina para la visualizacion del reporte de justificaciones
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `justificationReport`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `justificationReport` (IN aDate VARCHAR(12), IN idBranch INT)
BEGIN
	-- Obtencion de los datos para hacer el reporte de justificaciones
	DECLARE Date DATE;
	SET time_zone='America/Mexico_City'; -- Seteo de la zona horaria para que ponga la hora y dia correspondiente
    SELECT STR_TO_DATE(aDate, "%d-%m-%Y") INTO Date;
	SELECT 	b.Folio Folio,
			b.nombre Nombre,
			fv.frecuencia Frecuencia,
			g.grupo Dia,
			IF(b.beca, "CON BECA", "SIN BECA") Beca,
			DATE_FORMAT(j.fechaJustificada, '%d-%m-%Y') FechaJustificada,
            m.motivo Motivo,
			IF(m.idMotivo = 7, CONCAT("OTRO: ",jo.motivo), m.motivo) MotivoJustificacion,
			WEEKDAY(j.fechaJustificada)+1 DiaJustificado,
            IF(WEEKDAY(j.fechaJustificada)+1 IN (1), "LUNES",
			IF(WEEKDAY(j.fechaJustificada)+1 IN (2), "MARTES",
			IF(WEEKDAY(j.fechaJustificada)+1 IN (3), "MIÉRCOLES",
			IF(WEEKDAY(j.fechaJustificada)+1 IN (4), "JUEVES",
			IF(WEEKDAY(j.fechaJustificada)+1 IN (5), "VIENES",
			IF(WEEKDAY(j.fechaJustificada)+1 IN (6), "SÁBADO", "DOMINGO")))))) DiaSemana,
            CURTIME() Hora,
			DATE_FORMAT(CURDATE(), '%d-%m-%Y') Fecha
	FROM Beneficiario b
		LEFT JOIN FrecuenciaVisita fv
		ON b.frecuenciaVisita_idFrecuenciaVisita = fv.idFrecuenciaVisita
		LEFT JOIN GrupoDia g
		ON b.grupoDia_idGrupoDia = g.idGrupoDia
		LEFT JOIN Sucursal s
		ON b.sucursal_idSucursal = s.idSucursal
		LEFT JOIN Justificacion j
		ON b.idBeneficiario = j.beneficiario_idBeneficiario
		LEFT JOIN Motivo m
		ON m.idMotivo = j.motivo_idMotivo
        LEFT JOIN JustificacionOtro jo
        ON j.idJustificacion = jo.justificacion_idJustificacion
	WHERE j.fechaJustificada >= ADDDATE(Date, INTERVAL 0-WEEKDAY(Date) DAY)
		  AND j.fechaJustificada <= ADDDATE(Date, INTERVAL 6-WEEKDAY(Date) DAY)
          AND (b.sucursal_idSucursal = idBranch
			  OR b.sucursal_idSucursal IS NULL)
	ORDER BY IdMotivo ASC;
END$$

DELIMITER ;



-- Rutina para la visualizacion de la informacion mensual de asistencia en comunidad (FINALIZADO EL REPORTE).
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readInactiveCommunityAttendance`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readInactiveCommunityAttendance`(IN IdBranch INT)
BEGIN
	-- Visualizacion de la informacion mensual de asistencia en comunidad (FINALIZADO EL REPORTE).
	-- Se rescatan los valores esperados en la tabla del sistema, ademñas de calcular el valor de los paquetes
	-- enviados a comunidad en el tiempo que duro el reporte activo.
    -- Se agrupa por comunidad y el id de reporte mensual debido a que pueden existir multiples reportes de la misma comunidad.
	-- Se calcula la cantidad de paquetes enviados dependiendo las fechas de inicio y fin de los reportes.
	SELECT 	rm.idReporteMensual Id,
			DATE_FORMAT(rm.fechaInicio, '%d-%m-%Y') FechaInicio,
			DATE_FORMAT(rm.fechaFinal, '%d-%m-%Y') FechaFinal,
			c.nombre Comunidad,
			rm.comunidad_idComunidad idComunidad,
			SUM(p.cantPaquetesEnv) PaquetesTotales,
			rm.cantFirmas AsistenciasTotales
	FROM ReporteMensual rm
	LEFT JOIN Comunidad c
	ON rm.comunidad_idComunidad = c.idComunidad
	LEFT JOIN Peticion p
	ON p.comunidad_idComunidad = rm.comunidad_idComunidad
	WHERE rm.status = 0
		  AND p.fecha BETWEEN rm.fechaInicio AND rm.fechaFinal
		  AND c.sucursal_idSucursal = IdBranch
	GROUP BY rm.comunidad_idComunidad, rm.idReporteMensual
	ORDER BY rm.fechaFinal DESC, rm.comunidad_idComunidad ASC;
END$$

DELIMITER ;



-- Rutina para la obtencion del documento de asistencia de un reporte de comunidad.
 USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readCommunityReportDoc`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readCommunityReportDoc` (IN IdReport INT)
BEGIN
	-- Obtencion del documento de asistencia de un reporte de comunidad.
	SELECT l.idListaAsistencia IdListaAsistencia,
		   l.reporteMensual_idReporteMensual IdReporteMensual,
		   l.nombre Nombre,
		   l.data Data,
		   l.size Size,
		   l.mimetype Mimetype
	FROM ListaAsistencia l
    LEFT JOIN ReporteMensual r
    ON r.idReporteMensual = l.reporteMensual_idReporteMensual
    LEFT JOIN Comunidad c
    ON r.comunidad_idComunidad = c.idComunidad
    WHERE l.reporteMensual_idReporteMensual = IdReport;
END$$

DELIMITER ;