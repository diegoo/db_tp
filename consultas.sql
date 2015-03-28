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
       GROUP BY pavu.vuelo
       HAVING total_pasajeros = ma.capacidad;

-- c. Determinar la cantidad de pistas que existen por provincia.

SELECT COUNT(1) AS nro_pistas, a.provincia FROM pistas p JOIN aeropuertos a ON p.aeropuerto = a.codigo_internacional GROUP BY a.provincia;


-- d. Determinar la cantidad de controles que se le hayan efectuado a los aviones modelo Boeing 747 durante el 2013-2014, para aquellos aviones que hayan obtenido un puntaje promedio mayor a 7.

SELECt a.id as avion_id, COUNT(1) AS cantidad_controles, AVG(t.puntaje) AS puntaje_promedio FROM tests t
       JOIN aviones a ON t.avion = a.id
       JOIN modelos_de_avion ma ON a.modelo_de_avion = ma.id
       WHERE a.modelo_de_avion = 747 AND t.fecha BETWEEN '2013-01-01' AND '2014-12-31'
       GROUP BY a.id
       HAVING AVG(t.puntaje) > 7;


-- e. Determinar cuáles fueron los aeropuertos que hayan obtenido el peor puntaje entre los controles que se realizaron durante el año 2014 a los aviones modelo Boeing 747

SELECT MIN(t.puntaje) as peor_puntaje, t.aeropuerto AS aeropuerto FROM tests t
       JOIN aviones a ON t.avion = a.id
       JOIN modelos_de_avion ma ON a.modelo_de_avion = ma.id
       WHERE a.modelo_de_avion = 747 AND t.fecha BETWEEN '2014-01-01' AND '2014-12-31'
       GROUP BY t.aeropuerto
       HAVING MIN(t.puntaje) = (SELECT MIN(puntajes.peores) FROM 
       	      		       	       (SELECT MIN(t.puntaje) AS peores FROM tests t 
				       	       JOIN aviones a ON t.avion = a.id
					       JOIN modelos_de_avion ma ON a.modelo_de_avion = ma.id
					       WHERE a.modelo_de_avion = 747 AND t.fecha BETWEEN '2014-01-01' AND '2014-12-31'
					       GROUP BY t.aeropuerto) puntajes);

-- f. 3 consultas:


-- f.i. encontrar a los pasajeros que hayan hecho vuelos inter-provinciales (para ofrecerles descuento por viajeros frecuentes).

SELECT p.nombre, pavu.vuelo, a_origen.provincia AS provincia_origen, a_destino.provincia AS provincia_destino
       FROM pasajeros_vuelos pavu
       JOIN pasajeros p ON p.id = pavu.pasajero
       JOIN vuelos v ON pavu.vuelo = v.id
       JOIN programas_de_vuelo pv ON pv.id = v.programa_de_vuelo
       JOIN aeropuertos a_origen ON a_origen.codigo_internacional = pv.origen
       JOIN aeropuertos a_destino ON a_destino.codigo_internacional = pv.destino
       WHERE a_origen.provincia != a_destino.provincia
       GROUP BY pavu.pasajero;

-- f.ii. armar un ranking de los modelos de avión más usados durante el año pasado, con el nombre de la aerolínea a la que pertenecen.

SELECT COUNT(*) AS cant_vuelos, av.modelo_de_avion AS avion, a.nombre AS aerolinea
       FROM vuelos v 
       JOIN aviones av ON v.avion = av.id
       JOIN modelos_de_avion ma ON ma.id = av.modelo_de_avion
       JOIN aerolineas a ON av.aerolinea = a.id
       GROUP BY av.id
       ORDER BY cant_vuelos DESC;
       

-- f.iii. averiguar en qué vuelos volaron juntos (si es que lo hicieron) el más joven de los viajeros más frecuentes y la más joven de las viajeras más frecuentes.

SELECT pv.vuelo FROM pasajeros_vuelos pv WHERE pv.pasajero = (SELECT viajeros.id FROM (SELECT COUNT(*) AS cant_vuelos, p.fecha_nacimiento, p.id FROM pasajeros_vuelos pv JOIN pasajeros p ON pv.pasajero = p.id WHERE p.sexo = 'M' GROUP BY p.id HAVING cant_vuelos = (SELECT MAX(cant_vuelos) FROM (SELECT COUNT(*) AS cant_vuelos FROM pasajeros_vuelos pv JOIN pasajeros p ON pv.pasajero = p.id WHERE p.sexo = 'M' GROUP BY p.id ORDER BY cant_vuelos DESC) cantidades) ORDER BY p.fecha_nacimiento DESC LIMIT 1) viajeros) AND pv.vuelo IN (SELECT pv.vuelo from pasajeros_vuelos pv where pv.pasajero = (SELECT viajeras.id FROM (SELECT COUNT(*) AS cant_vuelos, p.fecha_nacimiento, p.id FROM pasajeros_vuelos pv JOIN pasajeros p ON pv.pasajero = p.id WHERE p.sexo = 'F' GROUP BY p.id HAVING cant_vuelos = (SELECT MAX(cant_vuelos) FROM (SELECT COUNT(*) AS cant_vuelos FROM pasajeros_vuelos pv JOIN pasajeros p ON pv.pasajero = p.id WHERE p.sexo = 'F' GROUP BY p.id ORDER BY cant_vuelos DESC) cantidades) ORDER BY p.fecha_nacimiento DESC LIMIT 1) viajeras));
