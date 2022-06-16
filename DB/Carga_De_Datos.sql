USE REDO_MAKMA;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DATOS INICIALES PARA LAS TABLAS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Datos para sucursal
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Cuernavaca'); -- 1
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Jiutepec'); -- 2
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Temixco'); -- 3
-- SELECT * FROM Sucursal;

-- Datos roles de usuario
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Super usuario');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Trabajador social');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Cajero');
-- SELECT * FROM Rol;

-- Datos de usuarios de iniciales
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba SU_C', '123', sha2('123', 224), '1', '1', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba TS_C', '456', sha2('123', 224), '2', '2', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba C_C', '789', sha2('123', 224), '3', '3', '1');
-- SELECT * FROM Usuario;

-- Ingreso de datos al catalogo de las frecuencias con las que los beneficiarios pueden
-- ir a la sucursal por su paquete alimentario o comunidades.
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('SEMANAL');
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('QUINCENAL');
INSERT INTO `REDO_MAKMA`.`FrecuenciaVisita` (`frecuencia`) VALUES ('MENSUAL');
-- SELECT * FROM FrecuenciaVisita;

-- Ingreso de datos al catalogo de estados que atiende el BAMX con alguna comunidad
INSERT INTO `REDO_MAKMA`.`Estado` (`estado`) VALUES ('Morelos');
INSERT INTO `REDO_MAKMA`.`Estado` (`estado`) VALUES ('Guerrero');
-- SELECT * FROM Estado;

-- Ingreso de datos al catalogo de municipios que atiende el BAMX con alguna comunidad
-- Morelos
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Puente de Ixtla', '1'); -- 1
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Cuernavaca', '1'); -- 2
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Yautepec', '1'); -- 3
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Totolapan', '1'); -- 4
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Jiutepec', '1'); -- 5
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Temixco', '1'); -- 6
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Xochitepec', '1'); -- 7
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Tepoztlán', '1'); -- 8
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Ayala', '1'); -- 9
-- Guerrero
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Cocula', '2'); -- 10
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Huitzuco de los Figueroa', '2'); -- 11
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Taxco de Alarcón', '2'); -- 12
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Tepecoacuilco de Trujano', '2'); -- 13
INSERT INTO `REDO_MAKMA`.`Municipio` (`municipio`, `estado_idEstado`) VALUES ('Atenango del Río', '2'); -- 14
-- SELECT * FROM Municipio;

-- Ingreso de datos al catalogo de comunidades que atiende alguna de las sucursales del BAMX
-- Jiutepec 2
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Nachitos', '1', '2', '5', '1'); -- **** 1
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Casa Comunitaria', '1', '2', '5', '1'); -- **** 2
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Amador Salazar', '1', '2', '5', '1'); -- **** 3
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('El Copalar', '1', '2', '3', '1'); -- 4
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Jardín Juárez', '1', '2', '5', '1'); -- **** 5
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Totolapan', '1', '2', '4', '1'); -- 6
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Extrema Pobreza', '1', '2', '5', '1'); -- **** 7
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Sembrando Iniciativa', '1', '2', '5', '1'); -- **** 8
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('La Corona', '1', '2', '5', '1'); -- 9
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('La Joya', '1', '2', '9', '1'); -- 10
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Musicos', '1', '2', '5', '2'); -- **** 11
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Atlacomulco', '1', '2', '5', '2'); -- **** 12
-- Temixco 3
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Acatlipa', '1', '3', '6', '1'); -- 1
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Puente de Ixtla', '1', '3', '1', '1'); -- 2
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Universo', '1', '3', '2', '3'); -- **** 3
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Alpuyeca', '1', '3', '7', '1'); -- 4
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Apango', '1', '3', '10', '1'); -- **** 5
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Huitzuco', '1', '3', '11', '1'); -- 6
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Huitzuco 2', '1', '3', '11', '1'); -- 7
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Santisima Trinidad', '1', '3', '8', '1'); -- **** 8
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Comunidad 2020', '1', '3', '6', '1'); -- **** 9
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Taxco', '1', '3', '12', '1'); -- 10
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Trujano Gro', '1', '3', '13', '3'); -- 11
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Unidad Morelos', '1', '3', '7', '1'); -- 12
-- Cuernavaca 1
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Tepoztlán', '1', '1', '8', '2'); -- 1
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Atenango', '1', '1', '13', '3'); -- **** 2
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Atenango 2', '1', '1', '13', '3'); -- **** 3
INSERT INTO `REDO_MAKMA`.`Comunidad` (`nombre`, `status`, `sucursal_idSucursal`, `municipio_idMunicipio`, `frecuenciaVisita_idFrecuenciaVisita`)
VALUES ('Centro', '1', '1', '2', '1'); -- 4
-- SELECT * FROM Comunidad;

