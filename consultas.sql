-- consultas

USE tp;

-- a. Dar los nombres de los aeropuertos por los cuales hayan pasado pasajeros de nacionalidad japonesa y de sexo femenino.

SELECT a.nombre, a.codigo_internacional FROM pasajeros p
       JOIN pasajeros_vuelos pv ON p.id = pv.id_pasajero
       JOIN vuelos v ON pv.id_vuelo = v.id
       JOIN programas_de_vuelo pdv ON v.id_programa = pdv.id_programa
       JOIN aeropuertos a ON pdv.origen = a.codigo_internacional
       WHERE p.nacionalidad = 'JAPON' AND p.sexo = 'F'
UNION
SELECT a.nombre, a.codigo_internacional FROM pasajeros p
       JOIN pasajeros_vuelos pv ON p.id = pv.id_pasajero
       JOIN vuelos v ON pv.id_vuelo = v.id
       JOIN programas_de_vuelo pdv ON v.id_programa = pdv.id_programa
       JOIN aeropuertos a ON pdv.destino = a.codigo_internacional
       WHERE p.nacionalidad = 'JAPON' AND p.sexo = 'F';


-- b. ¿A cuántos kilómetros de su casco urbano se encuentran los aeropuertos por los cuales despegaron vuelos sin plazas vacías (completos) y que pertenecen a programas de vuelo de la aerolínea "Aerolineas Argentinas"?

SELECT COUNT(*) AS total_pasajeros, pavu.id_vuelo, m.capacidad, a.id_modelo, ap.distancia_km, ap.nombre, pv.id_aerolinea
       FROM pasajeros_vuelos pavu
       JOIN vuelos v ON pavu.id_vuelo = v.id
       JOIN programas_de_vuelo pv ON pv.id_programa = v.id_programa 
       JOIN aviones a ON v.id_avion = a.id_avion
       JOIN modelos m ON m.id_modelo = a.id_modelo
       JOIN aeropuertos ap ON ap.codigo_internacional = pv.origen
       WHERE pv.id_aerolinea = 'Aerolineas Argentinas'
       GROUP BY pavu.id_vuelo
       HAVING total_pasajeros = m.capacidad;

-- c. Determinar la cantidad de pistas que existen por provincia.

SELECT COUNT(1) AS nro_pistas, a.provincia
       FROM pistas p
       JOIN aeropuertos a ON p.id_aeropuerto = a.codigo_internacional
       GROUP BY a.provincia;


-- d. Determinar la cantidad de controles que se le hayan efectuado a los aviones modelo Boeing 747 durante el 2013-2014, para aquellos aviones que hayan obtenido un puntaje promedio mayor a 7.

SELECt a.id_avion, COUNT(1) AS cantidad_controles, t.nombre AS nombre_del_test, AVG(c.puntaje) AS puntaje_promedio FROM controles c
       JOIN aviones a ON c.id_avion = a.id_avion
       JOIN modelos m ON a.id_modelo = m.id_modelo
       JOIN tests t ON t.id_test = c.id_test
       WHERE a.id_modelo = 747 AND c.fecha BETWEEN '2013-01-01' AND '2014-12-31'
       GROUP BY a.id_avion, t.id_test
       HAVING AVG(c.puntaje) > 7;


-- e. Determinar cuáles fueron los aeropuertos que hayan obtenido el peor puntaje entre los controles que se realizaron durante el año 2014 a los aviones modelo Boeing 747

SELECT MIN(c.puntaje) as peor_puntaje, c.id_aeropuerto AS aeropuerto FROM controles c
       JOIN aviones a ON c.id_avion = a.id_avion
       JOIN modelos m ON a.id_modelo = m.id_modelo
       WHERE a.id_modelo = 747 AND c.fecha BETWEEN '2014-01-01' AND '2014-12-31'
       GROUP BY c.id_aeropuerto
       HAVING MIN(c.puntaje) = (SELECT MIN(puntajes.peores) FROM
                                (SELECT MIN(c.puntaje) AS peores FROM controles c
                                        JOIN aviones a ON c.id_avion = a.id_avion
                                        JOIN modelos m ON a.id_modelo = m.id_modelo
                                        WHERE a.id_modelo = 747 AND c.fecha BETWEEN '2014-01-01' AND '2014-12-31'
                                        GROUP BY c.id_aeropuerto) puntajes);


-- f. 3 consultas:


-- f.i. encontrar a los pasajeros que hayan hecho vuelos inter-provinciales (para ofrecerles descuento por viajeros frecuentes).

