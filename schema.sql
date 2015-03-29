-- db setup

USE tp;

SET foreign_key_checks = 0;

DROP DATABASE IF EXISTS tp;
CREATE DATABASE tp;
USE tp;

DROP TABLE IF EXISTS aeropuertos;
DROP TABLE IF EXISTS pistas;
DROP TABLE IF EXISTS modelos;
DROP TABLE IF EXISTS modelo_aterriza_en_pistas;
DROP TABLE IF EXISTS programas_de_vuelo;
DROP TABLE IF EXISTS aviones;
DROP TABLE IF EXISTS vuelos;
DROP TABLE IF EXISTS pasajeros;
DROP TABLE IF EXISTS pasajeros_vuelos;
DROP TABLE IF EXISTS tests;
DROP TABLE IF EXISTS controles;

SET foreign_key_checks = 1;

CREATE TABLE aeropuertos(
codigo_internacional VARCHAR(3) NOT NULL,
nombre VARCHAR(100),
direccion VARCHAR(100),
ciudad VARCHAR(100),
provincia VARCHAR(100),
distancia_km FLOAT(4,1),
PRIMARY KEY (codigo_internacional)
);

CREATE TABLE pistas(
id_aeropuerto VARCHAR(3) NOT NULL,
id_pista INT NOT NULL,
largo FLOAT(5,2) NOT NULL,
superficie VARCHAR(100) NOT NULL,
PRIMARY KEY (id_aeropuerto, id_pista),
CONSTRAINT fk_aeropuerto FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE modelos(
id_modelo INT NOT NULL,
peso_toneladas FLOAT(10,2),
largo FLOAT(5,2),
capacidad INT,
PRIMARY KEY (id_modelo)
);

CREATE TABLE modelo_aterriza_en_pistas(
id_aeropuerto VARCHAR(3) NOT NULL,
id_pista INT NOT NULL,
id_modelo INT NOT NULL,
PRIMARY KEY (id_aeropuerto, id_pista, id_modelo),
CONSTRAINT fk_map_aeropuerto_pista FOREIGN KEY (id_aeropuerto, id_pista) REFERENCES pistas(id_aeropuerto, id_pista) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_map_modelo FOREIGN KEY (id_modelo) REFERENCES modelos(id_modelo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE programas_de_vuelo(
id_programa INT NOT NULL AUTO_INCREMENT,
id_aerolinea VARCHAR(100) NOT NULL,
id_modelo INT NOT NULL,
origen VARCHAR(3) NOT NULL,
destino VARCHAR(3) NOT NULL,
dias VARCHAR(100) NOT NULL,
PRIMARY KEY (id_programa),
CONSTRAINT fk_pv_modelo FOREIGN KEY (id_modelo) REFERENCES modelos(id_modelo) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_pv_origen FOREIGN KEY (origen) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_pv_destino FOREIGN KEY (destino) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT chk_viaje CHECK (origen != destino)
);

CREATE TABLE aviones(
id_avion INT NOT NULL,
id_modelo INT NOT NULL,
ano_de_fabricacion INT NOT NULL,
PRIMARY KEY (id_avion, id_modelo),
CONSTRAINT fk_a_modelo FOREIGN KEY (id_modelo) REFERENCES modelos(id_modelo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE vuelos(
id INT NOT NULL AUTO_INCREMENT,
id_programa INT NOT NULL,
id_avion INT NOT NULL,
fecha DATE NOT NULL,
PRIMARY KEY (id_programa, id_avion, fecha),
UNIQUE KEY (id),
CONSTRAINT fk_v_programa FOREIGN KEY (id_programa) REFERENCES programas_de_vuelo(id_programa) ON DELETE CASCADE ON UPDATE CASCADE, 
CONSTRAINT fk_v_avion FOREIGN KEY (id_avion) REFERENCES aviones(id_avion) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pasajeros(
id INT NOT NULL AUTO_INCREMENT,
tipo_documento VARCHAR(10) NOT NULL,
nro_documento INT NOT NULL,
nombre VARCHAR(100) NOT NULL,
nacionalidad VARCHAR(100) NOT NULL,
fecha_nacimiento DATE NOT NULL,
sexo VARCHAR(1) NOT NULL,
PRIMARY KEY (tipo_documento, nro_documento),
UNIQUE KEY (id)
);

CREATE TABLE pasajeros_vuelos(
id_pasajero INT NOT NULL,
id_vuelo INT NOT NULL,
PRIMARY KEY (id_pasajero, id_vuelo),
CONSTRAINT fk_ppvv_pasajero FOREIGN KEY (id_pasajero) REFERENCES pasajeros(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_ppvv_vuelo FOREIGN KEY (id_vuelo) REFERENCES vuelos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tests(
id_test INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(15) NOT NULL,
rango_min INT NOT NULL DEFAULT 0,
rango_max INT NOT NULL DEFAULT 10,
PRIMARY KEY (id_test)
);

CREATE TABLE controles(
id_control INT NOT NULL AUTO_INCREMENT,
id_aeropuerto VARCHAR(3) NOT NULL,
id_test INT NOT NULL,
id_avion INT NOT NULL,
fecha DATE NOT NULL,
puntaje INT NOT NULL,
PRIMARY KEY (id_aeropuerto, id_test, id_avion, fecha),
UNIQUE KEY (id_control),
CONSTRAINT fk_c_aeropuerto FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(codigo_internacional) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_c_avion FOREIGN KEY (id_avion) REFERENCES aviones(id_avion) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_c_test FOREIGN KEY (id_test) REFERENCES tests(id_test) ON DELETE CASCADE ON UPDATE CASCADE
);

-- CONSTRAINT chk_puntaje CHECK (puntaje >= 0 AND puntaje <= 10)
