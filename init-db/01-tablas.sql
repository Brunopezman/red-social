CREATE TABLE IF NOT EXISTS Paises (
    nombre_pais VARCHAR(50) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS Usuarios(
    username VARCHAR(100) PRIMARY KEY,
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
    
    FOREIGN KEY (id_creador) REFERENCES Usuarios(username)
);

CREATE TABLE IF NOT EXISTS Publicaciones (
    id_publicacion INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,

    FOREIGN KEY (username) REFERENCES Usuarios(username) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Imagenes (
    id_publicacion INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    url_imagen VARCHAR(200) NOT NULL CHECK (url_imagen LIKE 'http%'),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Textos (
    id_publicacion INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    texto TEXT NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Videos (
    id_publicacion INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) DEFAULT NULL,
    url_video VARCHAR(200) NOT NULL CHECK (url_video LIKE 'http%'),
    duracion INT NOT NULL CHECK (duracion BETWEEN 1 AND 10),
    calidad VARCHAR(20) CHECK (calidad IN ('480p', '720p', '1080p', '4K')),

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion)
        ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Usuarios_Grupos(
    username VARCHAR(100) NOT NULL,
    nombre_grupo VARCHAR(100) NOT NULL,
    fecha_de_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (username, nombre_grupo),
    FOREIGN KEY (username) REFERENCES Usuarios(username) ON DELETE CASCADE,
    FOREIGN KEY (nombre_grupo) REFERENCES Grupos(nombre_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Comentarios(
    id_comentario SERIAL PRIMARY KEY,
    id_publicacion INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    contenido VARCHAR(300) NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES Usuarios(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Amistades (
    username_1 VARCHAR(100) NOT NULL,
    username_2 VARCHAR(100) NOT NULL,
    estado VARCHAR(10) NOT NULL CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')),
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY(username_1, username_2),

    FOREIGN KEY (username_1) REFERENCES Usuarios(username),
    FOREIGN KEY (username_2) REFERENCES Usuarios(username),

    CHECK (username_1 <> username_2)
);

-- índice de unicidad para pares (A,B) ≡ (B,A)
CREATE UNIQUE INDEX idx_amistad_par_unico ON Amistades (
    LEAST(username_1, username_2),
    GREATEST(username_1, username_2)
);

CREATE TABLE IF NOT EXISTS Notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    username_destino VARCHAR(100) NOT NULL,
    username_origen VARCHAR(100),
    tipo VARCHAR(30) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (username_destino) REFERENCES Usuarios(username),
    FOREIGN KEY (username_origen)  REFERENCES Usuarios(username)
);

CREATE TABLE IF NOT EXISTS Mensajes(
    id_mensaje SERIAL PRIMARY KEY,
    username_emisor VARCHAR(100) NOT NULL,
    username_receptor VARCHAR(100) NOT NULL,
    estado VARCHAR(20) DEFAULT 'no_leido' CHECK (estado IN ('leido', 'no_leido')),
    contenido VARCHAR(500) NOT NULL,
    fecha_de_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (username_emisor) REFERENCES Usuarios(username) ON DELETE CASCADE,
    FOREIGN KEY (username_receptor) REFERENCES Usuarios(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Favoritos(
    username VARCHAR(100) NOT NULL,
    id_publicacion INT NOT NULL,

    PRIMARY KEY (username, id_publicacion),

    FOREIGN KEY (username) REFERENCES Usuarios(username) ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);
