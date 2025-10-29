-- Triggers
CREATE TRIGGER insertar_publicacion_texto
BEFORE INSERT ON Textos
FOR EACH ROW
BEGIN
  INSERT INTO Publicaciones (id_publicacion, id_usuario, contenido)
  VALUES (NEW.id_publicacion, 1, NEW.texto);
END;

CREATE TRIGGER actualizar_publicacion_texto
AFTER UPDATE ON Textos
FOR EACH ROW
BEGIN
  UPDATE Publicaciones
  SET contenido = NEW.texto
  WHERE id_publicacion = NEW.id_publicacion;
END;

CREATE TRIGGER eliminar_publicacion_texto
BEFORE DELETE ON Textos
FOR EACH ROW
BEGIN
  DELETE FROM Publicaciones
  WHERE id_publicacion = OLD.id_publicacion;
END;

CREATE TRIGGER insertar_publicacion_imagen
BEFORE INSERT ON Imagenes
FOR EACH ROW
BEGIN
  INSERT INTO Publicaciones (id_publicacion, id_usuario, contenido, url)
  VALUES (NEW.id_publicacion, 1, 'Imagen publicada', NEW.url_imagen);
END;

CREATE TRIGGER actualizar_publicacion_imagen
AFTER UPDATE ON Imagenes
FOR EACH ROW
BEGIN
  UPDATE Publicaciones
  SET url = NEW.url_imagen
  WHERE id_publicacion = NEW.id_publicacion;
END;

CREATE TRIGGER eliminar_publicacion_imagen
BEFORE DELETE ON Imagenes
FOR EACH ROW
BEGIN
  DELETE FROM Publicaciones
  WHERE id_publicacion = OLD.id_publicacion;
END;

CREATE TRIGGER insertar_publicacion_video
BEFORE INSERT ON Videos
FOR EACH ROW
BEGIN
  INSERT INTO Publicaciones (id_publicacion, id_usuario, contenido, url)
  VALUES (NEW.id_publicacion, 1, 'Video publicado', NEW.url_video);
END;

CREATE TRIGGER actualizar_publicacion_video
AFTER UPDATE ON Videos
FOR EACH ROW
BEGIN
  UPDATE Publicaciones
  SET url = NEW.url_video
  WHERE id_publicacion = NEW.id_publicacion;
END;

CREATE TRIGGER eliminar_publicacion_video
BEFORE DELETE ON Videos
FOR EACH ROW
BEGIN
  DELETE FROM Publicaciones
  WHERE id_publicacion = OLD.id_publicacion;
END;

-- Registrar un usuario.
INSERT INTO Usuarios (
    id_usuario,
    username,
    email,
    fecha_de_nacimiento,
    nombre,
    apellido,
    pais
) VALUES (
    1,
    'bpezman',
    'bruno.pezman@example.com',
    '1995-07-15',
    'Bruno',
    'Pezman',
    'Argentina'
);

-- Listar todos los usuarios de la red social.
SELECT
    id_usuario,
    username,
    nombre,
    apellido,
    pais
FROM Usuarios;

-- Listar todas las amistades de la red social.
SELECT 
    a.id_usuario1, 
    u.nombre,
    u.apellido,
    a.id_usuario2, 
    u2.nombre,
    u2.apellido
FROM Amistades a 
JOIN Usuarios u ON a.id_usuario1 = u.id_usuario 
JOIN Usuarios u2 ON a.id_usuario2 = u2.id_usuario;

-- Listar los amigos de un usuario particular de la red social.
SELECT 
    u.id_usuario,
    u.username,
    u.nombre,
    u.apellido,
    u.pais
FROM Usuarios u
WHERE u.id_usuario IN (
    SELECT 
        CASE 
            WHEN a.id_usuario1 = 2 THEN a.id_usuario2
            ELSE a.id_usuario1
        END AS amigo_id
    FROM Amistades a
    WHERE 2 IN (a.id_usuario1, a.id_usuario2)
);

-- Listar todos los mensajes de la red social.
SELECT * FROM Mensajes;

-- Contabilizar la cantidad de usuarios, agrupados por país.
SELECT 
    pais,
    COUNT(*) AS cantidad_usuarios
FROM Usuarios
GROUP BY pais
ORDER BY cantidad_usuarios DESC;

-- Realizar una publicación (dar un ejemplo de cada tipo).
INSERT INTO Textos (id_publicacion, texto)
VALUES (1, '¡Hola a todos! Esta es mi primera publicación en la red.');

INSERT INTO Imagenes (id_publicacion, url_imagen)
VALUES (2, 'http://example.com/playa.jpg');

INSERT INTO Videos (id_publicacion, url_video, duracion, calidad)
VALUES (3, 'http://example.com/concierto.mp4', 240, '1080p');

-- Actualizar una publicación (dar un ejemplo de cada tipo).
UPDATE Textos
SET texto = '¡Actualización! Agrego más detalles sobre mi día.'
WHERE id_publicacion = 1;

UPDATE Imagenes
SET url_imagen = 'http://example.com/atardecer.jpg'
WHERE id_publicacion = 2;

UPDATE Videos
SET url_video = 'http://example.com/concierto_full.mp4', duracion = 360, calidad = '4K'
WHERE id_publicacion = 3;

-- Eliminar una publicación (dar un ejemplo de cada tipo).
DELETE FROM Textos WHERE id_publicacion = 1;

DELETE FROM Imagenes WHERE id_publicacion = 2;

DELETE FROM Videos WHERE id_publicacion = 3;

-- Desregistrar a un usuario de la aplicación (dar un ejemplo).
DELETE FROM Usuarios WHERE id_usuario = 1;
-- Mostrar las publicaciones más populares ordenadas por cantidad de “favoritos” que poseen.
SELECT 
    p.id_publicacion,
    p.contenido,
    p.id_usuario,
    u.username AS autor,
    COUNT(f.id_usuario) AS cantidad_favoritos
FROM Publicaciones p
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
JOIN Usuarios u ON p.id_usuario = u.id_usuario
GROUP BY p.id_publicacion, p.contenido, p.id_usuario, u.username
ORDER BY cantidad_favoritos DESC;

-- Mostrar los usuarios más populares basandose en la cantidad de publicaciones “favoritas” que poseen sus publicaciones.
SELECT 
    u.id_usuario,
    u.username,
    u.nombre,
    u.apellido,
    COUNT(f.id_publicacion) AS total_favoritos
FROM Usuarios u
JOIN Publicaciones p ON u.id_usuario = p.id_usuario
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY u.id_usuario, u.username, u.nombre, u.apellido
ORDER BY total_favoritos DESC;
