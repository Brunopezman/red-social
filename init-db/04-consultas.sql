-- ===========================
-- TRIGGERS
-- ===========================
-- Para notificar cuando un amigo publica algo

CREATE OR REPLACE FUNCTION trg_notif_publicacion_amigos()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Notificaciones (id_destino, id_usuario_origen, tipo)
    SELECT 
        CASE 
            WHEN a.id_usuario_1 = NEW.id_usuario THEN a.id_usuario_2
            ELSE a.id_usuario_1
        END AS amigo,
        NEW.id_usuario,
        'nueva_publicacion_amigo'
    FROM Amistades a
    WHERE 
        (a.id_usuario_1 = NEW.id_usuario OR a.id_usuario_2 = NEW.id_usuario)
        AND a.estado = 'aceptada';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_amigos_publicacion
AFTER INSERT ON Publicaciones
FOR EACH ROW
EXECUTE FUNCTION trg_notif_publicacion_amigos();

-- Notificar cuando se sube algo a un grupo
CREATE OR REPLACE FUNCTION trg_notif_publicacion_grupo()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo notificar si la publicación pertenece a un grupo
    IF NEW.id_grupo IS NOT NULL THEN
        INSERT INTO Notificaciones (id_usuario_destino, id_usuario_origen, tipo)
        SELECT 
            ug.id_usuario,
            NEW.id_usuario,
            'nueva_publicacion_grupo'
        FROM Usuarios_Grupos ug
        WHERE 
            ug.id_grupo = NEW.id_grupo
            AND ug.id_usuario <> NEW.id_usuario;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_grupo_publicacion
AFTER INSERT ON Publicaciones
FOR EACH ROW
EXECUTE FUNCTION trg_notif_publicacion_grupo();

-- Trigger para validar la amistad
CREATE OR REPLACE FUNCTION validar_amistad_aceptada()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'aceptada' THEN
        IF NOT EXISTS (
            SELECT 1
            FROM Notificaciones N
            WHERE 
                N.tipo = 'SOLICITUD_AMISTAD'
                AND (
                    (N.id_usuario_origen = NEW.id_usuario_1 AND N.id_destino = NEW.id_usuario_2)
                    OR
                    (N.id_usuario_origen = NEW.id_usuario_2 AND N.id_destino = NEW.id_usuario_1)
                )
        ) THEN
            RAISE EXCEPTION 'No se puede aceptar amistad sin notificación previa';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validar_amistad_aceptada
BEFORE INSERT OR UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION validar_amistad_aceptada();

-- Triggers para solicitud de amistad
CREATE OR REPLACE FUNCTION trg_notif_solicitud_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'pendiente' THEN
        INSERT INTO Notificaciones (id_usuario_destino, id_usuario_origen, tipo)
        VALUES (NEW.id_usuario_2, NEW.id_usuario_1, 'solicitud_amistad');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_solicitud_amistad
AFTER INSERT ON Amistades
FOR EACH ROW
EXECUTE FUNCTION trg_notif_solicitud_amistad();

CREATE OR REPLACE FUNCTION trg_notif_aceptacion_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado = 'pendiente' AND NEW.estado = 'aceptada' THEN
        INSERT INTO Notificaciones (id_usuario_destino, id_usuario_origen, tipo)
        VALUES (NEW.id_usuario_1, NEW.id_usuario_2, 'amistad_aceptada');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notificar_aceptacion_amistad
AFTER UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION trg_notif_aceptacion_amistad();

-- Trigger para insertar Texto
CREATE OR REPLACE FUNCTION insertar_publicacion_texto_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Crea una Publicacion usando el texto y el id_usuario del registro nuevo (NEW)
    INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo)
    VALUES (NEW.id_publicacion, NEW.id_usuario, NEW.id_grupo); 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_texto
BEFORE INSERT ON Textos
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_texto_func();

-- Trigger para insertar Imagen 
CREATE OR REPLACE FUNCTION insertar_publicacion_imagen_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Crea una Publicacion usando 'Imagen publicada' como contenido y la URL de la imagen (NEW)
    INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo)
    VALUES (NEW.id_publicacion, NEW.id_usuario, NEW.id_grupo);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_imagen
BEFORE INSERT ON Imagenes
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_imagen_func();

