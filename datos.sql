-- datos

SET foreign_key_checks = 0;

TRUNCATE TABLE aeropuertos;
TRUNCATE TABLE pistas;
TRUNCATE TABLE modelos;
TRUNCATE TABLE modelo_aterriza_en_pistas;
TRUNCATE TABLE programas_de_vuelo;
TRUNCATE TABLE aviones;
TRUNCATE TABLE vuelos;
TRUNCATE TABLE pasajeros;
TRUNCATE TABLE pasajeros_vuelos;
TRUNCATE TABLE tests;
TRUNCATE TABLE controles;

SET foreign_key_checks = 1;

INSERT INTO aeropuertos (codigo_internacional, nombre, direccion, ciudad, provincia, distancia_km) VALUES
('EZE', 'Aeropuerto Internacional Ministro Pistarini', 'Autopista Tte. Gral. Ricchieri Km 33,5, 1802', 'CABA', 'Buenos Aires', 35),
('AEP', 'Aeroparque Jorge Newbery', 'Av Rafael Obligado s/n, 1425', 'CABA', 'Buenos Aires', 2),
('MDQ', 'Aeropuerto Internacional de Mar del Plata Astor Piazzolla', 'Ruta 2 Km. 398,5, 7600', 'Mar del Plata', 'Buenos Aires', 7),
('BRC', 'Aeropuerto de San Carlos de Bariloche Teniente Luis Candelaria', 'Ruta Provincial Nº 80 S/Nº - (8400)', 'Bariloche', 'Rio Negro', 14),
('CCT', 'Aeropuerto Colonia Catriel', '37 54 36 S, 067 50 06 W', 'Catriel', 'Rio Negro', 30);

INSERT INTO pistas (id_aeropuerto, id_pista, largo, superficie) VALUES
('EZE', 1, 300, 'asfalto'),
('EZE', 2, 200, 'cemento'),
('AEP', 1, 150, 'cemento'),
('MDQ', 1, 200, 'cemento'),
('MDQ', 2, 200, 'asfalto'),
('BRC', 1, 150, 'cemento'),
('CCT', 1, 150, 'tierra');

-- -- capacidades reales: 141, 218, 467
INSERT INTO modelos (id_modelo, peso_toneladas, largo, capacidad) VALUES
(707, 152, 44, 10),
(767, 186, 54, 15),
(747, 447, 76, 20);

INSERT INTO programas_de_vuelo (id_programa, id_aerolinea, id_modelo, origen, destino, dias) VALUES
(1,  'LAN', 707, 'AEP', 'MDQ', 'LUNES,MARTES'), -- 1
(2, 'LAN', 767, 'MDQ', 'AEP', 'MIERCOLES'),
(3, 'LADE', 747, 'EZE', 'MDQ', 'JUEVES,VIERNES'), -- 2
(4, 'LADE', 747, 'MDQ', 'EZE', 'SABADO'),
(5, 'Aerolineas Argentinas', 767, 'EZE', 'MDQ', 'DOMINGO'), -- 3
(6, 'Aerolineas Argentinas', 767, 'MDQ', 'EZE', 'LUNES,MIERCOLES'),
(7, 'LADE', 747, 'AEP', 'BRC', 'MARTES');

INSERT INTO modelo_aterriza_en_pistas (id_aeropuerto, id_pista, id_modelo) VALUES
('EZE', 1, 747),
('AEP', 1, 747),
('EZE', 1, 767),
('AEP', 1, 767),
('BRC', 1, 707),
('CCT', 1, 707);

INSERT INTO aviones (id_avion, id_modelo, ano_de_fabricacion) VALUES
(1, 707, 1980), (2, 767, 1990), (3, 747, 1995), (4, 767, 2000);

