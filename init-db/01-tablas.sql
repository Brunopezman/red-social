CREATE TABLE IF NOT EXISTS Paises (
    nombre_pais VARCHAR(50) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS Usuarios(
    nombre_usuario VARCHAR(100) PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%_@__%.__%'),
    fecha_de_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_de_nacimiento DATE CHECK (fecha_de_nacimiento <= CURRENT_DATE),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    cantidad_de_ingresos INT DEFAULT 0 CHECK (cantidad_de_ingresos >= 0),
    
    FOREIGN KEY (pais) REFERENCES Paises(nombre_pais)
);

CREATE TABLE IF NOT EXISTS Grupos(
    nombre_grupo VARCHAR(100) PRIMARY KEY,
    id_creador VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300) DEFAULT NULL,
    fecha_de_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_creador) REFERENCES Usuarios(nombre_usuario)
);

CREATE TABLE IF NOT EXISTS Publicaciones (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,

    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Imagenes (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    url_imagen VARCHAR(200) NOT NULL CHECK (url_imagen LIKE 'http%'),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Textos (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    texto TEXT NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Videos (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    url_video VARCHAR(200) NOT NULL CHECK (url_video LIKE 'http%'),
    duracion INT NOT NULL CHECK (duracion BETWEEN 1 AND 10),
    calidad VARCHAR(20) CHECK (calidad IN ('480p', '720p', '1080p', '4K')),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Usuarios_Grupos(
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) NOT NULL,
    fecha_de_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (nombre_usuario, nombre_grupo),
    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Comentarios(
    id_comentario SERIAL PRIMARY KEY,
    id_publicacion INT NOT NULL,
    nombre_usuario VARCHAR(100) NOT NULL,
    contenido VARCHAR(300) NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Amistades (
    nombre_usuario_1 VARCHAR(100) NOT NULL,
    nombre_usuario_2 VARCHAR(100) NOT NULL,
    estado VARCHAR(10) NOT NULL CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')),
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY(nombre_usuario_1, nombre_usuario_2),

    FOREIGN KEY (nombre_usuario_1) REFERENCES Usuarios(nombre_usuario),
    FOREIGN KEY (nombre_usuario_2) REFERENCES Usuarios(nombre_usuario),

    CHECK (nombre_usuario_1 <> nombre_usuario_2)
);

-- índice de unicidad para pares (A,B) ≡ (B,A)
CREATE UNIQUE INDEX idx_amistad_par_unico ON Amistades (
    LEAST(nombre_usuario_1, nombre_usuario_2),
    GREATEST(nombre_usuario_1, nombre_usuario_2)
);

CREATE TABLE IF NOT EXISTS Notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    nombre_usuario_destino VARCHAR(100) NOT NULL,
    nombre_usuario_origen VARCHAR(100),
    tipo VARCHAR(30) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (nombre_usuario_destino) REFERENCES Usuarios(nombre_usuario),
    FOREIGN KEY (nombre_usuario_origen)  REFERENCES Usuarios(nombre_usuario)
);

CREATE TABLE IF NOT EXISTS Mensajes(
    id_mensaje SERIAL PRIMARY KEY,
    nombre_usuario_emisor VARCHAR(100) NOT NULL,
    nombre_usuario_receptor VARCHAR(100) NOT NULL,
    estado VARCHAR(20) DEFAULT 'no_leido' CHECK (estado IN ('leido', 'no_leido')),
    contenido VARCHAR(500) NOT NULL,
    fecha_de_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (nombre_usuario_emisor) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (nombre_usuario_receptor) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Favoritos(
    nombre_usuario VARCHAR(100) NOT NULL,
    id_publicacion INT NOT NULL,

    PRIMARY KEY (nombre_usuario, id_publicacion),

    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);

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
