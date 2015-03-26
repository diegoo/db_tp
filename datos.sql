-- datos

SET foreign_key_checks = 0;

TRUNCATE TABLE aeropuertos;
TRUNCATE TABLE superficies;
TRUNCATE TABLE pistas;
TRUNCATE TABLE aerolineas;
TRUNCATE TABLE modelos_de_avion;
TRUNCATE TABLE programas_de_vuelo;
TRUNCATE TABLE aviones;
TRUNCATE TABLE vuelos;
TRUNCATE TABLE pasajeros;
TRUNCATE TABLE pasajeros_vuelos;
TRUNCATE TABLE tests;
TRUNCATE TABLE pistas_modelos;

SET foreign_key_checks = 1;

INSERT INTO aeropuertos VALUES ('EZE', 'Aeropuerto Internacional Ministro Pistarini', 'Autopista Tte. Gral. Ricchieri Km 33,5, 1802', 'CABA', 'Buenos Aires', 35), ('AEP', 'Aeroparque Jorge Newbery', 'Av Rafael Obligado s/n, 1425', 'CABA', 'Buenos Aires', 2), ('MDQ', 'Aeropuerto Internacional de Mar del Plata Astor Piazzolla', 'Ruta 2 Km. 398,5, 7600', 'Mar del Plata', 'Buenos Aires', 7), ('BRC', 'Aeropuerto de San Carlos de Bariloche Teniente Luis Candelaria', 'Ruta Provincial Nº 80 S/Nº - (8400)', 'Bariloche', 'Rio Negro', 14), ('CCT', 'Aeropuerto Colonia Catriel', '37 54 36 S, 067 50 06 W', 'Catriel', 'Rio Negro', 30);

INSERT INTO superficies VALUES (1, 'asfalto'), (2, 'concreto'), (3, 'tierra');

-- INSERT INTO pistas VALUES (1, 'EZE', 1, 300, 1), (2, 'EZE', 2, 200, 2), (3, 'AEP', 1, 150, 2), (4, 'MDQ', 1, 200, 2), (5, 'MDQ', 2, 200, 1), (6, 'BRC', 1, 150, 2), (7, 'CCT', 1, 150, 3);
INSERT INTO pistas VALUES ('EZE', 1, 300, 1), ('EZE', 2, 200, 2), ('AEP', 1, 150, 2), ('MDQ', 1, 200, 2), ('MDQ', 2, 200, 1), ('BRC', 1, 150, 2), ('CCT', 1, 150, 3);

INSERT INTO aerolineas VALUES (1, 'LAN'), (2, 'LADE'), (3, 'Aerolineas Argentinas');

INSERT INTO modelos_de_avion VALUES (707, 152000, 44, 141), (767, 186000, 54, 218), (747, 447000, 76, 467);

INSERT INTO programas_de_vuelo (aerolinea, modelo_de_avion, origen, destino, dias) VALUES (1, 707, 'AEP', 'MDQ', 'LUNES,MARTES'), (1, 767, 'MDQ', 'AEP', 'MIERCOLES'), (2, 747, 'EZE', 'MDQ', 'JUEVES,VIERNES'), (2, 747, 'MDQ', 'EZE', 'SABADO'), (3, 767, 'EZE', 'MDQ', 'DOMINGO'), (3, 767, 'MDQ', 'EZE', 'LUNES,MIERCOLES');

INSERT INTO aviones (ano_de_fabricacion, modelo_de_avion, aerolinea) VALUES (1980, 707, 1), (1990, 767, 1), (1995, 747, 2), (2000, 767, 3);

INSERT INTO vuelos (id, fecha, programa_de_vuelo, avion) VALUES (501, '2014-07-01', 1, 1), (502, '2014-07-01', 2, 1),(601, '2015-08-01', 3, 2),(602, '2015-08-02', 4, 2),(301, '2013-09-01', 5, 3),(302, '2013-09-22', 6, 3),(401, '2013-10-01', 5, 3),
(402, '2013-10-22', 6, 3);

INSERT INTO pasajeros VALUES (1, 'DNI', 30111222, 'Fulano Fulanes', 'ARGENTINA', '1950-02-20', 'M'), (2, 'DNI', 20777888, 'Perengano Perenganes', 'ARGENTINA', '1970-04-20', 'M'), (3, 'DNI', 25666999, 'Mengana Menganes', 'ARGENTINA', '1980-03-20', 'F'), (4, 'DNI', 29222111, 'Pirulo Pirules', 'ARGENTINA', '1988-08-20', 'M'), (5, 'DNI', 29222112, 'Pirula Pirules', 'ARGENTINA', '1988-08-20', 'F'), (6, 'DNI', 45666777, 'Kumiko Suzuki', 'JAPON', '1988-08-20', 'F');

INSERT INTO pasajeros_vuelos (pasajero, vuelo) VALUES (1, 501), (1, 502), (2, 401), (2, 402), (3, 401), (3, 402), (6, 501), (6, 502);

INSERT INTO tests VALUES (9000, '2012-12-30', 5, 'AEP', 1);
INSERT INTO tests VALUES (9001, '2012-08-01', 3, 'MDQ', 3);
INSERT INTO tests VALUES (9002, '2013-08-01', 5, 'AEP', 3);
INSERT INTO tests VALUES (9003, '2014-08-20', 7, 'AEP', 3);
INSERT INTO tests VALUES (9004, '2014-09-11', 8, 'AEP', 3);
INSERT INTO tests VALUES (9005, '2014-10-11', 9, 'MDQ', 3);

INSERT INTO pistas_modelos (aeropuerto, pista, modelo_de_avion) VALUES
('AEP', 1, 707),
('AEP', 1, 767),
('EZE', 1, 747),
('EZE', 1, 767),
('MDQ', 1, 707),
('MDQ', 1, 747),
('MDQ', 1, 767);

COMMIT;
