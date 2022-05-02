USE REDO_MAKMA;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DATOS DE PRUEBA EN LAS TABLAS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Ingreso de datos al catalogo de sucursal que tiene el BAMX
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Cuernavaca');
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Jiutepec');
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Temixco');
-- SELECT * FROM Sucursal;

-- Ingreso de datos al catalogo de roles de usuario que tiene el sistema REDO
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Super usuario');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Trabajador social');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Cajero');
-- SELECT * FROM Rol;

-- Ingreso de datos de usuarios que tiene el sistema REDO
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Juan Perez', 'Juan@juan.com', sha2('1234', 224), '12345', '1', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Mauricio Merida', 'Mauricio@mauricio.com', sha2('1234', 224), '123456', '2', '2');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Alexa Basurto', 'Alexa@alexa.com', sha2('1234', 224), '1234567', '3', '3');
-- SELECT * FROM Usuario;






-- Ingreso de datos al catalogo de estados que atiende el BAMX con alguna comunidad
INSERT INTO `REDO_MAKMA`.`Estado` (`estado`) VALUES ('Morelos');
INSERT INTO `REDO_MAKMA`.`Estado` (`estado`) VALUES ('Guerrero');
-- SELECT * FROM Estado;

-- Ingreso de datos al catalogo de municipios que atiende el BAMX con alguna comunidad
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Puente de Ixtla', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Cuernavaca', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Cuautla', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Mazatepec', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Amacuzac', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Temixco', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Xochitepec', '1');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Chilapa', '2');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Acapulco de Juárez', '2');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Apaxtla', '2');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Ajuchitlán del Progreso', '2');
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Atoyac de Álvarez', '2');
-- SELECT * FROM Municipio;

-- Ingreso de datos al catalogo de comunidades que atiende alguna de las sucursales del BAMX
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`)
VALUES ('Puente de Ixtla 1', '1', '3', '1');
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`)
VALUES ('Cuernavaca 1', '1', '1', '2');
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`)
VALUES ('Coahuixtla 1', '0', '3', '5');
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`)
VALUES ('Acapulco 1', '1', '2', '9');
-- SELECT * FROM Comunidad;

