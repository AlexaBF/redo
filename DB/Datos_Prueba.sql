USE REDO_MAKMA;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DATOS DE PRUEBA EN LAS TABLAS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Datos de prueba para sucursal
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Cuernavaca'); -- 1
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Jiutepec'); -- 2
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Temixco'); -- 3
-- SELECT * FROM Sucursal;

-- Datos de prueba para rol
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Super usuario');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Trabajador social');
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Cajero');
-- SELECT * FROM Rol;

-- Datos de prueba para usuario
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba SU_C', '123', sha2('123', 224), '1', '1', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba TS_C', '456', sha2('123', 224), '2', '2', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba C_C', '789', sha2('123', 224), '3', '3', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba SU_J', '2123', sha2('123', 224), '4', '1', '2');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba TS_J', '2456', sha2('123', 224), '5', '2', '2');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba C_J', '2789', sha2('123', 224), '6', '3', '2');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba SU_T', '3123', sha2('123', 224), '7', '1', '3');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba TS_T', '3456', sha2('123', 224), '8', '2', '3');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`)
VALUES ('Prueba C_T', '3789', sha2('123', 224), '9', '3', '3');
-- SELECT * FROM Usuario;
CALL createUser ('juan torres', 'juan@juan.com', '12345678', '7770000010', 3, 1);
CALL createUser ('juan alfonso', 'juan@torres.com', '12345678', '7770000011', 2, 2);
CALL createUser ('Diana García', 'diana@diana.com', '12345678', '7770000012', 1, 3);
CALL createUser ('pedro González', 'pedro@pedro.com', '12345678', '7770000013', 1, 1);
CALL createUser ('Daniel Sánchez', 'daniel@daniel.com', '12345678', '7770000014', 2, 2);
CALL createUser ('Alejandra Rodríguez', 'alejandra@alejandra.com', '12345678', '7770000015', 3, 3);
CALL createUser ('Olivia Hernández', 'olivia@olivia.com', '12345678', '7770000016', 2, 1);
-- CALL createUser ('Prueba TS_C', '456', '123', '13', 2, 1);
-- CALL createUser ('Prueba C_C', '789', '123', '14', 3, 1);





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

-- ingreso de una peticion por paquetes por parte de las comunidades al BAMX
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '100', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '35', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-16', '58', '2', '2');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '550', '3', '3');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '50', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-10', '25', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '100', '2', '2');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-09', '50', '2', '2');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '150', '3', '3');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '100', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-07', '50', '1', '1');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '200', '2', '2');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '300', '3', '3');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-8', '150', '3', '3');

INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '100', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-16', '35', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '67', '14', '14');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '240', '15', '15');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '50', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-10', '25', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '100', '14', '14');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '150', '15', '15');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '100', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-07', '50', '13', '13');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '200', '14', '14');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '300', '15', '15');

INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '100', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-16', '35', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '43', '26', '26');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-05-31', '390', '27', '27');

INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '50', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-10', '25', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '100', '26', '26');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-04-20', '150', '27', '27');

INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '100', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-07', '50', '25', '25');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '200', '26', '26');
INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-03-15', '300', '27', '27');
-- SELECT * FROM Peticion;



-- INSERT INTO `REDO_MAKMA`.`Peticion` (`fecha`, `cantPaquetesEnv`, `comunidad_idComunidad`, `miembroComite_idMiembroComite`) VALUES ('2022-06-07', '250', '26', '26');
-- Ingreso de datos para realizar reporte mensual de las comunidades
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '400', '1');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '175', '2');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '1033', '3');

INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '300', '0', '1');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '275', '0', '2');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '533', '0', '3');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '200', '0', '1');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '375', '0', '2');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '833', '0', '3');

INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '400', '13');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '175', '14');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '1033', '15');

INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '300', '0', '13');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '275', '0', '14');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '533', '0', '15');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '200', '0', '13');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '375', '0', '14');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '833', '0', '15');

INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '400', '25');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '175', '26');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `comunidad_idComunidad`) VALUES ('2022-05-01', '2022-05-31', '1033', '27');

INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '300', '0', '25');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '275', '0', '26');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-04-01', '2022-04-30', '533', '0', '27');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '200', '0', '25');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '375', '0', '26');
INSERT INTO `REDO_MAKMA`.`ReporteMensual` (`fechaInicio`, `fechaFinal`, `cantFirmas`, `status`, `comunidad_idComunidad`) VALUES ('2022-03-01', '2022-03-31', '833', '0', '27');
-- SELECT * FROM ReporteMensual;






-- Ingreso de datos al catalogo del grupo acorde al dia en que van los beneficiarios.
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('LUNES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MARTES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('MIÉRCOLES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('JUEVES');
INSERT INTO `REDO_MAKMA`.`GrupoDia` (`grupo`) VALUES ('VIERNES');
-- SELECT * FROM GrupoDia;

-- Ingresas datos de primera par
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000001', 'Beneficiario prueba 1', '1', '1', '2022-02-01', '2023-02-01', 'La selva', '7770000001', '1', '1', '1');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000002', 'Beneficiario prueba 2', '1', '0', '2022-02-01', '2023-02-01', 'Antonio Barona', '7770000002', '2', '2', '2');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`, `sucursal_idSucursal`)
VALUES ('BACUER0000003', 'Beneficiario prueba 3', '1', '0', '2022-02-16', '2023-02-16', 'Rio Mayo', '7770000003', '3', '3', '3');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000004', 'Beneficiario prueba 4', '1', '0', '2022-02-16', '2023-02-16', 'Centro', '7770000004', '1', '4');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000005', 'Beneficiario prueba 5', '1', '0', '2022-02-16', '2023-02-16', 'Teopanzolco', '7770000005', '2', '5');

INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000006', 'Beneficiario prueba 6', '0', '0', '2021-03-01', '2022-03-01', 'Satelite', '7770000006', '3', '1'); -- Fecha vencida
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000007', 'Beneficiario prueba 7', '0', '0', '2021-03-01', '2022-03-01', 'Vergel', '7770000007', '1', '2'); -- Fecha Vencida
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000008', 'Beneficiario prueba 8', '0', '0', '2022-03-16', '2023-03-01', 'Guacamayas', '7770000008', '2', '3'); -- Meterles maximo de faltas
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000009', 'Beneficiario prueba 9', '0', '0', '2022-03-16', '2023-03-01', 'Lomas de cortez', '7770000009', '3', '4'); -- Meterles maximo de faltas
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000010', 'Beneficiario prueba 10', '0', '0', '2022-03-16', '2023-03-01', 'Morelos', '7770000010', '1', '5'); -- Meterles maximo de faltas

INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000011', 'Beneficiario prueba 11', '1', '0', '2022-04-01', '2023-04-01', 'Bosques de Cuernavaca', '7770000011', '2', '1');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000012', 'Beneficiario prueba 12', '1', '0', '2022-04-01', '2023-04-01', 'Chapultepec', '7770000012', '3', '2');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000013', 'Beneficiario prueba 13', '1', '0', '2022-04-16', '2023-04-16', 'Lomas de Zompantle', '7770000013', '1', '3');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000014', 'Beneficiario prueba 14', '1', '0', '2022-04-16', '2023-04-16', 'La carolina', '7770000014', '2', '4');
INSERT INTO `REDO_MAKMA`.`Beneficiario` (`folio`, `nombre`, `status`, `beca`, `fRegistro`, `fVencimiento`, `colonia`, `telefono`, `frecuenciaVisita_idFrecuenciaVisita`, `grupoDia_idGrupoDia`)
VALUES ('BACUER0000015', 'Beneficiario prueba 15', '1', '0', '2022-04-16', '2023-04-16', 'Palmira', '7770000015', '3', '5');
-- Chapultepec
-- Teopanzolco
-- Lomas de Zompantle
-- La carolina
-- Palmira
-- Guacamayas
-- SELECT * FROM Beneficiario;

-- Ingreso de datos al registro de asistencia de beneficiarios en punto
-- INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES (CURDATE(), '1');
-- INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES (CURDATE(), '2');
-- INSERT INTO `REDO_MAKMA`.`AsistenciaPunto` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-01', '3');
-- SELECT * FROM AsistenciaPunto;

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

-- Ingreso de datos al registro de faltas con motivo comun al realizarla con o sin motivo
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-05', '9');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-12', '9');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-19', '9');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-26', '9');

INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-06', '10');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-13', '10');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-20', '10');
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `beneficiario_idBeneficiario`) VALUES ('2022-05-27', '10');


/*
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-15', '0', '1', '8'); -- 1
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-24', '1', '1', '9'); -- 2
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-05-01', '1', '2', '10'); -- 3
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-05-02', '1', '3', '11'); -- 4
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-05-03', '1', '1', '10'); -- 5
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-08', '0', '4', '9'); -- 6
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-22', '1', '4', '8'); -- 7
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-04-29', '1', '4', '11'); -- 8
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-05-05', '1', '4', '10'); -- 9
INSERT INTO `REDO_MAKMA`.`Falta` (`fecha`, `status`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES ('2022-05-08', '1', '2', '8'); -- 10
*/
-- SELECT * FROM Falta;


-- Ingreso de datos al registro de justificaciones con motivo comun antes o despues de cometer la falta
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-02', '1', '1');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-09', '1', '2');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-16', '1', '3');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-24', '2', '4');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-31', '2', '5');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-04', '3', '6');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-11', '3', '1');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-18', '3', '2');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-26', '4', '3');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-20', '5', '4');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-05-27', '5', '5');
-- SELECT * FROM Justificacion;

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-02', '1', '1');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-09', '1', '2');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-16', '1', '3');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-24', '2', '4');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-31', '2', '5');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-04', '3', '6');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-11', '3', '1');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-18', '3', '2');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-26', '4', '3');

INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-20', '5', '4');
INSERT INTO `REDO_MAKMA`.`Justificacion` (`fechaPedido`, `fechaJustificada`, `beneficiario_idBeneficiario`, `motivo_idMotivo`) VALUES (CURDATE(), '2022-06-27', '5', '5');

-- Ingreso de datos al registro de faltas con motivo otros al realizarla con o sin motivo
-- INSERT INTO `REDO_MAKMA`.`FaltaOtro` (`motivo`, `falta_idFalta`) VALUES ('Murió', '4');
-- SELECT * FROM FaltaOtro;

-- Ingreso de datos al registro de justificaciones con motivo otros antes o despues de cometer la falta
-- INSERT INTO `REDO_MAKMA`.`JustificacionOtro` (`motivo`, `justificacion_idJustificacion`) VALUES ('No puede ir nadie', '3');
-- SELECT * FROM JustificacionOtro;







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