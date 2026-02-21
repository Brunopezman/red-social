--------------------------------------------------------------
-- PAISES
--------------------------------------------------------------
INSERT INTO Paises VALUES
('Argentina'),
('Chile'),
('Uruguay'),
('Brasil');


--------------------------------------------------------------
-- USUARIOS
--------------------------------------------------------------
INSERT INTO Usuarios (nombre_usuario, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES
('bpezman',    'bruno@correo.com',   '2000-05-10', 'Bruno',   'Pezman',    'Argentina'),
('mlopez',     'mariana@correo.com', '1998-11-23', 'Mariana', 'Lopez',     'Chile'),
('jperez',     'juan@correo.com',    '1995-03-15', 'Juan',    'Perez',     'Uruguay'),
('arodriguez', 'ana@correo.com',     '2001-07-30', 'Ana',     'Rodriguez', 'Argentina'),
('cfernandez', 'carlos@correo.com',  '1999-09-12', 'Carlos',  'Fernandez', 'Brasil');


--------------------------------------------------------------
-- GRUPOS
--------------------------------------------------------------
INSERT INTO Grupos (nombre_grupo, id_creador, descripcion) VALUES
('fotografia',        'bpezman',    'Grupo para compartir fotos'),
('Cocina Creativa',   'mlopez',     'Recetas y platos'),
('Viajes y Aventuras','jperez',     'Experiencias alrededor del mundo');

--------------------------------------------------------------
-- USUARIOS EN GRUPOS
--------------------------------------------------------------
INSERT INTO Usuarios_Grupos VALUES
('bpezman', 'fotografia'),
('mlopez', 'Cocina Creativa'),
('jperez', 'Viajes y Aventuras'),
('arodriguez', 'fotografia'),
('jperez', 'Cocina Creativa'),
('cfernandez', 'Cocina Creativa'),
('mlopez', 'fotografia'),
('bpezman', 'Viajes y Aventuras'),
('cfernandez', 'Viajes y Aventuras') 
ON CONFLICT DO NOTHING;

--------------------------------------------------------------
-- SOLICITUDES DE AMISTAD
--------------------------------------------------------------
INSERT INTO Amistades VALUES ('bpezman','mlopez','pendiente');
INSERT INTO Amistades VALUES ('bpezman','jperez','pendiente');
INSERT INTO Amistades VALUES ('mlopez','arodriguez','pendiente');
INSERT INTO Amistades VALUES ('jperez','cfernandez','pendiente');


--------------------------------------------------------------
-- ACEPTAR AMISTADES
--------------------------------------------------------------
UPDATE Amistades SET estado='aceptada' WHERE nombre_usuario_1='bpezman' AND nombre_usuario_2='mlopez';
UPDATE Amistades SET estado='aceptada' WHERE nombre_usuario_1='bpezman' AND nombre_usuario_2='jperez';
UPDATE Amistades SET estado='aceptada' WHERE nombre_usuario_1='mlopez' AND nombre_usuario_2='arodriguez';
UPDATE Amistades SET estado='aceptada' WHERE nombre_usuario_1='jperez' AND nombre_usuario_2='cfernandez';


--------------------------------------------------------------
-- PUBLICACIONES
--------------------------------------------------------------
INSERT INTO Imagenes (nombre_usuario, nombre_grupo, url_imagen)
VALUES ('bpezman', NULL, 'http://imagenes.com/foto1.jpg');

INSERT INTO Imagenes (nombre_usuario, nombre_grupo, url_imagen)
VALUES ('mlopez', 'fotografia', 'http://imagenes.com/foto_grupo.jpg');

INSERT INTO Textos (nombre_usuario, nombre_grupo, texto)
VALUES ('jperez', NULL, 'Hoy comencé a estudiar SQL');

INSERT INTO Textos (nombre_usuario, nombre_grupo, texto)
VALUES ('cfernandez', 'Cocina Creativa', 'Nueva receta riquísima');


--------------------------------------------------------------
-- VIDEOS
--------------------------------------------------------------
INSERT INTO Videos (nombre_usuario, nombre_grupo, url_video, duracion, calidad)
VALUES ('cfernandez', NULL, 'http://videos.com/clip.mp4', 5, '720p');

INSERT INTO Videos (nombre_usuario, nombre_grupo, url_video, duracion, calidad)
VALUES ('mlopez', 'fotografia', 'http://videos.com/travel.mp4', 7, '1080p');


--------------------------------------------------------------
-- COMENTARIOS
--------------------------------------------------------------
INSERT INTO Comentarios (id_publicacion, nombre_usuario, contenido)
VALUES
(1,'mlopez','¡Muy buena foto!'),
(3,'bpezman','100% de acuerdo'),
(4,'cfernandez','Quiero esa receta'),
(6,'jperez','Hermoso lugar');


--------------------------------------------------------------
-- MENSAJES
--------------------------------------------------------------
INSERT INTO Mensajes (nombre_usuario_emisor, nombre_usuario_receptor, contenido)
VALUES
('bpezman','mlopez','¡Hola! ¿Cómo estás?'),
('mlopez','bpezman','Todo bien Bruno, ¿vos?'),
('jperez','cfernandez','¿Te gustó mi comentario?');


--------------------------------------------------------------
-- FAVORITOS
--------------------------------------------------------------
INSERT INTO Favoritos VALUES
('bpezman',2),
('bpezman',3),
('mlopez',1),
('jperez',4),
('cfernandez',6);
