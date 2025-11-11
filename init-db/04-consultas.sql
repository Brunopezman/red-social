-- ===========================
-- TRIGGERS
-- ===========================

-- Trigger para verificar notificaciones de amistad
CREATE OR REPLACE FUNCTION verificar_notificacion_amistad()
RETURNS TRIGGER AS $$
BEGIN
   IF NOT EXISTS (
    SELECT 1 
        FROM Notificaciones_Amistad na 
        WHERE na.id_usuario_solicitante = NEW.id_usuario1 
          AND na.id_usuario_receptor = NEW.id_usuario2
          AND na.estado = 'aceptada'
        UNION ALL
        SELECT 1 
        FROM Notificaciones_Amistad na 
        WHERE na.id_usuario_solicitante = NEW.id_usuario2 
          AND na.id_usuario_receptor = NEW.id_usuario1
          AND na.estado = 'aceptada'
    ) THEN
    RAISE EXCEPTION 'No se puede crear la amistad. No existe una solicitud de amistad "aceptada" previa entre los usuarios.';
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER antes_insertar_amistad
BEFORE INSERT ON Amistades
FOR EACH ROW
EXECUTE FUNCTION verificar_notificacion_amistad();

-- Trigger para evitar amistades duplicadas
CREATE OR REPLACE FUNCTION normalizar_amistad()
RETURNS TRIGGER AS $$
DECLARE
    -- Declaramos la variable temporal DENTRO del cuerpo principal de la función
    temp_id INT;
BEGIN
    -- 1. Verificar si la relación está en orden inverso (Ej: INSERT (20, 10))
    IF NEW.id_usuario1 > NEW.id_usuario2 THEN

        -- 2. Realizar el intercambio de valores
        temp_id := NEW.id_usuario1;
        NEW.id_usuario1 := NEW.id_usuario2;
        NEW.id_usuario2 := temp_id;
    RAISE EXCEPTION 'Ya existe una amistad entre ambos usuarios';
    END IF;

    -- 3. Si la relación ya existe (ej: (10, 20)),
    -- la clave primaria lanzará el error al intentar insertar (10, 20) nuevamente.

    RETURN NEW; -- Devolver la nueva fila (posiblemente normalizada)
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_normalizar_amistad
BEFORE INSERT ON Amistades
FOR EACH ROW
EXECUTE FUNCTION normalizar_amistad();

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

-- Triggers para notificaciones
CREATE OR REPLACE FUNCTION notificaciones_amistad_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_id_evento INT;
BEGIN
    -- 1. Crear el evento único
    INSERT INTO Eventos_Notificacion (tipo_evento)
    VALUES ('amistad')
    RETURNING id_evento INTO v_id_evento; -- Capturar el ID generado

    -- 2. Asignar ese ID a la fila hija
    NEW.id_evento := v_id_evento;

    -- 3. Crear la alerta individual (1:1)
    INSERT INTO Notificaciones (id_usuario, id_evento)
    VALUES (NEW.id_usuario_receptor, v_id_evento);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_insert_notificaciones_amistad
BEFORE INSERT ON Notificaciones_Amistad
FOR EACH ROW
EXECUTE FUNCTION notificaciones_amistad_trigger();

CREATE OR REPLACE FUNCTION notificaciones_publicacion_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_id_evento INT;
    v_id_usuario_receptor INT;
BEGIN
    -- 1. Crear el evento único
    INSERT INTO Eventos_Notificacion (tipo_evento)
    VALUES ('publicacion')
    RETURNING id_evento INTO v_id_evento; -- Capturar el ID generado

    -- 2. Asignar ese ID a la fila hija
    NEW.id_evento := v_id_evento;

    -- 3. Obtener el ID del usuario receptor (Dueño de la publicación)
    -- Asumiendo que la tabla Publicaciones tiene el id_usuario del creador
    SELECT id_usuario INTO v_id_usuario_receptor
    FROM Publicaciones
    WHERE id_publicacion = NEW.id_publicacion;
    
    -- 4. Crear la alerta individual (1:1)
    INSERT INTO Notificaciones (id_usuario, id_evento)
    VALUES (v_id_usuario_receptor, v_id_evento);

    -- 5. Permitir que la inserción en la tabla de detalles proceda
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_insert_notificaciones_publicacion
BEFORE INSERT ON Notificaciones_Publicacion
FOR EACH ROW
EXECUTE FUNCTION notificaciones_publicacion_trigger();


CREATE OR REPLACE FUNCTION notificaciones_grupo_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_id_evento INT;
    miembro_id INT;
BEGIN
    -- 1. Crear el evento único
    INSERT INTO Eventos_Notificacion (tipo_evento)
    VALUES ('grupo')
    RETURNING id_evento INTO v_id_evento;

    -- 2. Asignar ese ID a la fila hija (detalles del grupo)
    NEW.id_evento := v_id_evento;

    -- 3. Crear múltiples alertas individuales (1:N)
    FOR miembro_id IN
        -- Asumiendo la tabla Usuarios_Grupos
        SELECT id_usuario
        FROM Usuarios_Grupos 
        WHERE id_grupo = NEW.id_grupo
    LOOP
        INSERT INTO Notificaciones (id_usuario, id_evento)
        VALUES (miembro_id, v_id_evento);
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_insert_notificaciones_grupo
BEFORE INSERT ON Notificaciones_Grupo
FOR EACH ROW
EXECUTE FUNCTION notificaciones_grupo_trigger();

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
