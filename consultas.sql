-- consultas

USE tp;

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


-- b. ¿A cuántos kilómetros de su casco urbano se encuentran los aeropuertos por los cuales despegaron vuelos sin plazas vacías (completos) y que pertenecen a programas de vuelo de la aerolínea "Aerolineas Argentinas"?

SELECT COUNT(*) AS total_pasajeros, pavu.vuelo, ma.capacidad, a.modelo_de_avion, ap.distancia_casco_urbano, ap.nombre
       FROM pasajeros_vuelos pavu
       JOIN vuelos v ON pavu.vuelo = v.id
       JOIN programas_de_vuelo pv ON pv.id = v.programa_de_vuelo
       JOIN aviones a ON v.avion = a.id
       JOIN modelos_de_avion ma ON ma.id = a.modelo_de_avion
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
       JOIN modelos_de_avion ma ON a.modelo_de_avion = ma.id
       WHERE a.modelo_de_avion = 747 AND t.fecha BETWEEN '2013-01-01' AND '2014-12-31'
       GROUP BY a.id
       HAVING AVG(t.puntaje) >= 7;


-- e. Determinar cuáles fueron los aeropuertos que hayan obtenido el peor puntaje entre los controles que se realizaron durante el año 2014 a los aviones modelo Boeing 747

SELECt MIN(mpa.peor_puntaje) AS peor_puntaje, mpa.aeropuerto FROM
       (SELECt MIN(t.puntaje) AS peor_puntaje, t.aeropuerto AS aeropuerto FROM tests t
	      JOIN aviones a ON t.avion = a.id
	      JOIN modelos_de_avion ma ON a.modelo_de_avion = ma.id
	      WHERE a.modelo_de_avion = 747 AND t.fecha BETWEEN '2014-01-01' AND '2014-12-31'
	      GROUP BY t.aeropuerto) mpa;
