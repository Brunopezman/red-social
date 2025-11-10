CREATE TABLE IF NOT EXISTS Paises(
    nombre_pais VARCHAR(50) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS Grupos(
    id_grupo INT PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300) DEFAULT NULL,
    fecha_de_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Usuarios(
    id_usuario INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%_@__%.__%'),
    fecha_de_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_de_nacimiento DATE CHECK (fecha_de_nacimiento <= CURRENT_DATE),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    cantidad_de_ingresos INT DEFAULT 0 CHECK (cantidad_de_ingresos >= 0),
    FOREIGN KEY (pais) REFERENCES Paises(nombre_pais)
);

CREATE TABLE IF NOT EXISTS Publicaciones (
    id_publicacion INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_grupo INT DEFAULT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Imagenes (
    id_publicacion INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_grupo INT DEFAULT NULL,
    url_imagen VARCHAR(200) NOT NULL CHECK (url_imagen LIKE 'http%'),
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Textos (
    id_publicacion INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_grupo INT DEFAULT NULL,
    texto TEXT NOT NULL,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Videos (
    id_publicacion INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_grupo INT DEFAULT NULL,
    url_video VARCHAR(200) NOT NULL CHECK (url_video LIKE 'http%'),
    duracion INT NOT NULL CHECK (duracion BETWEEN 1 AND 10),
    calidad VARCHAR(20) CHECK (calidad IN ('480p', '720p', '1080p', '4K')),
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS Usuarios_Grupos(
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_de_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_grupo),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Comentarios(
    id_comentario INT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_usuario INT NOT NULL,
    contenido VARCHAR(300) NOT NULL,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Amistades(
    id_usuario1 INT NOT NULL,
    id_usuario2 INT NOT NULL,
    fecha_de_amistad TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario1, id_usuario2),
    CHECK (id_usuario1 <> id_usuario2),
    FOREIGN KEY (id_usuario1) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario2) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Eventos_Notificacion (
    id_evento	SERIAL	PRIMARY KEY,
    tipo_evento	VARCHAR(20)	NOT NULL CHECK (tipo_evento IN ('amistad', 'publicacion', 'grupo')),
    fecha_creacion	TIMESTAMP	DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Notificaciones(
    id_notificacion SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_evento INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_evento) REFERENCES Eventos_Notificacion(id_evento) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notificaciones_Amistad(
    id_evento INT PRIMARY KEY,
    id_usuario_solicitante INT NOT NULL,
    id_usuario_receptor INT NOT NULL,
    fecha_de_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aceptada', 'rechazada')),
    FOREIGN KEY (id_evento) REFERENCES Eventos_Notificacion(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_solicitante) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_receptor) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notificaciones_Publicacion(
    id_evento INT PRIMARY KEY,
    id_usuario_publicador INT NOT NULL,
    id_publicacion INT NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('like', 'comentario')),
    FOREIGN KEY (id_evento) REFERENCES Eventos_Notificacion(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_publicador) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notificaciones_Grupo (
    id_evento INT PRIMARY KEY,
    id_grupo INT NOT NULL,
    mensaje VARCHAR(300) NOT NULL,
    FOREIGN KEY (id_evento) REFERENCES Eventos_Notificacion(id_evento) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mensajes(
    id_mensaje INT PRIMARY KEY,
    id_usuario_emisor INT NOT NULL,
    id_usuario_receptor INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'no_leido' CHECK (estado IN ('leido', 'no_leido')),
    contenido VARCHAR(500) NOT NULL,
    fecha_de_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario_emisor) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_receptor) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Favoritos(
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    PRIMARY KEY (id_usuario, id_publicacion),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);
