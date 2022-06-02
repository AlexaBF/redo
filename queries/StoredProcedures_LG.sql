-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- STORED PROCEDURES DEL SISTEMA: LISTA GLOBAL (LG)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- *9.1 Rutina para visualizacion de todos los beneficiarios de una sucursal
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaries`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaries` (IN IdBranch INT)
BEGIN
    -- visualizacion de todos los beneficiarios y todos los datos de una sucursal especifica o que no tenga ninguna
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status, -- Status en formato descriptivo
           b.status IdStatus, -- Status en formato numerico
           IF( b.beca, "CON BECA", "SIN BECA") Beca,  -- Beca en formato descriptivo
           b.beca IdBeca, -- Beca en formato numerico
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           b.telefono Telefono,
           f.frecuencia Frecuencia, -- Frecuencia en formato descriptivo
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia, -- Frecuencia en formato numerico
           g.grupo Dia, -- Grupo dia en formato descriptivo
           b.grupoDia_idGrupoDia IdDia, -- Grupo dia en formato numerico
           s.nombre Sucursal, -- Sucursal en formato descriptivo
           b.sucursal_idSucursal IdSucursal -- Sucursal en formato numerico
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
    WHERE b.Sucursal_idSucursal = IdBranch
       OR b.sucursal_idSucursal IS NULL;
END$$

DELIMITER ;



-- *12.1 Rutina para la actualizacion datos generales (General Data) del beneficiario
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiaryGD`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiaryGD` (IN IdBeneficiary INT, IN aGrant TINYINT(1), IN PhoneNumber VARCHAR(12), IN IdDay INT, IN IdFrequency INT)
BEGIN
    -- Actualizacion de los datos generales de un beneficiario que son opcionales de poner/cambiar en el sistema
    UPDATE 	`REDO_MAKMA`.`Beneficiario`
    SET 	`beca` = aGrant,
           `telefono` = PhoneNumber,
           `grupoDia_idGrupoDia`= IdDay,
           `frecuenciaVisita_idFrecuenciaVisita`= IdFrequency
    WHERE 	`idBeneficiario` = IdBeneficiary;
END$$

DELIMITER ;



-- *11.1 Rutina para visualizacion de uno de los beneficiarios segun su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiary`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiary` (IN IdBeneficiary INT)
BEGIN
    -- Visualizacion de uno los beneficiarios y todos los datos de una sucursal especifica o que no tenga ninguna
    SELECT b.idBeneficiario Id,
           b.folio Folio,
           b.nombre Nombre,
           IF( b.status, "ACTIVO", "INACTIVO") Status, -- Status en formato descriptivo
           b.status IdStatus, -- Status en formato numerico
           IF( b.beca, "CON BECA", "SIN BECA") Beca,  -- Beca en formato descriptivo
           b.beca IdBeca, -- Beca en formato numerico
           DATE_FORMAT(b.fRegistro, '%d-%m-%Y') FechaRegistro, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           DATE_FORMAT(b.fvencimiento, '%d-%m-%Y') FechaVencimiento, -- Cambio de formato de la fecha de %Y-%m-%d a %d-%m-%Y
           b.telefono Telefono,
           f.frecuencia Frecuencia, -- Frecuencia en formato descriptivo
           b.frecuenciaVisita_idFrecuenciaVisita IdFrecuencia, -- Frecuencia en formato numerico
           g.grupo Dia, -- Grupo dia en formato descriptivo
           b.grupoDia_idGrupoDia IdDia, -- Grupo dia en formato numerico
           s.nombre Sucursal, -- Sucursal en formato descriptivo
           b.sucursal_idSucursal IdSucursal -- Sucursal en formato numerico
    FROM Beneficiario b
             LEFT JOIN FrecuenciaVisita f
                       ON b.frecuenciaVisita_idFrecuenciaVisita = f.idFrecuenciaVisita
             LEFT JOIN GrupoDia g
                       ON b.grupoDia_idGrupoDia = g.idGrupoDia
             LEFT JOIN Sucursal s
                       ON b.sucursal_idSucursal = s.idSucursal
    WHERE b.idBeneficiario = IdBeneficiary;
