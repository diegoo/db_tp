-- db setup

USE tp;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS aeropuertos;
DROP TABLE IF EXISTS superficies;
DROP TABLE IF EXISTS pistas;
DROP TABLE IF EXISTS aerolineas;
DROP TABLE IF EXISTS modelos_de_avion;
DROP TABLE IF EXISTS programas_de_vuelo;
DROP TABLE IF EXISTS aviones;
DROP TABLE IF EXISTS vuelos;
DROP TABLE IF EXISTS pasajeros;
DROP TABLE IF EXISTS pasajeros_vuelos;
DROP TABLE IF EXISTS tests;
DROP TABLE IF EXISTS pistas_modelos;

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
aeropuerto VARCHAR(3) NOT NULL,
id INT NOT NULL,
largo INT NOT NULL,
superficie INT NOT NULL,
PRIMARY KEY (aeropuerto, id),
FOREIGN KEY (superficie) REFERENCES superficies(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (aeropuerto) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE aerolineas(
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100),
PRIMARY KEY (id)
);

CREATE TABLE modelos_de_avion(
id INT NOT NULL,
peso INT,
largo INT,
capacidad INT,
PRIMARY KEY (id)
);

CREATE TABLE programas_de_vuelo(
id INT NOT NULL AUTO_INCREMENT,
aerolinea INT NOT NULL,
modelo_de_avion INT NOT NULL,
origen VARCHAR(3) NOT NULL,
destino VARCHAR(3) NOT NULL,
dias SET('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO') NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (aerolinea) REFERENCES aerolineas(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (modelo_de_avion) REFERENCES modelos_de_avion(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (origen) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (destino) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_viaje CHECK (origen != destino)
);

CREATE TABLE aviones(
id INT NOT NULL AUTO_INCREMENT,
ano_de_fabricacion INT,
modelo_de_avion INT NOT NULL,
aerolinea INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (modelo_de_avion) REFERENCES modelos_de_avion(id),
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
);

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

CREATE TABLE pistas_modelos(
aeropuerto VARCHAR(3) NOT NULL,
pista INT NOT NULL,
modelo_de_avion INT NOT NULL,
PRIMARY KEY (aeropuerto, pista, modelo_de_avion),
FOREIGN KEY (aeropuerto, pista) REFERENCES pistas(aeropuerto, id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (modelo_de_avion) REFERENCES modelos_de_avion(id) ON DELETE CASCADE ON UPDATE CASCADE
);