-- Ingreso de datos al catalogo de miembros de comite de comunidades de una comunidad
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`)
VALUES ('Juan De Jesus', '777123456789', '1');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`)
VALUES ('Juanita Perengana Diaz', '123456789012', '2');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`)
VALUES ('Perengana Pancracia de Dios', '678901234556', '3');
-- SELECT * FROM MiembroComite;

-- Ingreso de datos para peticiones por paquetes por parte de las comunidades al BAMX
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES (CURDATE(), '100', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES (CURDATE(), '58', '2', '2');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES (CURDATE(), '550', '3', '3');
-- SELECT * FROM Peticion;

-- Ingreso de datos para realizar reporte mensual de las comunidades
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '400', '1');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '175', '2');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '1033', '3');
-- SELECT * FROM ReporteMensual;






-- Ingreso de datos al catalogo del grupo acorde al dia en que van los beneficiarios.
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('LUNES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MARTES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MIERCOLES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('JUEVES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('VIERNES');
-- SELECT * FROM GrupoDia;

-- Ingreso de datos al catalogo de las frecuencias con las que los beneficiarios pueden
-- ir a la sucursal por su paquete alimentario.
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('SEMANAL');
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('QUINCENAL');
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('MENSUAL');
-- SELECT * FROM FrecuenciaVisita;

-- Ingreso de datos de beneficiarios a mano (será con archivo, pero estos son de prueba por ahora)
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000001', 'Beneficiario prueba 1', '1', '1', CURDATE(), '2023-05-01', 'La selva', '777123456789', '1', '1', '1');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000002', 'Beneficiario prueba 2', '0', '0', '2021-04-01', CURDATE(), 'la Barona', '7770987612345', '2', '2', '2');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000003', 'Beneficiario prueba 3', '1', '0', '2021-01-16', CURDATE(), 'Rio Mayo', '777 67890 5432', '3', '3', '3');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000004', 'Beneficiario prueba 4', '1', '0', '2021-01-16', CURDATE(), 'Centro', '777678905438', '3', '3');
-- SELECT * FROM Beneficiario;

-- Ingreso de datos al registro de asistencia de beneficiarios en punto
INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES (CURDATE(), '1');
INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES (CURDATE(), '2');
INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-01', '3');
-- SELECT * FROM AsistenciaPunto;

-- Ingreso de datos al catalogo de los tipo de motivo con los que un beneficiario puede tener una falta justificada o no
INSERT INTO `REDO_MAKMA`.`MotivoTipo` (`tipo`) VALUES ('Justificacion');
INSERT INTO `REDO_MAKMA`.`MotivoTipo` (`tipo`) VALUES ('Falta');
-- SELECT * FROM MotivoTipo;

-- Ingreso de datos al catalogo de los motivos principales con los que un beneficiario puede tener una falta justificada o no
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Salud', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Covid', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Trabajo', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Ingresos', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Salida', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Falta de tiempo', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Otros', '1');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Buzón', '2');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Colgó', '2');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('El número no existe', '2');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('No tiene número', '2');
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Otros', '2');
-- SELECT * FROM Motivo;

-- Ingreso de datos al registro de faltas con motivo comun al realizarla con o sin motivo
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-15', '0', '1', '8');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-24', '1', '1', '9');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '1', '2', '10');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '1', '3', '11');
-- SELECT * FROM Falta;


-- Ingreso de datos al registro de justificaciones con motivo comun antes o despues de cometer la falta
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-01', '1', '4');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-04-28', '2', '5');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-30', '3', '7');
-- SELECT * FROM Justificacion;

-- Ingreso de datos al registro de faltas con motivo otros al realizarla con o sin motivo
INSERT INTO `REDO_MAKMA`.`FaltaOtro` (`motivo`, `falta_idFalta`) VALUES ('Murió', '4');
-- SELECT * FROM FaltaOtro;

-- Ingreso de datos al registro de justificaciones con motivo otros antes o despues de cometer la falta
INSERT INTO `REDO_MAKMA`.`JustificacionOtro` (`motivo`, `justificacion_idJustificacion`) VALUES ('No puede ir nadie', '3');
-- SELECT * FROM JustificacionOtro;






-- Estandarización de toda cadena de texto que es ingresada al sistema.
UPDATE `REDO_MAKMA`.`Sucursal`  SET `nombre` = UPPER(`nombre`)  WHERE (`idSucursal` >= 1);
UPDATE `REDO_MAKMA`.`Rol` 		SET `tipo` = UPPER(`tipo`) 		WHERE (`idRol` >= 1);
UPDATE `REDO_MAKMA`.`Usuario` 	SET `nombre`= UPPER(`nombre`),
									`correo`= UPPER(`correo`) 	WHERE (`idUsuario` >= 1);


UPDATE `REDO_MAKMA`.`Estado` 		SET `estado` = UPPER(`estado`) 		 WHERE (`idEstado` >= 1);
UPDATE `REDO_MAKMA`.`Municipio` 	SET `municipio` = UPPER(`municipio`) WHERE (`idMunicipio` >= 1);
UPDATE `REDO_MAKMA`.`Comunidad` 	SET `nombre` = UPPER(`nombre`) 		 WHERE (`idComunidad` >= 1);
UPDATE `REDO_MAKMA`.`MiembroComite` SET `nombre` = UPPER(`nombre`) 		 WHERE (`idMiembroComite` >= 1);
UPDATE `REDO_MAKMA`.`Comunidad` 	SET `nombre` = UPPER(`nombre`) 		 WHERE (`idComunidad` >= 1);


UPDATE `REDO_MAKMA`.`Beneficiario` 		SET `nombre` = UPPER(`nombre`),
											`folio` = UPPER(`folio`),
											`colonia` = UPPER(`colonia`)  	   WHERE (`idBeneficiario` >= 1);
UPDATE `REDO_MAKMA`.`GrupoDia` 	   		SET `grupo` = UPPER(`grupo`) 		   WHERE (`idGrupoDia` >= 1);
UPDATE `REDO_MAKMA`.`FrecuenciaVisita`  SET `frecuencia` = UPPER(`frecuencia`) WHERE (`idFrecuenciaVisita` >= 1);
UPDATE `REDO_MAKMA`.`Motivo` 			SET `motivo` = UPPER(`motivo`) 		   WHERE (`idMotivo` >= 1);
UPDATE `REDO_MAKMA`.`MotivoTipo` 		SET `tipo` = UPPER(`tipo`) 			   WHERE (`idMotivoTipo` >= 1);
UPDATE `REDO_MAKMA`.`FaltaOtro` 		SET `motivo` = UPPER(`motivo`) 		   WHERE (`idFaltaOtro` >= 1);
UPDATE `REDO_MAKMA`.`JustificacionOtro` SET `motivo` = UPPER(`motivo`) 		   WHERE (`idJustificacionOtro` >= 1);