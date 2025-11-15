----------------------------------------------
-- PAISES
----------------------------------------------
INSERT INTO Paises (nombre_pais)
VALUES
('Argentina'),
('Chile'),
('Uruguay'),
('Brasil');

----------------------------------------------
-- USUARIOS (IDs manuales 1–5)
----------------------------------------------
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais, cantidad_de_ingresos)
VALUES
(1, 'bpezman',   'bruno@correo.com',   '2000-05-10', 'Bruno',   'Pezman',    'Argentina', 3),
(2, 'mlopez',    'mariana@correo.com', '1998-11-23', 'Mariana', 'Lopez',     'Chile',     5),
(3, 'jperez',    'juan@correo.com',    '1995-03-15', 'Juan',    'Perez',     'Uruguay',   2),
(4, 'arodriguez','ana@correo.com',     '2001-07-30', 'Ana',     'Rodriguez', 'Argentina', 1),
(5, 'cfernandez','carlos@correo.com',  '1999-09-12', 'Carlos',  'Fernandez', 'Brasil',    9);

----------------------------------------------
-- GRUPOS (IDs manuales 1–3)
----------------------------------------------
INSERT INTO Grupos (id_grupo, id_creador, nombre_grupo, descripcion)
VALUES
(1, 1, 'Fotografía', 'Grupo para compartir fotos'),
(2, 2, 'Cocina Creativa', 'Recetas y platos'),
(3, 3, 'Viajes y Aventuras', 'Experiencias alrededor del mundo');

----------------------------------------------
-- USUARIOS_GRUPOS
----------------------------------------------
INSERT INTO Usuarios_Grupos (id_usuario, id_grupo)
VALUES
(1,1), (2,1), (4,1),  -- Grupo Fotografía
(2,2), (3,2), (5,2),  -- Grupo Cocina
(1,3), (3,3), (5,3);  -- Grupo Viajes

----------------------------------------------
-- AMISTADES (IDs manuales 1–4)
-- Todas aceptadas para permitir notificaciones
----------------------------------------------
INSERT INTO Amistades (id_amistad, id_usuario_1, id_usuario_2, estado)
VALUES
(1, 1, 2, 'aceptada'),
(2, 1, 3, 'aceptada'),
(3, 2, 4, 'aceptada'),
(4, 3, 5, 'aceptada');

----------------------------------------------
-- PUBLICACIONES (IDs manuales 1–6)
----------------------------------------------
-- 1: Bruno (usuario 1) publica en su perfil
-- 2: Mariana (usuario 2) publica en grupo Fotografía
-- 3: Juan (3) publica texto
-- 4: Ana (4) publica en grupo Cocina
-- 5: Carlos (5) publica video
-- 6: Mariana (2) publica en Viajes

INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo)
VALUES
(1, 1, NULL),
(2, 2, 1),
(3, 3, NULL),
(4, 4, 2),
(5, 5, NULL),
(6, 2, 3);

----------------------------------------------
-- IMAGENES (IDs = id_publicacion)
----------------------------------------------
INSERT INTO Imagenes (id_publicacion, id_usuario, id_grupo, url_imagen)
VALUES
(1, 1, NULL, 'http://imagenes.com/foto1.jpg'),
(2, 2, 1,   'http://imagenes.com/foto_grupo1.jpg');

----------------------------------------------
-- TEXTOS
----------------------------------------------
INSERT INTO Textos (id_publicacion, id_usuario, id_grupo, texto)
VALUES
(3, 3, NULL, 'Hoy es un gran día para aprender SQL.'),
(4, 4, 2,   'Nueva receta de pasta casera.');

----------------------------------------------
-- VIDEOS
----------------------------------------------
INSERT INTO Videos (id_publicacion, id_usuario, id_grupo, url_video, duracion, calidad)
VALUES
(5, 5, NULL, 'http://videos.com/clip1.mp4', 5, '720p'),
(6, 2, 3,    'http://videos.com/viaje.mp4', 7, '1080p');

----------------------------------------------
-- COMENTARIOS
----------------------------------------------
INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido)
VALUES
(1, 1, 2, '¡Gran foto Bruno!'),
(2, 3, 1, 'Totalmente de acuerdo.'),
(3, 4, 5, 'Me encanta esa receta.'),
(4, 6, 3, 'Quiero ir a ese lugar.');

----------------------------------------------
-- NOTIFICACIONES (ejemplos)
----------------------------------------------
INSERT INTO Notificaciones (id_notificacion, id_usuario_destino, id_usuario_origen, tipo)
VALUES
(1, 2, 1, 'amistad'),      -- Bruno → Mariana
(2, 3, 1, 'nueva_publicacion'),
(3, 1, 2, 'publicacion_grupo'),
(4, 5, 3, 'amistad'),
(5, 3, 2, 'publicacion_grupo');

----------------------------------------------
-- MENSAJES
----------------------------------------------
INSERT INTO Mensajes (id_mensaje, id_usuario_emisor, id_usuario_receptor, estado, contenido)
VALUES
(1, 1, 2, 'leido', 'Hola Mariana, ¿cómo estás?'),
(2, 2, 1, 'no_leido', 'Todo bien Bruno, ¿vos?'),
(3, 3, 5, 'no_leido', '¿Te gustó mi comentario?');

----------------------------------------------
-- FAVORITOS
----------------------------------------------
INSERT INTO Favoritos (id_usuario, id_publicacion)
VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 4),
(5, 6);
