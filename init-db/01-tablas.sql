-- ============================================================
-- TABLA: PAISES
-- ============================================================
CREATE TABLE IF NOT EXISTS Paises (
    nombre_pais VARCHAR(50) PRIMARY KEY
);


-- ============================================================
-- TABLA: USUARIOS
-- ============================================================
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


-- ============================================================
-- TABLA: GRUPOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Grupos(
    nombre_grupo VARCHAR(100) PRIMARY KEY,
    id_creador VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    fecha_de_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_creador) REFERENCES Usuarios(nombre_usuario)
);


-- ============================================================
-- TABLA RELACIÓN: USUARIOS_GRUPOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Usuarios_Grupos(
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) NOT NULL,
    fecha_de_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (nombre_usuario, nombre_grupo),
    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);


-- ============================================================
-- TABLA: PUBLICACIONES (Padre de Textos/Imagenes/Videos)
-- ============================================================
CREATE TABLE IF NOT EXISTS Publicaciones (
    id_publicacion SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100),

    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);


-- ============================================================
-- SUBTABLA: IMAGENES
-- ============================================================
CREATE TABLE IF NOT EXISTS Imagenes (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100),
    url_imagen VARCHAR(300) NOT NULL CHECK (url_imagen LIKE 'http%'),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);


-- ============================================================
-- SUBTABLA: TEXTOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Textos (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100),
    texto TEXT NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);


-- ============================================================
-- SUBTABLA: VIDEOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Videos (
    id_publicacion INT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100),
    url_video VARCHAR(300) NOT NULL CHECK (url_video LIKE 'http%'),
    duracion INT NOT NULL CHECK (duracion BETWEEN 1 AND 10),
    calidad VARCHAR(20) CHECK (calidad IN ('480p', '720p', '1080p', '4K')),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);


-- ============================================================
-- TABLA: COMENTARIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Comentarios(
    id_comentario SERIAL PRIMARY KEY,
    id_publicacion INT NOT NULL,
    nombre_usuario VARCHAR(100) NOT NULL,
    contenido VARCHAR(300) NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE
);


-- ============================================================
-- TABLA: AMISTADES
-- ============================================================
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

-- Índice simétrico para evitar duplicados A-B == B-A
CREATE UNIQUE INDEX IF NOT EXISTS idx_amistad_par_unico ON Amistades (
    LEAST(nombre_usuario_1, nombre_usuario_2),
    GREATEST(nombre_usuario_1, nombre_usuario_2)
);


-- ============================================================
-- TABLA: NOTIFICACIONES
-- ============================================================
CREATE TABLE IF NOT EXISTS Notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    nombre_usuario_destino VARCHAR(100) NOT NULL,
    nombre_usuario_origen VARCHAR(100),
    tipo VARCHAR(40) NOT NULL CHECK(tipo IN (
        'solicitud_amistad',
        'amistad_aceptada',
        'amistad_rechazada',
        'nueva_publicacion_amigo',
        'nueva_publicacion_grupo'
    )),
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (nombre_usuario_destino) REFERENCES Usuarios(nombre_usuario),
    FOREIGN KEY (nombre_usuario_origen)  REFERENCES Usuarios(nombre_usuario)
);


-- ============================================================
-- TABLA: MENSAJES
-- ============================================================
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


-- ============================================================
-- TABLA: FAVORITOS
-- ============================================================
CREATE TABLE IF NOT EXISTS Favoritos(
    nombre_usuario VARCHAR(100) NOT NULL,
    id_publicacion INT NOT NULL,

    PRIMARY KEY (nombre_usuario, id_publicacion),

    FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);



-- ============================================================
-- TRIGGERS Y FUNCIONES
-- ============================================================


