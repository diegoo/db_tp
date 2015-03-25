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
FOREIGN KEY (superficie) REFERENCES superficies(id),
FOREIGN KEY (aeropuerto) REFERENCES aeropuertos(codigo_internacional)
);

CREATE TABLE aerolineas(	
id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100),
PRIMARY KEY (id)
);

CREATE TABLE modelos_avion(	
id INT NOT NULL AUTO_INCREMENT,
peso INT,
largo INT,
capacidad INT,
PRIMARY KEY (id)
);

CREATE TABLE programas_de_vuelo(	
id INT NOT NULL AUTO_INCREMENT,
aerolinea INT,
modelo_avion INT,
origen VARCHAR(3),
destino VARCHAR(3),
PRIMARY KEY (id),
FOREIGN KEY (aerolinea) REFERENCES aerolineas(id),
FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(id),
FOREIGN KEY (origen) REFERENCES aeropuertos(codigo_internacional),
FOREIGN KEY (destino) REFERENCES aeropuertos(codigo_internacional),
CONSTRAINT chk_viaje CHECK (origen != destino)
);

CREATE TABLE aviones(
id INT NOT NULL AUTO_INCREMENT,
ano_de_fabricacion INT,
modelo_avion INT,
PRIMARY KEY (id),
FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(id),
CONSTRAINT chk_fabricacion CHECK (ano_de_fabricacion >= 1970)
);

CREATE TABLE vuelos(
id INT NOT NULL AUTO_INCREMENT,
fecha DATE,
programa_de_vuelo INT,
avion INT,
PRIMARY KEY (id),
FOREIGN KEY (programa_de_vuelo) REFERENCES programas_de_vuelo(id),
FOREIGN KEY (avion) REFERENCES aviones(id)
);

CREATE TABLE pasajeros(
id INT NOT NULL AUTO_INCREMENT,
tipo_documento VARCHAR(10),
nro_documento INT,
nombre VARCHAR(100),
nacionalidad VARCHAR(100),
fecha_nacimiento DATE,
sexo VARCHAR(1),
PRIMARY KEY (id)
);

CREATE TABLE pasajeros_vuelos(
id INT NOT NULL AUTO_INCREMENT,
pasajero INT,
vuelo INT,
PRIMARY KEY (id),
FOREIGN KEY (pasajero) REFERENCES pasajeros(id),
FOREIGN KEY (vuelo) REFERENCES vuelos(id)
);

CREATE TABLE tests(
id INT NOT NULL AUTO_INCREMENT,
fecha DATE,
puntaje INT,
aeropuerto VARCHAR(3),
avion INT,
PRIMARY KEY (id),
FOREIGN KEY (aeropuerto) REFERENCES aeropuertos(codigo_internacional),
FOREIGN KEY (avion) REFERENCES aviones(id),
CONSTRAINT chk_puntaje CHECK (puntaje >= 0 AND puntaje <= 10)
);

-- .............................................................................

INSERT INTO aeropuertos VALUES ('EZE', 'Aeropuerto Internacional Ministro Pistarini', 'Autopista Tte. Gral. Ricchieri Km 33,5, 1802', 'CABA', 'Buenos Aires', 35);
INSERT INTO aeropuertos VALUES ('AEP', 'Aeroparque Jorge Newbery', 'Av Rafael Obligado s/n, 1425', 'CABA', 'Buenos Aires', 2);
INSERT INTO aeropuertos VALUES ('MDQ', 'Aeropuerto Internacional de Mar del Plata Astor Piazzolla', 'Ruta 2 Km. 398,5, 7600', 'Mar del Plata', 'Buenos Aires', 7);
