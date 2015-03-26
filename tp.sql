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

-- ALTER TABLE pasajeros ADD UNIQUE INDEX(ItemName, ItemSize);

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

INSERT INTO aeropuertos VALUES ('EZE', 'Aeropuerto Internacional Ministro Pistarini', 'Autopista Tte. Gral. Ricchieri Km 33,5, 1802', 'CABA', 'Buenos Aires', 35), ('AEP', 'Aeroparque Jorge Newbery', 'Av Rafael Obligado s/n, 1425', 'CABA', 'Buenos Aires', 2), ('MDQ', 'Aeropuerto Internacional de Mar del Plata Astor Piazzolla', 'Ruta 2 Km. 398,5, 7600', 'Mar del Plata', 'Buenos Aires', 7);

INSERT INTO superficies VALUES (1, 'asfalto'), (2, 'concreto'), (3, 'tierra');

INSERT INTO pistas VALUES (1, 'EZE', 300, 1), (2, 'EZE', 200, 2), (3, 'AEP', 150, 2), (4, 'MDQ', 200, 2), (5, 'MDQ', 200, 1);

INSERT INTO aerolineas VALUES (1, 'LAN'), (2, 'LADE'), (3, 'Aerolineas Argentinas');

INSERT INTO modelos_avion VALUES (707, 152000, 44, 141), (767, 186000, 54, 218), (747, 447000, 76, 467);

INSERT INTO programas_de_vuelo VALUES (1, 1, 707, 'AEP', 'MDQ'), (2, 1, 767, 'MDQ', 'AEP'),(3, 2, 747, 'EZE', 'MDQ'),(4, 2, 747, 'MDQ', 'EZE'),(5, 3, 767, 'EZE', 'MDQ'),(6, 3, 767, 'MDQ', 'EZE');

INSERT INTO aviones VALUES (1, 1980, 707, 1), (2, 1990, 767, 1), (3, 1995, 747, 2), (4, 2000, 767, 3);

INSERT INTO vuelos VALUES (501, '2014-07-01', 1, 1), (502, '2014-07-01', 2, 1),(601, '2015-08-01', 3, 2),(602, '2015-08-02', 4, 2),(301, '2013-09-01', 5, 3),(302, '2013-09-22', 6, 3),(401, '2013-10-01', 5, 3),
(402, '2013-10-22', 6, 3);

INSERT INTO pasajeros VALUES (1, 'DNI', 30111222, 'Fulano Fulanes', 'argentino', '1950-02-20', 'M'), (2, 'DNI', 20777888, 'Perengano Perenganes', 'argentino', '1970-04-20', 'M'), (3, 'DNI', 25666999, 'Mengana Menganes', 'argentina', '1980-03-20', 'F'), (4, 'DNI', 29222111, 'Pirulo Pirules', 'argentino', '1988-08-20', 'M'), (5, 'DNI', 29222112, 'Pirula Pirules', 'argentina', '1988-08-20', 'F');

INSERT INTO pasajeros_vuelos (pasajero, vuelo) VALUES (1, 501), (1, 502), (2, 401), (2, 402), (3, 401), (3, 402);

COMMIT;