END$$

DELIMITER ;



-- *16.1 Rutina para la visualizacion del catálogo de frecuencias de asistencia de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readFrequencies`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readFrequencies` ()
BEGIN
    -- Visualizacion del catálogo de frecuencias de asistencia de los beneficiarios
    SELECT 	idFrecuenciaVisita Id,
              frecuencia Frecuencia
    FROM FrecuenciaVisita;
END$$

DELIMITER ;



-- *17.1 Rutina para la visualizacion del catálogo de grupo por dias de asistencia de los beneficiarios
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readDays`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readDays` ()
BEGIN
    -- Visualizacion del catálogo de grupo por dias de asistencia de los beneficiarios
    SELECT	idGrupoDia Id,
              grupo Grupo
    FROM GrupoDia;
END$$

DELIMITER ;



-- *51.1 Rutina para la actualizacion/insercion masiva de beneficiarios
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
    DECLARE Id INT;
    IF Counter = 0 THEN
        CALL `REDO_MAKMA`.`inactivateBeneficiaries`();
    END IF;
    SELECT COUNT(*), b.idBeneficiario INTO cBeneficiario, Id FROM Beneficiario b WHERE b.folio = Folio;
    IF cBeneficiario = 0 THEN
        CALL `REDO_MAKMA`.`createBeneficiary`(Folio,Name,Address,IdDay,StartDate,EndDate,Status,aGrant,IdFrequency,PhoneNumber,IdBranch);
        SELECT "SE INSERTA NUEVO USUARIO" respuesta;
    ELSE
        CALL `REDO_MAKMA`.`updateBeneficiary`(Folio,Name,Address,IdDay,StartDate,EndDate,Status,aGrant,IdFrequency,PhoneNumber,IdBranch, Id);
        SELECT "SE ACTUALIZA UN USUARIO" respuesta;
    END IF;
    -- SELECT "OTRA RESPUESTA" respuesta;
END$$




USE `REDO_MAKMA`;
DROP procedure IF EXISTS `readBeneficiaryDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `readBeneficiaryDocs` (IN IdBranch INT)
BEGIN
    SELECT c.idCredencial IdCredencial,
           c.beneficiario_idBeneficiario IdBeneficiario,
           c.nombre Nombre,
           c.data Data,
           c.size Size,
           c.mimetype Mimetype
    FROM Credencial c;
END$$

DELIMITER ;




-- *13.1 Rutina para la actualizacion de archivos de un beneficiario del BAMX dado su id
USE `REDO_MAKMA`;
DROP procedure IF EXISTS `updateBeneficiaryDocs`;

DELIMITER $$
USE `REDO_MAKMA`$$
CREATE PROCEDURE `updateBeneficiaryDocs` (IN IdBeneficiary INT, IN Name VARCHAR(40), IN Data MEDIUMBLOB, IN Size DOUBLE, IN Mimetype VARCHAR(40))
BEGIN
    -- Administracion para la actualizacion o insercion del archivo de la credencial de un beneficiario del BAMX
    DECLARE BadgeExist INT;
    SELECT COUNT(*) INTO BadgeExist
    FROM Credencial c
    WHERE c.beneficiario_idBeneficiario = IdBeneficiary;
    IF BadgeExist=1 THEN
        UPDATE 	`REDO_MAKMA`.`Credencial`
        SET 	`nombre` = Name,
               `data` = Data,
               `size` = Size,
               `mimetype` = Mimetype
        WHERE 	`beneficiario_idBeneficiario` = IdBeneficiary;
    ELSE
        INSERT INTO `REDO_MAKMA`.`Credencial`
        (`nombre`, `data`, `size`, `mimetype`, `beneficiario_idBeneficiario`)
        VALUES (Name, Data, Size, Mimetype, IdBeneficiary);
    END IF;
END$$

DELIMITER ;



-- *14.1 Rutina para la actualizacion del estado con que se encuentra el beneficiario con el BAMX dado su id
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
END$$

DELIMITER ;