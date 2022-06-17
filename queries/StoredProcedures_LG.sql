-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: LISTA GLOBAL (LG)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Rutina para la visualización de los beneficiarios activos
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readActiveBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readActiveBeneficiaries` (IN IdBranch INT)
BEGIN
    -- Visualizacion de todos los beneficiarios activos y su informacion que sean de una sucursal especifica o que no tenga ninguna
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status, -- Status en formato descriptivo
           b.status IdStatus, -- Status en formato numerico
           IF( b.beca, "CON BECA", "SIN BECA") Beca,  -- Beca en formato descriptivo
           b.beca IdBeca, -- Beca en formato numerico
           b.colonia Colonia, -- Colonia donde vive el beneficiario
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           b.telefono Telefono,
           f.frecuencia Frecuencia, -- Frecuencia en formato descriptivo
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia, -- Frecuencia en formato numerico
           g.grupo Dia, -- Grupo dia en formato descriptivo
           b.grupoDia_idGrupoDia IdDia, -- Grupo dia en formato numerico
           s.nombre Sucursal, -- Sucursal en formato descriptivo
           b.sucursal_idSucursal IdSucursal, -- Sucursal en formato numerico
           IF(c.idCredencial IS NULL, 0, 1) Archivo -- Indicador si hay o no credencial del beneficiario
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
             LEFT JOIN Credencial c
                       ON c.beneficiario_idBeneficiario = b.idBeneficiario
    WHERE b.status = 1
      AND (b.Sucursal_idSucursal = IdBranch
        OR b.Sucursal_idSucursal IS NULL)
    ORDER BY b.folio, b.nombre ASC;
END$$

DELIMITER ;



-- Rutina para la obtencion de archivos de un solo beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaryDoc`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaryDoc` (IN IdBeneficiary  INT)
BEGIN
    -- Visualizacion de las credenciales de uno de los beneficiarios.
    SELECT c.idCredencial IdCredencial,
           c.beneficiario_idBeneficiario IdBeneficiario,
           c.nombre Nombre,
           c.data Data,
           c.size Size,
           c.mimetype Mimetype
    FROM Credencial c
             LEFT JOIN Beneficiario b
                       ON b.idBeneficiario = c.beneficiario_idBeneficiario
    WHERE b.idBeneficiario = IdBeneficiary;
END$$

DELIMITER ;



-- Rutina para la actualizacion/insercion masiva de beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `beneficiaryDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `beneficiaryDocs`(IN Folio VARCHAR(13), IN Name VARCHAR(60), IN Address VARCHAR(40), IN IdDay INT, IN StartDate DATE,
                                   IN EndDate DATE, IN Status TINYINT(1), IN aGrant TINYINT(1), IN IdFrequency INT,
                                   IN PhoneNumber VARCHAR(12), IN IdBranch INT, IN Counter INT)
BEGIN
    -- Administracion para la actualizacion/insercion masiva de beneficiarios
    DECLARE cBeneficiario INT;
    DECLARE IdBeneficiary INT;
    IF Counter = 0 THEN
        CALL `REDO_MAKMA`.`inactivateBeneficiaries`(); -- Checa si es el primero registro que se procesa, si lo es, se inactivan los beneficiarios
    -- Para que queden activos todos aquellos que califican para que lo sean.
    END IF;
    SELECT COUNT(*), b.idBeneficiario INTO cBeneficiario, IdBeneficiary FROM Beneficiario b WHERE b.folio = Folio;
    IF cBeneficiario = 0 THEN -- Se inserta un nuevo beneficiario si no existe
        CALL `REDO_MAKMA`.`createBeneficiary`(Folio,Name,Address,IdDay,StartDate,EndDate,Status,aGrant,IdFrequency,PhoneNumber,IdBranch);
        SELECT "SE INSERTA NUEVO USUARIO" respuesta;
    ELSE  -- Actualiza la informacion de los beneficiarios que ya existen
        CALL `REDO_MAKMA`.`updateBeneficiary`(Folio,Name,Address,IdDay,StartDate,EndDate,Status,aGrant,IdFrequency,PhoneNumber,IdBranch, IdBeneficiary);
        SELECT "SE ACTUALIZA UN USUARIO" respuesta;
    END IF;
END$$



-- Rutina para la actualizacion de archivos de un beneficiario del BAMX dado su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiaryDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiaryDocs` (IN IdBeneficiary INT, IN Name VARCHAR(70), IN Data MEDIUMBLOB, IN Size DOUBLE, IN Mimetype VARCHAR(20))
BEGIN
    -- Administracion para la actualizacion o insercion del archivo de la credencial de un beneficiario del BAMX
    DECLARE BadgeExist INT DEFAULT 0;
    SELECT COUNT(*) INTO BadgeExist
    FROM Credencial c
    WHERE c.beneficiario_idBeneficiario = IdBeneficiary;
    IF BadgeExist = 1 THEN -- Si ya tiene registrada una credencial antes, solamente se actualiza ese mismo registro
        UPDATE 	`REDO_MAKMA`.`Credencial`
        SET 	`nombre` = Name,
               `data` = Data,
               `size` = Size,
               `mimetype` = Mimetype
        WHERE 	`beneficiario_idBeneficiario` = IdBeneficiary;
    ELSE -- si no la tenia antes, se crea el registro de la credencial
        INSERT INTO `REDO_MAKMA`.`Credencial`
        (`nombre`, `data`, `size`, `mimetype`, `beneficiario_idBeneficiario`)
        VALUES (Name, Data, Size, Mimetype, IdBeneficiary);
    END IF;
END$$

DELIMITER ;



-- Rutina para la actualizacion del estado con que se encuentra el beneficiario con el BAMX dado su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiaryStatus`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiaryStatus` (IN IdBeneficiary INT, IN Status TINYINT(1))
BEGIN
    -- Actualizacion del estado con que se encuentra el beneficiario con el BAMX dado su id
    UPDATE 	`REDO_MAKMA`.`Beneficiario`
    SET 	`status` = Status
    WHERE 	`idBeneficiario` = IdBeneficiary;
    IF (Status = 1) THEN -- Se resetean las faltas cuando se reactiva un beneficiario
        CALL `REDO_MAKMA`.`updateAbscenceStatus`(0, IdBeneficiary);
    END IF;
END$$

DELIMITER ;