-- Ingreso de datos al catalogo de miembros de comite de comunidades de una comunidad
-- Jiutepec 2
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Maritza Bautista', '7775938231', '1');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Jesus Acatitla Adame', '7773889331', '2');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Ever Salinas Rodríguez', '7772932395', '3');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Maria Esther Salgado Aguilar', '7351617539', '4');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Petra García Castrejón', '7775167332', '5');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Gabriela Rodríguez', '7351814522', '6');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Sabine Becht de Pinzón', '7772709544', '7');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Enrique Carmona', '7772337599', '8');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Luis Daniel Silvar Figueroa', '7772252366', '9');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Norma Leticia Nava', '7775667898', '10');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Eduardo Corona Carmín', '7771810003', '11');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Cecilia', '7771839990', '12');
-- Temixco 3
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Emilia', '7775670464', '13');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Jesus Castro', '7341321393', '14');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Guadalupe', '7774456471', '15');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Yuri Esquivel', '7772063719', '16');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Mayte Rivera', '7471500725', '17');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Jesus', '7774381345', '18');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Eva Gisela', '7271036805', '19');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Victor', '7341159404', '20');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Victor Suastegui', '7341141416', '21');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Neftali Araujo Torres', '7778312182', '22');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Pedro López Ocampo', '7331279499', '23');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Román Ramón Bautista', '7774443173', '24');
-- Cuernavaca 1
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Efren  Meza Villaseñor', '7773601652', '25');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Jesica Gutierrez Ocampo', '7271051898', '26');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Aurea Rivera Guerrero', '7271062781', '27');
INSERT INTO `REDO_MAKMA`.`MiembroComite` (`nombre`, `telefono`, `comunidad_idComunidad`) VALUES ('Yolanda  Bello Alarcón', '7772156548', '28');
-- SELECT * FROM MiembroComite;

-- Ingreso de datos al catalogo del grupo acorde al dia en que van los beneficiarios.
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('LUNES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MARTES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MIÉRCOLES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('JUEVES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('VIERNES');
-- SELECT * FROM GrupoDia;

-- Ingreso de datos al catalogo de los tipo de motivo con los que un beneficiario puede tener una falta justificada o no
INSERT INTO `REDO_MAKMA`.`MotivoTipo` (`tipo`) VALUES ('Justificacion');
INSERT INTO `REDO_MAKMA`.`MotivoTipo` (`tipo`) VALUES ('Falta');
-- SELECT * FROM MotivoTipo;

-- Ingreso de datos al catalogo de los motivos principales con los que un beneficiario puede tener una falta justificada o no
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Salud', '1'); -- 1
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Covid', '1'); -- 2
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Trabajo', '1'); -- 3
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Ingresos', '1'); -- 4
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Salida', '1'); -- 5
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Falta de tiempo', '1'); -- 6

INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Otros', '1'); -- 7

INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Buzón', '2'); -- 8
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Colgó', '2'); -- 9
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('El número no existe', '2'); -- 10
INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('No tiene número', '2'); -- 11

INSERT INTO `REDO_MAKMA`.`Motivo` (`motivo`, `MotivoTipo_idMotivoTipo`) VALUES ('Otros', '2'); -- 12
-- SELECT * FROM Motivo;


UPDATE `REDO_MAKMA`.`Sucursal`  SET `nombre` = UPPER(`nombre`)  WHERE (`idSucursal` >= 1);
UPDATE `REDO_MAKMA`.`Rol` 		SET `tipo` = UPPER(`tipo`) 		WHERE (`idRol` >= 1);
UPDATE `REDO_MAKMA`.`Usuario` 	SET `nombre`= UPPER(`nombre`),
                                     `correo`= UPPER(`correo`) 	WHERE (`idUsuario` >= 1);

UPDATE `REDO_MAKMA`.`Estado` 		SET `estado` = UPPER(`estado`) 		 WHERE (`idEstado` >= 1);
UPDATE `REDO_MAKMA`.`Municipio` 	SET `municipio` = UPPER(`municipio`) WHERE (`idMunicipio` >= 1);
UPDATE `REDO_MAKMA`.`Comunidad` 	SET `nombre` = UPPER(`nombre`) 		 WHERE (`idComunidad` >= 1);
UPDATE `REDO_MAKMA`.`MiembroComite` SET `nombre` = UPPER(`nombre`) 		 WHERE (`idMiembroComite` >= 1);

UPDATE `REDO_MAKMA`.`GrupoDia` 	   		SET `grupo` = UPPER(`grupo`) 		   WHERE (`idGrupoDia` >= 1);
UPDATE `REDO_MAKMA`.`FrecuenciaVisita`  SET `frecuencia` = UPPER(`frecuencia`) WHERE (`idFrecuenciaVisita` >= 1);
UPDATE `REDO_MAKMA`.`Motivo` 			SET `motivo` = UPPER(`motivo`) 		   WHERE (`idMotivo` >= 1);
UPDATE `REDO_MAKMA`.`MotivoTipo` 		SET `tipo` = UPPER(`tipo`) 			   WHERE (`idMotivoTipo` >= 1);