USE tp;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS aeropuertos;
DROP TABLE IF EXISTS superficies;
DROP TABLE IF EXISTS pistas;
DROP TABLE IF EXISTS aerolineas;
DROP TABLE IF EXISTS modelos_avion;
DROP TABLE IF EXISTS programas_de_vuelo;
DROP TABLE IF EXISTS aviones;
DROP TABLE IF EXISTS vuelos;
DROP TABLE IF EXISTS pasajeros;
DROP TABLE IF EXISTS pasajeros_vuelos;
DROP TABLE IF EXISTS tests;

SET foreign_key_checks = 1;

CREATE TABLE aeropuertos(	
codigo_internacional VARCHAR(3) NOT NULL,
nombre VARCHAR(100),
direccion VARCHAR(100),
ciudad VARCHAR(100),
provincia VARCHAR(100),
distancia_casco_urbano INT,
PRIMARY KEY (codigo_internacional)
);

CREATE TABLE superficies(	
id INT NOT NULL AUTO_INCREMENT,
tipo VARCHAR(100),
PRIMARY KEY (id)
);

CREATE TABLE pistas(	
id INT NOT NULL AUTO_INCREMENT,
aeropuerto VARCHAR(3),
largo INT,
superficie INT,
PRIMARY KEY (id),
FOREIGN KEY (superficie) REFERENCES superficies(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (aeropuerto) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE aerolineas(	
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100),
PRIMARY KEY (id)
);

CREATE TABLE modelos_avion(	
id INT NOT NULL,
peso INT,
largo INT,
capacidad INT,
PRIMARY KEY (id)
);

CREATE TABLE programas_de_vuelo(	
id INT NOT NULL AUTO_INCREMENT,
aerolinea INT NOT NULL,
modelo_avion INT NOT NULL,
origen VARCHAR(3) NOT NULL,
destino VARCHAR(3) NOT NULL,
dias SET('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO') NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (aerolinea) REFERENCES aerolineas(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (origen) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (destino) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_viaje CHECK (origen != destino)
);

CREATE TABLE aviones(
id INT NOT NULL AUTO_INCREMENT,
ano_de_fabricacion INT,
modelo_avion INT NOT NULL,
aerolinea INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(id),
FOREIGN KEY (aerolinea) REFERENCES aerolineas(id),
CONSTRAINT chk_fabricacion CHECK (ano_de_fabricacion >= 1970)
);

CREATE TABLE vuelos(
id INT NOT NULL AUTO_INCREMENT,
fecha DATE,
programa_de_vuelo INT NOT NULL,
avion INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (programa_de_vuelo) REFERENCES programas_de_vuelo(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (avion) REFERENCES aviones(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pasajeros(
id INT NOT NULL AUTO_INCREMENT,
tipo_documento VARCHAR(10),
nro_documento INT,
nombre VARCHAR(100),
nacionalidad VARCHAR(100),
fecha_nacimiento DATE,
sexo VARCHAR(1),
PRIMARY KEY (id),
UNIQUE KEY (tipo_documento, nro_documento)
);

CREATE TABLE pasajeros_vuelos(
id INT NOT NULL AUTO_INCREMENT,
pasajero INT NOT NULL,
vuelo INT NOT NULL,
PRIMARY KEY (id),
UNIQUE KEY (pasajero, vuelo),
FOREIGN KEY (pasajero) REFERENCES pasajeros(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (vuelo) REFERENCES vuelos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tests(
id INT NOT NULL AUTO_INCREMENT,
fecha DATE,
puntaje INT,
aeropuerto VARCHAR(3) NOT NULL,
avion INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (aeropuerto) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (avion) REFERENCES aviones(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_puntaje CHECK (puntaje >= 0 AND puntaje <= 10)
);

COMMIT;

-- datos

INSERT INTO aeropuertos VALUES ('EZE', 'Aeropuerto Internacional Ministro Pistarini', 'Autopista Tte. Gral. Ricchieri Km 33,5, 1802', 'CABA', 'Buenos Aires', 35), ('AEP', 'Aeroparque Jorge Newbery', 'Av Rafael Obligado s/n, 1425', 'CABA', 'Buenos Aires', 2), ('MDQ', 'Aeropuerto Internacional de Mar del Plata Astor Piazzolla', 'Ruta 2 Km. 398,5, 7600', 'Mar del Plata', 'Buenos Aires', 7), ('BRC', 'Aeropuerto de San Carlos de Bariloche Teniente Luis Candelaria', 'Ruta Provincial Nº 80 S/Nº - (8400)', 'Bariloche', 'Rio Negro', 14), ('CCT', 'Aeropuerto Colonia Catriel', '37 54 36 S, 067 50 06 W', 'Catriel', 'Rio Negro', 30);

INSERT INTO superficies VALUES (1, 'asfalto'), (2, 'concreto'), (3, 'tierra');

INSERT INTO pistas VALUES (1, 'EZE', 300, 1), (2, 'EZE', 200, 2), (3, 'AEP', 150, 2), (4, 'MDQ', 200, 2), (5, 'MDQ', 200, 1), (6, 'BRC', 150, 2), (7, 'CCT', 150, 3);

INSERT INTO aerolineas VALUES (1, 'LAN'), (2, 'LADE'), (3, 'Aerolineas Argentinas');

INSERT INTO modelos_avion VALUES (707, 152000, 44, 141), (767, 186000, 54, 218), (747, 447000, 76, 467);

INSERT INTO programas_de_vuelo VALUES (1, 1, 707, 'AEP', 'MDQ', 'LUNES,MARTES'), (2, 1, 767, 'MDQ', 'AEP', 'MIERCOLES'), (3, 2, 747, 'EZE', 'MDQ', 'JUEVES,VIERNES'), (4, 2, 747, 'MDQ', 'EZE', 'SABADO'), (5, 3, 767, 'EZE', 'MDQ', 'DOMINGO'), (6, 3, 767, 'MDQ', 'EZE', 'LUNES,MIERCOLES');

INSERT INTO aviones VALUES (1, 1980, 707, 1), (2, 1990, 767, 1), (3, 1995, 747, 2), (4, 2000, 767, 3);

INSERT INTO vuelos VALUES (501, '2014-07-01', 1, 1), (502, '2014-07-01', 2, 1),(601, '2015-08-01', 3, 2),(602, '2015-08-02', 4, 2),(301, '2013-09-01', 5, 3),(302, '2013-09-22', 6, 3),(401, '2013-10-01', 5, 3),
(402, '2013-10-22', 6, 3);

INSERT INTO pasajeros VALUES (1, 'DNI', 30111222, 'Fulano Fulanes', 'ARGENTINA', '1950-02-20', 'M'), (2, 'DNI', 20777888, 'Perengano Perenganes', 'ARGENTINA', '1970-04-20', 'M'), (3, 'DNI', 25666999, 'Mengana Menganes', 'ARGENTINA', '1980-03-20', 'F'), (4, 'DNI', 29222111, 'Pirulo Pirules', 'ARGENTINA', '1988-08-20', 'M'), (5, 'DNI', 29222112, 'Pirula Pirules', 'ARGENTINA', '1988-08-20', 'F'), (6, 'DNI', 45666777, 'Kumiko Suzuki', 'JAPON', '1988-08-20', 'F');

INSERT INTO pasajeros_vuelos (pasajero, vuelo) VALUES (1, 501), (1, 502), (2, 401), (2, 402), (3, 401), (3, 402), (6, 501), (6, 502);

INSERT INTO tests VALUES (9000, '2012-12-30', 5, 'AEP', 1);
INSERT INTO tests VALUES (9001, '2012-08-01', 3, 'MDQ', 3);
INSERT INTO tests VALUES (9002, '2013-08-01', 5, 'AEP', 3);
INSERT INTO tests VALUES (9003, '2014-08-20', 7, 'AEP', 3);
INSERT INTO tests VALUES (9004, '2014-09-11', 8, 'AEP', 3);
INSERT INTO tests VALUES (9005, '2014-10-11', 9, 'MDQ', 3);

COMMIT;


-- consultas


-- a. Dar los nombres de los aeropuertos por los cuales hayan pasado pasajeros de nacionalidad japonesa y de sexo femenino.

SELECT a.nombre, a.codigo_internacional FROM pasajeros p 
       JOIN pasajeros_vuelos pv ON p.id = pv.pasajero
       JOIN vuelos v ON pv.vuelo = v.id
       JOIN programas_de_vuelo pdv ON v.programa_de_vuelo = pdv.id
       JOIN aeropuertos a ON pdv.origen = a.codigo_internacional
       WHERE p.nacionalidad = 'JAPON' AND p.sexo = 'F'
UNION
SELECT a.nombre, a.codigo_internacional FROM pasajeros p 
       JOIN pasajeros_vuelos pv ON p.id = pv.pasajero
       JOIN vuelos v ON pv.vuelo = v.id
       JOIN programas_de_vuelo pdv ON v.programa_de_vuelo = pdv.id
       JOIN aeropuertos a ON pdv.destino = a.codigo_internacional
       WHERE p.nacionalidad = 'JAPON' AND p.sexo = 'F';


-- b. ¿A cuántos kilómetros de su casco urbano se encuentran los aeropuertos por los cuales despegaron vuelos sin plazas vacías (completos) y que pertenecen a programas de vuelo de la aerolínea "AA"?

SELECT COUNT(*) AS total_pasajeros, pavu.vuelo, ma.capacidad, a.modelo_avion, ap.distancia_casco_urbano, ap.nombre
       FROM pasajeros_vuelos pavu
       JOIN vuelos v ON pavu.vuelo = v.id
       JOIN programas_de_vuelo pv ON pv.id = v.programa_de_vuelo
       JOIN aviones a ON v.avion = a.id
       JOIN modelos_avion ma ON ma.id = a.modelo_avion
       JOIN aeropuertos ap ON ap.codigo_internacional = pv.origen
       JOIN aerolineas ae ON pv.aerolinea = ae.id
       WHERE ae.nombre = 'Aerolineas Argentinas'
       GROUP BY pavu.vuelo;
       -- HAVING total_pasajeros = ma.capacidad;

-- c. Determinar la cantidad de pistas que existen por provincia.

SELECT COUNT(1) AS nro_pistas, a.provincia FROM pistas p JOIN aeropuertos a ON p.aeropuerto = a.codigo_internacional GROUP BY a.provincia;


-- d. Determinar la cantidad de controles que se le hayan efectuado a los aviones modelo Boeing 747 durante el 2013-2014, para aquellos aviones que hayan obtenido un puntaje promedio mayor a 7.

SELECt COUNT(1) AS cantidad_controles, AVG(t.puntaje) AS puntaje_promedio FROM tests t 
       JOIN aviones a ON t.avion = a.id 
       JOIN modelos_avion ma ON a.modelo_avion = ma.id
       WHERE a.modelo_avion = 747 AND t.fecha BETWEEN '2013-01-01' AND '2014-12-31'
       GROUP BY a.id
       HAVING AVG(t.puntaje) >= 7;


-- e. Determinar cuáles fueron los aeropuertos que hayan obtenido el peor puntaje entre los controles que se realizaron durante el año 2014 a los aviones modelo Boeing 747

SELECt MIN(mpa.peor_puntaje) AS peor_puntaje, mpa.aeropuerto FROM 
       (SELECt MIN(t.puntaje) AS peor_puntaje, t.aeropuerto AS aeropuerto FROM tests t 
       	      JOIN aviones a ON t.avion = a.id 
       	      JOIN modelos_avion ma ON a.modelo_avion = ma.id
       	      WHERE a.modelo_avion = 747 AND t.fecha BETWEEN '2014-01-01' AND '2014-12-31'
       	      GROUP BY t.aeropuerto) mpa;
