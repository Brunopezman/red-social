
-- ============================================================
-- CONSULTAS
-- ============================================================


---------------------------------------------------------------
-- Registrar un usuario
---------------------------------------------------------------
INSERT INTO Usuarios (nombre_usuario, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES ('vcecen', 'valentinoceniceros@gmail.com', '2001-11-11', 'Valentino', 'Ceniceros', 'Argentina');


---------------------------------------------------------------
-- Listar todos los usuarios
---------------------------------------------------------------
SELECT nombre_usuario, nombre, apellido, pais
FROM Usuarios;


---------------------------------------------------------------
-- Listar todas las amistades aceptadas
---------------------------------------------------------------
SELECT
    a.nombre_usuario_1,
    u.nombre AS nombre_1,
    u.apellido AS apellido_1,
    a.nombre_usuario_2,
    u2.nombre AS nombre_2,
    u2.apellido AS apellido_2
FROM Amistades a
JOIN Usuarios u  ON a.nombre_usuario_1 = u.nombre_usuario
JOIN Usuarios u2 ON a.nombre_usuario_2 = u2.nombre_usuario
WHERE a.estado = 'aceptada';

---------------------------------------------------------------
-- Listar amigos de un usuario en particular
---------------------------------------------------------------
SELECT
    u.nombre_usuario,
    u.nombre,
    u.apellido,
    u.pais
FROM Usuarios u
WHERE u.nombre_usuario IN (
    SELECT CASE
               WHEN a.nombre_usuario_1 = 'bpezman' THEN a.nombre_usuario_2
               ELSE a.nombre_usuario_1
           END
    FROM Amistades a
    WHERE 'bpezman' IN (a.nombre_usuario_1, a.nombre_usuario_2)
      AND a.estado = 'aceptada'
);

---------------------------------------------------------------
-- Listar todos los mensajes
---------------------------------------------------------------
SELECT * FROM Mensajes;

---------------------------------------------------------------
-- Cantidad de usuarios agrupados por país
---------------------------------------------------------------
SELECT 
    pais,
    COUNT(*) AS cantidad_usuarios
FROM Usuarios
GROUP BY pais
ORDER BY cantidad_usuarios DESC;


---------------------------------------------------------------
-- Ejemplos de publicación
---------------------------------------------------------------
INSERT INTO Textos (id_publicacion, nombre_usuario, texto)
VALUES (20, 'bpezman', '¡Hola a todos! Primera publicación.');

INSERT INTO Imagenes (id_publicacion, nombre_usuario, url_imagen)
VALUES (21, 'mlopez', 'http://imagenes.com/ejemplo.jpg');

INSERT INTO Videos (id_publicacion, nombre_usuario, url_video, duracion, calidad)
VALUES (22, 'jperez', 'http://videos.com/video.mp4', 5, '720p');


---------------------------------------------------------------
-- Actualizar publicaciones
---------------------------------------------------------------
UPDATE Textos
SET texto = 'Texto actualizado.'
WHERE id_publicacion = 20;

UPDATE Imagenes
SET url_imagen = 'http://imagenes.com/actualizada.jpg'
WHERE id_publicacion = 21;

UPDATE Videos
SET url_video = 'http://videos.com/video_nuevo.mp4',
    duracion = 6,
    calidad = '1080p'
WHERE id_publicacion = 22;


---------------------------------------------------------------
-- Eliminar publicaciones
---------------------------------------------------------------
DELETE FROM Textos   WHERE id_publicacion = 20;
DELETE FROM Imagenes WHERE id_publicacion = 21;
DELETE FROM Videos   WHERE id_publicacion = 22;


---------------------------------------------------------------
-- Desregistrar a un usuario de la aplicación
---------------------------------------------------------------
DELETE FROM Usuarios WHERE nombre_usuario = 'mlopez';


---------------------------------------------------------------
-- Publicaciones más populares
---------------------------------------------------------------
SELECT
    p.id_publicacion,
    COUNT(f.id_publicacion) AS cantidad_favoritos,
    p.nombre_usuario
FROM Publicaciones p
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY p.id_publicacion, p.nombre_usuario
ORDER BY cantidad_favoritos DESC;

---------------------------------------------------------------
-- Usuarios más populares por favoritos
---------------------------------------------------------------
SELECT
    u.nombre_usuario,
    u.nombre,
    u.apellido,
    COUNT(f.id_publicacion) AS total_favoritos
FROM Usuarios u
JOIN Publicaciones p ON u.nombre_usuario = p.nombre_usuario
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY u.nombre_usuario, u.nombre, u.apellido
ORDER BY total_favoritos DESC;
