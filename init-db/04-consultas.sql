-- ============================================================
-- CONSULTAS DEL TRABAJO PRÁCTICO DE BASE DE DATOS
-- Red Social - PostgreSQL
-- ============================================================


-- ============================================================
-- 1) Registrar un usuario
-- ============================================================
INSERT INTO Usuarios (nombre_usuario, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES ('usuario_nuevo', 'nuevo@correo.com', '2000-01-01', 'Nuevo', 'Usuario', 'Argentina');


-- ============================================================
-- 2) Listar todos los usuarios de la red social
-- ============================================================
SELECT *
FROM Usuarios;


-- ============================================================
-- 3) Listar todas las amistades de la red social
-- ============================================================
SELECT *
FROM Amistades;


-- ============================================================
-- 4) Listar los amigos de un usuario particular
-- ============================================================
SELECT *
FROM amistades AS a
WHERE nombre_usuario_1 = 'lauti';


-- ============================================================
-- 5) Listar todos los mensajes de la red social
-- ============================================================
SELECT *
FROM Mensajes
ORDER BY fecha_de_envio DESC;


-- ============================================================
-- 6) Contabilizar la cantidad de usuarios agrupados por país
-- ============================================================
SELECT pais, COUNT(*) AS cantidad_usuarios
FROM Usuarios
GROUP BY pais
ORDER BY cantidad_usuarios DESC;


-- ============================================================
-- 7) Realizar una publicación (1 por cada tipo)
-- Los triggers generan automáticamente la fila en Publicaciones
-- ============================================================

-- TEXTO
INSERT INTO Textos (nombre_usuario, nombre_grupo, texto)
VALUES ('bpezman', NULL, 'Publicación de ejemplo en texto');

-- IMAGEN
INSERT INTO Imagenes (nombre_usuario, nombre_grupo, url_imagen)
VALUES ('mlopez', 'Fotografía', 'http://imagenes.com/ejemplo.jpg');

-- VIDEO
INSERT INTO Videos (nombre_usuario, nombre_grupo, url_video, duracion, calidad)
VALUES ('jperez', NULL, 'http://videos.com/ejemplo.mp4', 5, '720p');


-- ============================================================
-- 8) Actualizar una publicación (un ejemplo por tipo)
-- ============================================================

-- TEXTO
UPDATE Textos
SET texto = 'Texto actualizado'
WHERE id_publicacion = 39;

SELECT * FROM textos;

-- IMAGEN
UPDATE Imagenes
SET url_imagen = 'http://imagenes.com/modificada.jpg'
WHERE id_publicacion = 40;

SELECT * FROM Imagenes;

-- VIDEO
UPDATE Videos
SET duracion = 9,
    calidad = '1080p'
WHERE id_publicacion = 41;


SELECT * FROM Videos;

-- ============================================================
-- 9) Eliminar una publicación (ejemplo por tipo)
-- Los triggers eliminan automáticamente la fila en Publicaciones.
-- ============================================================

-- TEXTO
DELETE FROM Textos
WHERE id_publicacion = 3;

-- IMAGEN
DELETE FROM Imagenes
WHERE id_publicacion = 40;

-- VIDEO
DELETE FROM Videos
WHERE id_publicacion = 41;


-- ============================================================
-- 10) Desregistrar a un usuario
--     ON DELETE CASCADE borra su contenido automáticamente
-- ============================================================
DELETE FROM Usuarios
WHERE nombre_usuario = 'usuario_nuevo';

SELECT * FROM usuarios;
-- ============================================================
-- 11) Mostrar publicaciones más populares
--     Según cantidad de favoritos
-- ============================================================
SELECT
    p.id_publicacion,
    p.nombre_usuario,
    COUNT(f.id_publicacion) AS cantidad_favoritos
FROM Publicaciones p
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY p.id_publicacion, p.nombre_usuario
ORDER BY cantidad_favoritos DESC;


-- ============================================================
-- 12) Mostrar usuarios más populares
--     Según cuántos favoritos reciben sus publicaciones
-- ============================================================
SELECT
    u.nombre_usuario,
    COUNT(f.id_publicacion) AS favoritos_totales
FROM Usuarios u
LEFT JOIN Publicaciones p ON u.nombre_usuario = p.nombre_usuario
LEFT JOIN Favoritos f     ON p.id_publicacion = f.id_publicacion
GROUP BY u.nombre_usuario
ORDER BY favoritos_totales DESC;



