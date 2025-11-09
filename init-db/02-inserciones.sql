INSERT INTO Paises (nombre_pais) VALUES
('Argentina'),
('Chile'),
('Mexico'),
('España'),
('Colombia');

INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais) VALUES
(1, 'bruno', 'brunopezman@mail.com', '1995-07-15', 'Bruno', 'Pezman', 'Argentina'),
(2, 'carla', 'carlalopez@mail.com', '1998-03-20', 'Carla', 'Lopez', 'Chile'),
(3, 'david', 'davidgomez@mail.com', '1990-11-05', 'David', 'Gomez', 'Mexico'),
(4, 'elena', 'elenasanchez@mail.com', '2001-01-25', 'Elena', 'Sanchez', 'España'),
(5, 'felipe', 'felipediaz@mail.com', '1985-09-10', 'Felipe', 'Diaz', 'Colombia');

INSERT INTO Amistades (id_usuario1, id_usuario2) VALUES
(1, 2), -- Bruno y Carla
(1, 3), -- Bruno y David
(2, 4), -- Carla y Elena
(3, 5); -- David y Felipe

INSERT INTO Grupos (id_grupo, nombre_grupo, descripcion) VALUES
(101, 'Ricoteros', 'Fundamentalistas del aire acondicionado'),
(102, 'Programadores LATAM', 'Consultas y tips de código');

INSERT INTO Usuarios_Grupos (id_usuario, id_grupo) VALUES
(1, 101),
(2, 101),
(3, 102),
(4, 102),
(5, 101);

-- ID 1
INSERT INTO Textos (id_publicacion, id_usuario, texto)
VALUES (1, 1, '¡Hola a todos! Probando mi primera publicación de texto.');

-- ID 2
INSERT INTO Textos (id_publicacion, id_usuario, id_grupo, texto)
VALUES (2, 2, 101, '¿Alguien vio la nueva película de ciencia ficción? Recomendaciones...');

-- ID 3
INSERT INTO Imagenes (id_publicacion, id_usuario, url_imagen)
VALUES (3, 3, 'http://imagenes.com/mi_escritorio.jpg');

-- ID 4
INSERT INTO Imagenes (id_publicacion, id_usuario, id_grupo, url_imagen)
VALUES (4, 4, 102, 'http://imagenes.com/diagrama_db.png');

-- ID 5
INSERT INTO Videos (id_publicacion, id_usuario, url_video, duracion, calidad)
VALUES (5, 5, 'http://videos.com/receta_express.mp4', 180, '720p');

-- ID 6
INSERT INTO Videos (id_publicacion, id_usuario, url_video, duracion, calidad)
VALUES (6, 1, 'http://videos.com/viaje_sur.mp4', 600, '1080p');

INSERT INTO Favoritos (id_usuario, id_publicacion) VALUES
(2, 1),
(3, 1), -- Publicación 1 (Texto de Bruno): 3 favoritos
(4, 1),
(1, 3),
(2, 3), -- Publicación 3 (Imagen de David): 2 favoritos
(5, 5); -- Publicación 5 (Video de Felipe): 1 favorito

INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido) VALUES
(1, 1, 2, '¡Excelente post, Bruno!'),
(2, 3, 1, 'Genial la foto.'),
(3, 5, 2, 'Buena receta, voy a probarla.'),
(4, 5, 4, 'Me encanta el 720p, buena calidad.');

INSERT INTO Mensajes (id_mensaje, id_usuario_emisor, id_usuario_receptor, estado, contenido) VALUES
(1, 1, 2, 'leido', 'Hola Carla, ¿cómo estás?'),
(2, 2, 1, 'no_leido', '¡Hola Bruno! Todo bien, ¿y tú?'),
(3, 3, 4, 'leido', 'Revisa el código que te envié.'),
(4, 4, 3, 'no_leido', 'Lo reviso ahora, gracias.');

INSERT INTO Notificaciones (id_notificacion, id_usuario) VALUES
(10, 1), -- Para Bruno
(11, 1), -- Para Bruno
(12, 3), -- Para David
(13, 4); -- Para Elena

INSERT INTO Notificaciones_Amistad (id_notificacion, id_usuario_solicitante, estado) VALUES
(10, 2, 'pendiente');

-- Notificación 11: Like (para Bruno)
INSERT INTO Notificaciones_Publicacion (id_notificacion, id_usuario_publicador, id_publicacion, tipo) VALUES
(11, 3, 1, 'like');

-- Notificación 12: Comentario (para David)
INSERT INTO Notificaciones_Publicacion (id_notificacion, id_usuario_publicador, id_publicacion, tipo) VALUES
(12, 2, 3, 'comentario');

INSERT INTO Notificaciones_Grupo (id_notificacion, id_grupo, mensaje) VALUES
(13, 102, '¡Nueva reunión de programadores el próximo viernes!');