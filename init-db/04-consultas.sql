-- ============================================================
-- TRIGGERS
-- ============================================================

---------------------------------------------------------------
-- Notificar cuando un usuario publica algo (a sus amigos)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_notif_publicacion_amigos()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Notificaciones (username_destino, username_origen, tipo)
    SELECT 
        CASE 
            WHEN a.username_1 = NEW.username THEN a.username_2
            ELSE a.username_1
        END AS amigo,
        NEW.username,
        'nueva_publicacion_amigo'
    FROM Amistades a
    WHERE 
        (a.username_1 = NEW.username OR a.username_2 = NEW.username)
        AND a.estado = 'aceptada';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_amigos_publicacion
AFTER INSERT ON Publicaciones
FOR EACH ROW
EXECUTE FUNCTION trg_notif_publicacion_amigos();


---------------------------------------------------------------
-- Notificar cuando se publica algo dentro de un grupo
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_notif_publicacion_grupo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nombre_grupo IS NOT NULL THEN
        INSERT INTO Notificaciones (username_destino, username_origen, tipo)
        SELECT 
            ug.username,
            NEW.username,
            'nueva_publicacion_grupo'
        FROM Usuarios_Grupos ug
        WHERE 
            ug.nombre_grupo = NEW.nombre_grupo
            AND ug.username <> NEW.username;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_grupo_publicacion
AFTER INSERT ON Publicaciones
FOR EACH ROW
EXECUTE FUNCTION trg_notif_publicacion_grupo();


---------------------------------------------------------------
-- Validar aceptación de amistad SOLO si hubo notificación previa
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_amistad_aceptada()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'aceptada' THEN
        IF NOT EXISTS (
            SELECT 1
            FROM Notificaciones n
            WHERE 
                n.tipo = 'solicitud_amistad'
                AND (
                    (n.username_origen = NEW.username_1 AND n.username_destino = NEW.username_2)
                    OR
                    (n.username_origen = NEW.username_2 AND n.username_destino = NEW.username_1)
                )
        ) THEN
            RAISE EXCEPTION 'No se puede aceptar amistad sin solicitud previa';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_amistad_aceptada
BEFORE INSERT OR UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION validar_amistad_aceptada();


---------------------------------------------------------------
-- Notificación por solicitud de amistad
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_notif_solicitud_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'pendiente' THEN
        INSERT INTO Notificaciones (username_destino, username_origen, tipo)
        VALUES (NEW.username_2, NEW.username_1, 'solicitud_amistad');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_solicitud_amistad
AFTER INSERT ON Amistades
FOR EACH ROW
EXECUTE FUNCTION trg_notif_solicitud_amistad();


---------------------------------------------------------------
-- Notificación por aceptación de amistad
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_notif_aceptacion_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado = 'pendiente' AND NEW.estado = 'aceptada' THEN
        INSERT INTO Notificaciones (username_destino, username_origen, tipo)
        VALUES (NEW.username_1, NEW.username_2, 'amistad_aceptada');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_aceptacion_amistad
AFTER UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION trg_notif_aceptacion_amistad();


---------------------------------------------------------------
-- TRIGGERS DE CREACIÓN AUTOMÁTICA DE PUBLICACIONES
---------------------------------------------------------------

-- Textos
CREATE OR REPLACE FUNCTION insertar_publicacion_texto_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Publicaciones (id_publicacion, username, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.username, NEW.nombre_grupo);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_texto
BEFORE INSERT ON Textos
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_texto_func();


-- Imágenes
CREATE OR REPLACE FUNCTION insertar_publicacion_imagen_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Publicaciones (id_publicacion, username, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.username, NEW.nombre_grupo);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_imagen
BEFORE INSERT ON Imagenes
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_imagen_func();


-- Videos
CREATE OR REPLACE FUNCTION insertar_publicacion_video_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Publicaciones (id_publicacion, username, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.username, NEW.nombre_grupo);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_video
BEFORE INSERT ON Videos
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_video_func();


---------------------------------------------------------------
-- TRIGGER para eliminar publicaciones al borrar medios
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION eliminar_publicacion_func()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Publicaciones
    WHERE id_publicacion = OLD.id_publicacion;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER eliminar_publicacion_texto
AFTER DELETE ON Textos
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();

CREATE TRIGGER eliminar_publicacion_imagen
AFTER DELETE ON Imagenes
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();

CREATE TRIGGER eliminar_publicacion_video
AFTER DELETE ON Videos
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();



-- ============================================================
-- CONSULTAS
-- ============================================================


---------------------------------------------------------------
-- Registrar un usuario
---------------------------------------------------------------
INSERT INTO Usuarios (username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES ('vcecen', 'valentinoceniceros@gmail.com', '2001-11-11', 'Valentino', 'Ceniceros', 'Argentina');


---------------------------------------------------------------
-- Listar todos los usuarios
---------------------------------------------------------------
SELECT username, nombre, apellido, pais
FROM Usuarios;


---------------------------------------------------------------
-- Listar todas las amistades aceptadas
---------------------------------------------------------------
SELECT
    a.username_1,
    u.nombre AS nombre_1,
    u.apellido AS apellido_1,
    a.username_2,
    u2.nombre AS nombre_2,
    u2.apellido AS apellido_2
FROM Amistades a
JOIN Usuarios u  ON a.username_1 = u.username
JOIN Usuarios u2 ON a.username_2 = u2.username
WHERE a.estado = 'aceptada';

---------------------------------------------------------------
-- Listar amigos de un usuario en particular
---------------------------------------------------------------
SELECT
    u.username,
    u.nombre,
    u.apellido,
    u.pais
FROM Usuarios u
WHERE u.username IN (
    SELECT CASE
               WHEN a.username_1 = 'bpezman' THEN a.username_2
               ELSE a.username_1
           END
    FROM Amistades a
    WHERE 'bpezman' IN (a.username_1, a.username_2)
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
INSERT INTO Textos (id_publicacion, username, texto)
VALUES (20, 'bpezman', '¡Hola a todos! Primera publicación.');

INSERT INTO Imagenes (id_publicacion, username, url_imagen)
VALUES (21, 'mlopez', 'http://imagenes.com/ejemplo.jpg');

INSERT INTO Videos (id_publicacion, username, url_video, duracion, calidad)
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
-- Publicaciones más populares
---------------------------------------------------------------
SELECT
    p.id_publicacion,
    COUNT(f.id_publicacion) AS cantidad_favoritos,
    p.username
FROM Publicaciones p
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY p.id_publicacion, p.username
ORDER BY cantidad_favoritos DESC;

---------------------------------------------------------------
-- Usuarios más populares por favoritos
---------------------------------------------------------------
SELECT
    u.username,
    u.nombre,
    u.apellido,
    COUNT(f.id_publicacion) AS total_favoritos
FROM Usuarios u
JOIN Publicaciones p ON u.username = p.username
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY u.username, u.nombre, u.apellido
ORDER BY total_favoritos DESC;
