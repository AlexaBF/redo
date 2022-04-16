USE REDO_MAKMA;

-- Datos de prueba para sucursal
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Cuernavaca'); -- id: 1
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Jiutepec'); -- id: 2
INSERT INTO `REDO_MAKMA`.`Sucursal` (`nombre`) VALUES ('Temixco'); -- id: 3

-- Datos de prueba para rol
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Super usuario'); -- id: 1
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Trabajador social'); -- id: 2
INSERT INTO `REDO_MAKMA`.`Rol` (`tipo`) VALUES ('Cajero'); -- id: 3

-- Datos de prueba para usuario
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `apellidos`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`) 
VALUES ('Juan', 'Perez', 'Juan@juan.com', sha('1234'), '12345', '1', '1');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `apellidos`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`) 
VALUES ('Mauricio', 'Merida', 'Mauricio@mauricio.com', sha('1234'), '123456', '2', '2');
INSERT INTO `REDO_MAKMA`.`Usuario` (`nombre`, `apellidos`, `correo`, `password`, `telefono`, `rol_idRol`, `sucursal_idSucursal`) 
VALUES ('Alexa', 'Basurto', 'Alexa@alexa.com', sha('1234'), '1234567', '3', '3');