INSERT INTO vuelos (id, id_programa, id_avion, fecha) VALUES
(501, 1, 1, '2014-07-01'),
(502, 2, 1, '2014-07-01'),
(601, 3, 2, '2015-08-01'),
(602, 4, 2, '2015-08-02'),
(301, 5, 3, '2013-09-01'),
(302, 6, 3, '2013-09-22'),
(401, 5, 3, '2013-10-01'),
(402, 6, 4, '2013-10-22'),
(701, 7, 3, '2014-07-01');

INSERT INTO pasajeros (tipo_documento, nro_documento, nombre, nacionalidad, fecha_nacimiento, sexo) VALUES
('DNI', 30111222, 'Fulano Fulanes', 'ARGENTINA', '1950-02-20', 'M'),
('DNI', 20777888, 'Perengano Perenganes', 'ARGENTINA', '1970-04-20', 'M'),
('DNI', 25666999, 'Mengana Menganes', 'ARGENTINA', '1980-03-20', 'F'),
('DNI', 29222111, 'Pirulo Pirules', 'ARGENTINA', '1988-08-20', 'M'),
('DNI', 29222112, 'Pirula Pirules', 'ARGENTINA', '1988-08-20', 'F'),
('DNI', 45666777, 'Kumiko Suzuki', 'JAPON', '1988-08-20', 'F'),
('DNI', 29222114, 'Pirula1 Pirules', 'ARGENTINA', '1988-08-21', 'F'),
('DNI', 29222115, 'Pirula2 Pirules', 'ARGENTINA', '1988-08-22', 'F'),
('DNI', 29222116, 'Pirula3 Pirules', 'ARGENTINA', '1988-08-23', 'F'),
('DNI', 29222117, 'Pirula4 Pirules', 'ARGENTINA', '1988-08-24', 'F'),
('DNI', 29222118, 'Pirula5 Pirules', 'ARGENTINA', '1988-08-25', 'F'),
('DNI', 29222119, 'Pirula6 Pirules', 'ARGENTINA', '1988-08-26', 'F'),
('DNI', 29222120, 'Pirula7 Pirules', 'ARGENTINA', '1988-08-27', 'F'),
('DNI', 29222121, 'Pirula8 Pirules', 'ARGENTINA', '1988-08-28', 'F'),
('DNI', 29222137, 'PirulaA Pirules', 'ARGENTINA', '1988-09-24', 'F'),
('DNI', 29222138, 'PirulaB Pirules', 'ARGENTINA', '1988-09-25', 'F'),
('DNI', 29222139, 'PirulaC Pirules', 'ARGENTINA', '1988-09-26', 'F'),
('DNI', 29222130, 'PirulaD Pirules', 'ARGENTINA', '1988-09-27', 'F'),
('DNI', 29222131, 'PirulaE Pirules', 'ARGENTINA', '1988-09-28', 'F'),
('DNI', 19222131, 'Juan Carlos Barilochense', 'ARGENTINA', '1942-10-03', 'M')
;

INSERT INTO pasajeros_vuelos (id_pasajero, id_vuelo) VALUES
(1, 501),
(1, 502),
(2, 401),
(2, 402),
(3, 401),
(3, 402),
(6, 501),
(6, 502),
(7, 402),
(8, 402),
(9, 402),
(10, 402),
(11, 402),
(12, 402),
(13, 402),
(14, 402),
(15, 402),
(16, 402),
(17, 402),
(18, 402),
(19, 402),
(20, 701)
;

INSERT INTO tests (id_test, nombre) VALUES
(1, 'seguridad'),
(2, 'mecanica');

INSERT INTO controles (id_aeropuerto, id_test, id_avion, fecha, puntaje) VALUES
('AEP', 1, 1, '2012-12-30', 5),
('MDQ', 1, 3, '2012-08-01', 3),
('AEP', 1, 3, '2013-08-01', 5),
('AEP', 1, 3, '2014-08-20', 7),
('AEP', 1, 3, '2014-09-11', 8),
('MDQ', 1, 3, '2014-10-11', 9),
('MDQ', 2, 3, '2014-10-11', 9);
