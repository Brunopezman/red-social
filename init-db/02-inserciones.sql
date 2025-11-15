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
-- USUARIOS
----------------------------------------------
INSERT INTO Usuarios (username, email, fecha_de_nacimiento, nombre, apellido, pais, cantidad_de_ingresos)
VALUES
('bpezman',    'bruno@correo.com',   '2000-05-10', 'Bruno',   'Pezman',    'Argentina', 3),
('mlopez',     'mariana@correo.com', '1998-11-23', 'Mariana', 'Lopez',     'Chile',     5),
('jperez',     'juan@correo.com',    '1995-03-15', 'Juan',    'Perez',     'Uruguay',   2),
('arodriguez', 'ana@correo.com',     '2001-07-30', 'Ana',     'Rodriguez', 'Argentina', 1),
('cfernandez', 'carlos@correo.com',  '1999-09-12', 'Carlos',  'Fernandez', 'Brasil',    9);

----------------------------------------------
-- GRUPOS
----------------------------------------------
INSERT INTO Grupos (nombre_grupo, id_creador, descripcion)
VALUES
('Fotografía',        'bpezman',    'Grupo para compartir fotos'),
('Cocina Creativa',   'mlopez',     'Recetas y platos'),
('Viajes y Aventuras','jperez',     'Experiencias alrededor del mundo');

----------------------------------------------
-- USUARIOS_GRUPOS
----------------------------------------------
INSERT INTO Usuarios_Grupos (username, nombre_grupo)
VALUES
('bpezman', 'Fotografía'),
('mlopez',  'Fotografía'),
('arodriguez', 'Fotografía'),

('mlopez',  'Cocina Creativa'),
('jperez',  'Cocina Creativa'),
('cfernandez', 'Cocina Creativa'),

('bpezman', 'Viajes y Aventuras'),
('jperez', 'Viajes y Aventuras'),
('cfernandez', 'Viajes y Aventuras');

----------------------------------------------
-- AMISTADES
-- Todas aceptadas
----------------------------------------------
INSERT INTO Amistades (username_1, username_2, estado)
VALUES
('bpezman', 'mlopez', 'aceptada'),
('bpezman', 'jperez', 'aceptada'),
('mlopez', 'arodriguez', 'aceptada'),
('jperez', 'cfernandez', 'aceptada');

----------------------------------------------
-- PUBLICACIONES  (IDs 1–6)
----------------------------------------------
INSERT INTO Publicaciones (id_publicacion, username, nombre_grupo)
VALUES
(1, 'bpezman', NULL),
(2, 'mlopez', 'Fotografía'),
(3, 'jperez', NULL),
(4, 'arodriguez', 'Cocina Creativa'),
(5, 'cfernandez', NULL),
(6, 'mlopez', 'Viajes y Aventuras');

----------------------------------------------
-- IMAGENES
----------------------------------------------
INSERT INTO Imagenes (id_publicacion, username, nombre_grupo, url_imagen)
VALUES
(1, 'bpezman', NULL, 'http://imagenes.com/foto1.jpg'),
(2, 'mlopez', 'Fotografía', 'http://imagenes.com/foto_grupo1.jpg');

----------------------------------------------
-- TEXTOS
----------------------------------------------
INSERT INTO Textos (id_publicacion, username, nombre_grupo, texto)
VALUES
(3, 'jperez', NULL, 'Hoy es un gran día para aprender SQL.'),
(4, 'arodriguez', 'Cocina Creativa', 'Nueva receta de pasta casera.');

----------------------------------------------
-- VIDEOS
----------------------------------------------
INSERT INTO Videos (id_publicacion, username, nombre_grupo, url_video, duracion, calidad)
VALUES
(5, 'cfernandez', NULL, 'http://videos.com/clip1.mp4', 5, '720p'),
(6, 'mlopez', 'Viajes y Aventuras', 'http://videos.com/viaje.mp4', 7, '1080p');

----------------------------------------------
-- COMENTARIOS (id_autogenerados)
----------------------------------------------
INSERT INTO Comentarios (id_publicacion, username, contenido)
VALUES
(1, 'mlopez', '¡Gran foto Bruno!'),
(3, 'bpezman', 'Totalmente de acuerdo.'),
(4, 'cfernandez', 'Me encanta esa receta.'),
(6, 'jperez', 'Quiero ir a ese lugar.');

----------------------------------------------
-- NOTIFICACIONES (id_autogenerados)
----------------------------------------------
INSERT INTO Notificaciones (username_destino, username_origen, tipo)
VALUES
('mlopez', 'bpezman', 'amistad'),
('jperez', 'bpezman', 'nueva_publicacion'),
('bpezman', 'mlopez', 'publicacion_grupo'),
('cfernandez', 'jperez', 'amistad'),
('jperez', 'mlopez', 'publicacion_grupo');

----------------------------------------------
-- MENSAJES (id_autogenerados)
----------------------------------------------
INSERT INTO Mensajes (username_emisor, username_receptor, estado, contenido)
VALUES
('bpezman', 'mlopez', 'leido', 'Hola Mariana, ¿cómo estás?'),
('mlopez', 'bpezman', 'no_leido', 'Todo bien Bruno, ¿vos?'),
('jperez', 'cfernandez', 'no_leido', '¿Te gustó mi comentario?');

----------------------------------------------
-- FAVORITOS
----------------------------------------------
INSERT INTO Favoritos (username, id_publicacion)
VALUES
('bpezman', 2),
('bpezman', 3),
('mlopez', 1),
('jperez', 4),
('cfernandez', 6);
