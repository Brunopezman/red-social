-- ============================================================
-- TRIGGERS
-- ============================================================

---------------------------------------------------------------
-- Notificar cuando un usuario publica algo (a sus amigos)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_notif_publicacion_amigos()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
    SELECT 
        CASE 
            WHEN a.nombre_usuario_1 = NEW.nombre_usuario THEN a.nombre_usuario_2
            ELSE a.nombre_usuario_1
        END AS amigo,
        NEW.nombre_usuario,
        'nueva_publicacion_amigo'
    FROM Amistades a
    WHERE 
        (a.nombre_usuario_1 = NEW.nombre_usuario OR a.nombre_usuario_2 = NEW.nombre_usuario)
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
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        SELECT 
            ug.nombre_usuario,
            NEW.nombre_usuario,
            'nueva_publicacion_grupo'
        FROM Usuarios_Grupos ug
        WHERE 
            ug.nombre_grupo = NEW.nombre_grupo
            AND ug.nombre_usuario <> NEW.nombre_usuario;
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
                    (n.nombre_usuario_origen = NEW.nombre_usuario_1 AND n.nombre_usuario_destino = NEW.nombre_usuario_2)
                    OR
                    (n.nombre_usuario_origen = NEW.nombre_usuario_2 AND n.nombre_usuario_destino = NEW.nombre_usuario_1)
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
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        VALUES (NEW.nombre_usuario_2, NEW.nombre_usuario_1, 'solicitud_amistad');
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
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        VALUES (NEW.nombre_usuario_1, NEW.nombre_usuario_2, 'amistad_aceptada');
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
    INSERT INTO Publicaciones (id_publicacion, nombre_usuario, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.nombre_usuario, NEW.nombre_grupo);
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
    INSERT INTO Publicaciones (id_publicacion, nombre_usuario, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.nombre_usuario, NEW.nombre_grupo);
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
    INSERT INTO Publicaciones (id_publicacion, nombre_usuario, nombre_grupo)
    VALUES (NEW.id_publicacion, NEW.nombre_usuario, NEW.nombre_grupo);
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