-- Trigger para insertar Video
CREATE OR REPLACE FUNCTION insertar_publicacion_video_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Crea una Publicacion usando 'Video publicado' como contenido y la URL del video (NEW)
    INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo)
    VALUES (NEW.id_publicacion, NEW.id_usuario, NEW.id_grupo);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertar_publicacion_video
BEFORE INSERT ON Videos
FOR EACH ROW
EXECUTE FUNCTION insertar_publicacion_video_func();

-- Triggers para DELETES que llaman a la misma funcion 
CREATE OR REPLACE FUNCTION eliminar_publicacion_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Elimina la Publicacion usando la clave de la fila eliminada (OLD)
    DELETE FROM Publicaciones
    WHERE id_publicacion = OLD.id_publicacion;
    
    -- Los triggers BEFORE DELETE requieren devolver OLD.
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql;

-- Triggers de Eliminación que llaman a la misma función
CREATE TRIGGER eliminar_publicacion_texto
BEFORE DELETE ON Textos
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();

CREATE TRIGGER eliminar_publicacion_imagen
BEFORE DELETE ON Imagenes
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();

CREATE TRIGGER eliminar_publicacion_video
BEFORE DELETE ON Videos
FOR EACH ROW
EXECUTE FUNCTION eliminar_publicacion_func();

-- ===========================
-- CONSULTAS
-- ===========================

-- Registrar un usuario.
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais) VALUES
(7, 'Valen', 'valentinoceniceros@gmail.com', '2001-11-11', 'Valentino', 'Ceniceros', 'Argentina');

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
            WHEN a.id_usuario1 = CURRENT_USER THEN a.id_usuario2
            ELSE a.id_usuario1
        END AS amigo_id
    FROM Amistades a
    WHERE CURRENT_USER IN (a.id_usuario1, a.id_usuario2)
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
INSERT INTO Textos (id_publicacion, id_usuario, texto)
VALUES (1, 1, '¡Hola a todos! Probando mi primera publicación de texto.');

INSERT INTO Imagenes (id_publicacion, id_usuario, url_imagen)
VALUES (3, 3, 'http://imagenes.com/mi_escritorio.jpg');

INSERT INTO Videos (id_publicacion, id_usuario, url_video, duracion, calidad)
VALUES (5, 5, 'http://videos.com/receta_express.mp4', 180, '720p');

-- Actualizar una publicación (dar un ejemplo de cada tipo).
-- Actualiza Texto (Publicacion 1)
UPDATE Textos
SET texto = '¡Actualización! Agrego más detalles sobre mi día.',
    id_usuario = 1 -- Si se permite actualizar id_usuario, si no, se mantiene
WHERE id_publicacion = 1;

-- Actualiza Imagen (Publicacion 3)
UPDATE Imagenes
SET url_imagen = 'http://example.com/atardecer_nuevo.jpg'
WHERE id_publicacion = 3;

-- Actualiza Video (Publicacion 5)
UPDATE Videos
SET url_video = 'http://videos.com/receta_full.mp4', duracion = 360, calidad = '1080p'
WHERE id_publicacion = 5;

-- El trigger actualizar_publicacion_imagen/video debería actualizar el campo 'url' de Publicaciones
SELECT id_publicacion FROM Publicaciones WHERE id_publicacion IN (1, 3, 5);

-- Elimina Texto (Publicacion 2) -> Dispara eliminar_publicacion_texto
DELETE FROM Textos WHERE id_publicacion = 2;

-- Elimina Imagen (Publicacion 4) -> Dispara eliminar_publicacion_imagen
DELETE FROM Imagenes WHERE id_publicacion = 4;

-- Elimina Video (Publicacion 6) -> Dispara eliminar_publicacion_video
DELETE FROM Videos WHERE id_publicacion = 6;

-- Verificamos que las Publicaciones 2, 4 y 6 hayan sido eliminadas
SELECT id_publicacion FROM Publicaciones WHERE id_publicacion IN (2, 4, 6);

-- Desregistrar a un usuario de la aplicación (dar un ejemplo).
DELETE FROM Usuarios WHERE id_usuario = 5;

-- Mostrar las publicaciones más populares ordenadas por cantidad de “favoritos” que poseen.
SELECT
    p.id_publicacion,
    COUNT(f.id_publicacion) AS cantidad_de_favoritos,
    p.id_usuario
FROM Publicaciones p
LEFT JOIN Favoritos f ON p.id_publicacion = f.id_publicacion
GROUP BY p.id_publicacion, p.id_usuario
ORDER BY cantidad_de_favoritos DESC;

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