-- ============================================================
-- TRIGGER DE VALIDACIÓN DE FLUJO DE AMISTADES
-- Solo permitir INSERT en estado 'pendiente'
-- Solo permitir UPDATE desde 'pendiente'
-- Sólo permitir aceptar si hubo noti previa
-- ============================================================
CREATE OR REPLACE FUNCTION validar_amistad_aceptada()
RETURNS TRIGGER AS $$
BEGIN
    -- INSERT: solo pendiente
    IF TG_OP = 'INSERT' AND NEW.estado <> 'pendiente' THEN
        RAISE EXCEPTION 'Al crear la amistad, solo se permite estado pendiente';
    END IF;

    -- UPDATE: solo desde pendiente
    IF TG_OP = 'UPDATE' AND OLD.estado <> 'pendiente' AND NEW.estado <> OLD.estado THEN
        RAISE EXCEPTION 'El estado de una amistad solo puede cambiar desde ''pendiente''';
    END IF;

    -- Aceptación requiere notificación previa
    IF NEW.estado = 'aceptada' THEN
        IF NOT EXISTS (
            SELECT 1
            FROM Notificaciones n
            WHERE n.tipo = 'solicitud_amistad'
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

DROP TRIGGER IF EXISTS trg_validar_amistad_aceptada ON Amistades;
CREATE TRIGGER trg_validar_amistad_aceptada
BEFORE INSERT OR UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION validar_amistad_aceptada();



-- ============================================================
-- NOTIFICACIÓN POR SOLICITUD DE AMISTAD
-- ============================================================
CREATE OR REPLACE FUNCTION notif_solicitud_amistad()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
    VALUES (NEW.nombre_usuario_2, NEW.nombre_usuario_1, 'solicitud_amistad');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_notif_solicitud_amistad ON Amistades;
CREATE TRIGGER trg_notif_solicitud_amistad
AFTER INSERT ON Amistades
FOR EACH ROW
EXECUTE FUNCTION notif_solicitud_amistad();



-- ============================================================
-- NOTIFICACIÓN POR ACEPTACIÓN
-- ============================================================
CREATE OR REPLACE FUNCTION notif_aceptacion_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado = 'pendiente' AND NEW.estado = 'aceptada' THEN
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        VALUES (NEW.nombre_usuario_1, NEW.nombre_usuario_2, 'amistad_aceptada');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_notif_aceptacion_amistad ON Amistades;
CREATE TRIGGER trg_notif_aceptacion_amistad
AFTER UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION notif_aceptacion_amistad();



-- ============================================================
-- NOTIFICACIÓN POR RECHAZO
-- ============================================================
CREATE OR REPLACE FUNCTION notif_rechazo_amistad()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado = 'pendiente' AND NEW.estado = 'amistad_rechazada' THEN
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        VALUES (NEW.nombre_usuario_1, NEW.nombre_usuario_2, 'amistad_rechazada');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_notif_rechazo_amistad ON Amistades;
CREATE TRIGGER trg_notif_rechazo_amistad
AFTER UPDATE ON Amistades
FOR EACH ROW
EXECUTE FUNCTION notif_rechazo_amistad();



-- ============================================================
-- CREACIÓN AUTOMÁTICA DE PUBLICACIONES + VALIDACIÓN DE GRUPO
-- (TEXTOS, IMAGENES, VIDEOS)
-- ============================================================

CREATE OR REPLACE FUNCTION crear_publicacion_y_validar_grupo()
RETURNS TRIGGER AS $$
DECLARE
    nuevo_id INT;
BEGIN
    -- Validación: si publica en grupo, debe pertenecer
    IF NEW.nombre_grupo IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1
            FROM Usuarios_Grupos
            WHERE nombre_usuario = NEW.nombre_usuario
              AND nombre_grupo  = NEW.nombre_grupo
        ) THEN
            RAISE EXCEPTION 'El usuario % no pertenece al grupo %',
            NEW.nombre_usuario, NEW.nombre_grupo;
        END IF;
    END IF;

    -- Crear publicación si es nueva
    INSERT INTO Publicaciones (nombre_usuario, nombre_grupo)
    VALUES (NEW.nombre_usuario, NEW.nombre_grupo)
    RETURNING id_publicacion INTO nuevo_id;

    NEW.id_publicacion := nuevo_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- TEXTOS
DROP TRIGGER IF EXISTS trg_textos_publicacion ON Textos;
CREATE TRIGGER trg_textos_publicacion
BEFORE INSERT ON Textos
FOR EACH ROW
EXECUTE FUNCTION crear_publicacion_y_validar_grupo();


-- IMAGENES
DROP TRIGGER IF EXISTS trg_imagen_publicacion ON Imagenes;
CREATE TRIGGER trg_imagen_publicacion
BEFORE INSERT ON Imagenes
FOR EACH ROW
EXECUTE FUNCTION crear_publicacion_y_validar_grupo();


-- VIDEOS
DROP TRIGGER IF EXISTS trg_video_publicacion ON Videos;
CREATE TRIGGER trg_video_publicacion
BEFORE INSERT ON Videos
FOR EACH ROW
EXECUTE FUNCTION crear_publicacion_y_validar_grupo();



-- ============================================================
-- NOTIFICAR PUBLICACIÓN A AMIGOS Y MIEMBROS DEL GRUPO
-- ============================================================
CREATE OR REPLACE FUNCTION notif_publicaciones()
RETURNS TRIGGER AS $$
BEGIN
    -- Notificación a amigos
    INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
    SELECT
        CASE
            WHEN a.nombre_usuario_1 = NEW.nombre_usuario THEN a.nombre_usuario_2
            ELSE a.nombre_usuario_1
        END,
        NEW.nombre_usuario,
        'nueva_publicacion_amigo'
    FROM Amistades a
    WHERE a.estado = 'aceptada'
      AND NEW.nombre_usuario IN (a.nombre_usuario_1, a.nombre_usuario_2);

    -- Notificación a grupo
    IF NEW.nombre_grupo IS NOT NULL THEN
        INSERT INTO Notificaciones (nombre_usuario_destino, nombre_usuario_origen, tipo)
        SELECT nombre_usuario, NEW.nombre_usuario, 'nueva_publicacion_grupo'
        FROM Usuarios_Grupos
        WHERE nombre_grupo = NEW.nombre_grupo
          AND nombre_usuario <> NEW.nombre_usuario;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_notif_publicacion ON Publicaciones;
CREATE TRIGGER trg_notif_publicacion
AFTER INSERT ON Publicaciones
FOR EACH ROW
EXECUTE FUNCTION notif_publicaciones();