SELECT p.nombre, pavu.id_vuelo, a_origen.provincia AS provincia_origen, a_destino.provincia AS provincia_destino
       FROM pasajeros_vuelos pavu
       JOIN pasajeros p ON p.id = pavu.id_pasajero
       JOIN vuelos v ON pavu.id_vuelo = v.id
       JOIN programas_de_vuelo pv ON pv.id_programa = v.id_programa
       JOIN aeropuertos a_origen ON a_origen.codigo_internacional = pv.origen
       JOIN aeropuertos a_destino ON a_destino.codigo_internacional = pv.destino
       WHERE a_origen.provincia != a_destino.provincia
       GROUP BY pavu.id_pasajero;


-- f.ii. armar un ranking de los modelos de avión más usados en vuelos realizados durante el año pasado.

SELECT COUNT(*) AS cant_vuelos, a.id_modelo AS avion
       FROM vuelos v 
       JOIN aviones a ON v.id_avion = a.id_avion
       JOIN modelos m ON m.id_modelo = a.id_modelo
       GROUP BY a.id_avion
       ORDER BY cant_vuelos DESC;
       

-- f.iii. listar los vuelos en los que haya viajado viajó el (o la) más joven de los viajeros más frecuentes.

SELECT pv.id_vuelo AS vuelo, p.nombre AS viajero
       FROM pasajeros_vuelos pv
       JOIN pasajeros p ON p.id = pv.id_pasajero
       WHERE pv.id_pasajero =
       	  (SELECT viajeros.id FROM
             (SELECT COUNT(*) AS cant_vuelos, p.fecha_nacimiento, p.id
                     FROM pasajeros_vuelos pv
                     JOIN pasajeros p ON pv.id_pasajero = p.id
                     GROUP BY p.id
                     HAVING cant_vuelos =
		           (SELECT MAX(cant_vuelos) FROM
                                   (SELECT COUNT(*) AS cant_vuelos
                                                    FROM pasajeros_vuelos pv
						    JOIN pasajeros p ON pv.id_pasajero = p.id
						    GROUP BY p.id
						    ORDER BY cant_vuelos DESC) cantidades)
                     ORDER BY p.fecha_nacimiento DESC LIMIT 1) viajeros);


-- f.iv. bonus track: averiguar en qué vuelos volaron juntos (si es que lo hicieron) el más joven de los viajeros más frecuentes y la más joven de las viajeras más frecuentes.

-- SELECT pv.id_vuelo
--        FROM pasajeros_vuelos pv
--        WHERE pv.id_pasajero = (SELECT viajeros.id FROM
--              (SELECT COUNT(*) AS cant_vuelos, p.fecha_nacimiento, p.id
--                      FROM pasajeros_vuelos pv
--                      JOIN pasajeros p ON pv.id_pasajero = p.id
--                      WHERE p.sexo = 'M'
--                      GROUP BY p.id
--                      HAVING cant_vuelos = (SELECT MAX(cant_vuelos) FROM
--                                                   (SELECT COUNT(*) AS cant_vuelos
--                                                           FROM pasajeros_vuelos pv
--                                                           JOIN pasajeros p ON pv.id_pasajero = p.id
--                                                           WHERE p.sexo = 'M'
--                                                           GROUP BY p.id
--                                                           ORDER BY cant_vuelos DESC) cantidades)
--                      ORDER BY p.fecha_nacimiento DESC LIMIT 1) viajeros)
--        AND pv.id_vuelo IN (SELECT pv.id_vuelo FROM pasajeros_vuelos pv
-- 				  WHERE pv.id_pasajero = (SELECT viajeras.id FROM
-- 							      (SELECT COUNT(*) AS cant_vuelos, p.fecha_nacimiento, p.id
-- 								      FROM pasajeros_vuelos pv
-- 								      JOIN pasajeros p ON pv.id_pasajero = p.id
-- 								      WHERE p.sexo = 'F'
-- 								      GROUP BY p.id
-- 								      HAVING cant_vuelos = (SELECT MAX(cant_vuelos) FROM (SELECT COUNT(*) AS cant_vuelos
-- 												   FROM pasajeros_vuelos pv
-- 												   JOIN pasajeros p ON pv.id_pasajero = p.id
-- 												   WHERE p.sexo = 'F'
-- 												   GROUP BY p.id
-- 												   ORDER BY cant_vuelos DESC) cantidades)
-- 								      ORDER BY p.fecha_nacimiento DESC LIMIT 1) viajeras));
