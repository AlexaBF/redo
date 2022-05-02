-- Visualización de los datos relevantes de los beneficiarios de una sucursal especifica
-- o que no tengan sucursal asignada.

USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaries` (IN IdBranch INT)
BEGIN
	SELECT b.idBeneficiario Id, b.folio Folio, b.nombre Nombre, b.credencial Credencial, b.estSocioEco EstudioSocioeconomico,
		   b.status Status, b.beca Beca, b.fRegistro FechaRegistro, b.fvencimiento FechaVencimiento, b.telefono Telefono,
		   f.frecuencia Frecuencia, g.grupo Dia, s.nombre Sucursal
	FROM Beneficiario b
    LEFT JOIN FrecuenciaVisita f
	ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
	LEFT JOIN GrupoDia g
	ON b.GrupoDia_idGrupoDia = g.idGrupoDia
	LEFT JOIN Sucursal s
	ON b.Sucursal_idSucursal = s.idSucursal
	WHERE b.Sucursal_idSucursal = IdBranch
	OR b.Sucursal_idSucursal IS NULL;
END$$

DELIMITER ;