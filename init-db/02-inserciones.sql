-- ===========================
--          PAIS
-- ===========================

INSERT INTO Pais (nombre_pais) VALUES
('Argentina'), ('Colombia'), ('Peru'), ('Chile'), ('México'),
('España'), ('Uruguay'), ('Paraguay'), ('Bolivia'), ('Venezuela'),
('Brasil'), ('Nicaragua'), ('Ecuador'), ('Guatemala'), ('Honduras'),
('El Salvador'), ('Costa Rica'), ('Panamá'), ('República Dominicana');


-- ===========================
--          GRUPOS
-- ===========================

INSERT INTO Grupos (nombre_grupo, descripcion) VALUES
('Viajeros por el mundo', 'Grupo para compartir experiencias de viaje'),
('Programadores LATAM', 'Comunidad de desarrolladores hispanohablantes'),
('Amantes del café', 'Todo sobre café y cafeteras'),
('Fitness Total', 'Entrenamientos, dietas y motivación'),
('Gamers Unidos', 'Videojuegos, torneos y lanzamientos'),
('Cine y Series', 'Debates, recomendaciones y estrenos'),
('Fotografía Creativa', 'Técnicas y exposición de trabajos'),
('Mascotas Felices', 'Consejos y fotos de nuestras mascotas'),
('Música y Arte', 'Grupo de músicos y artistas visuales'),
('Emprendedores 2025', 'Negocios, innovación y startups');


-- ===========================
--          USUARIOS
-- ===========================

INSERT INTO Usuarios (username, email, fecha_de_nacimiento, nombre, apellido, pais, cantidad_de_ingresos) VALUES
('mjuarez', 'mjuarez@gmail.com', '1990-05-15', 'Martín', 'Juárez', 'Nicaragua', 5),
('lcastro', 'lcastro@gmail.com', '1985-03-22', 'Lucía', 'Castro', 'Argentina', 12),
('farias', 'farias@gmail.com', '1992-07-10', 'Federico', 'Arias', 'Argentina', 3),
('cdominguez', 'cdominguez@gmail.com', '1988-11-30', 'Carla', 'Domínguez', 'Argentina', 8),
('agomez', 'agomez@gmail.com', '1995-01-05', 'Agustina', 'Gómez', 'Argentina', 0),
('lsanchez', 'lsanchez@gmail.com', '1993-09-17', 'Luciano', 'Sanchez', 'Argentina', 6),
('jdasilva', 'jdasilva@gmail.com', '1980-06-25', 'Joao', 'Da Silva', 'Brasil', 15),
('rfernandez', 'rfernandez@gmail.com', '1991-04-12', 'Romina', 'Fernández', 'Argentina', 2),
('dtorres', 'dtorres@gmail.com', '1987-08-19', 'Diego', 'Torres', 'Argentina', 9),
('mramirez', 'mramirez@gmail.com', '1996-12-03', 'María', 'Ramírez', 'Colombia', 1),
('ncastillo', 'ncastillo@gmail.com', '1994-02-28', 'Nicolás', 'Castillo', 'Argentina', 4),
('fhernandez', 'fhernandez@gmail.com', '1989-10-07', 'Florencia', 'Hernández', 'España', 7),
('ealvarez', 'ealvarez@gmail.com', '1990-03-15', 'Ezequiel', 'Álvarez', 'Argentina', 0),
('gromero', 'gromero@gmail.com', '1986-07-21', 'Gabriela', 'Romero', 'Paraguay', 11),
('psanchez', 'psanchez@gmail.com', '1997-05-09', 'Pablo', 'Sánchez', 'Argentina', 3),
('jnavarro', 'jnavarro@gmail.com', '1992-01-30', 'Jimena', 'Navarro', 'Bolivia', 6),
('lvaldez', 'lvaldez@gmail.com', '1984-09-14', 'Leandro', 'Valdez', 'Ecuador', 13),
('hcastillo', 'hcastillo@gmail.com', '1993-06-18', 'Hernán', 'Castillo', 'Peru', 2),
('ysilva', 'ysilva@gmail.com', '1981-12-25', 'Yanina', 'Silva', 'Colombia', 10),
('rvera', 'rvera@gmail.com', '1995-08-01', 'Rodrigo', 'Vera', 'Venezuela', 1);


-- ===========================
--       PUBLICACIONES
-- ===========================

INSERT INTO Publicaciones(id_usuario, id_grupo, tipo, url, contenido, cantidad_de_likes) VALUES
(4, 2, 'imagen', 'http://example.com/viaje1.jpg', 'Mi primer viaje solo!', 200),
(2, 1, 'imagen', 'http://example.com/viaje1.jpg', 'Atardecer en Machu Picchu', 34),
(3, 5, 'video', 'http://example.com/gameplay1.mp4', 'Jugando el nuevo lanzamiento de 2025!', 88),
(4, 10, 'texto', NULL, 'Consejos para nuevos emprendedores', 14),
(5, 2, 'texto', NULL, 'Busco equipo para hackathon', 25),
(6, 1, 'imagen', 'http://example.com/taza.jpg', 'Nuevo café etíope recién molido!', 17),
(7, 3, 'video', 'http://example.com/latteart.mp4', 'Latte art en cámara lenta ☕', 8),
(8, 3, 'texto', NULL, '¿Alguien más prueba los granos colombianos?', 5),
(9, 4, 'texto', NULL, 'Nueva rutina de entrenamiento funcional', 31),
(10, 4, 'imagen', 'http://example.com/gympic.jpg', 'Progreso del mes', 42),
(11, 7, 'imagen', 'http://example.com/photo1.jpg', 'Atardecer en Patagonia 📸', 59),
(12, 7, 'video', 'http://example.com/timelapse.mp4', 'Timelapse nocturno', 44),
(13, 8, 'texto', NULL, 'Tips para cuidar a tu gato', 15),
(14, 5, 'texto', NULL, 'Reseña del nuevo juego RPG', 77),
(15, 9, 'texto', NULL, 'Mi nuevo tema musical!', 13),
(16, 10, 'imagen', 'http://example.com/pitch.jpg', 'Presentación del proyecto', 4),
(17, 1, 'texto', NULL, 'Nuevo destino: Islandia', 21),
(18, 2, 'texto', NULL, 'Aprendiendo Python en LATAM', 56),
(19, 5, 'video', 'http://example.com/review.mp4', 'Review del último shooter', 33),
(20, 3, 'texto', NULL, 'Comparte tu mejor receta de café', 9);



-- ===========================
--          IMAGENES
-- ===========================
INSERT INTO Imagenes(id_publicacion, url_imagen) VALUES
(4, 'http://example.com/viaje1.jpg'),
(6, 'http://example.com/taza.jpg'),
(10, 'http://example.com/gympic.jpg'),
(11, 'http://example.com/photo1.jpg'),
(16, 'http://example.com/pitch.jpg');


-- ===========================
--          TEXTOS
-- ===========================

INSERT INTO Textos (id_publicacion, texto) VALUES
(1, 'Mi primer post en la comunidad de programadores!'),
(4, 'Consejos para nuevos emprendedores'),
(5, 'Busco equipo para hackathon'),
(8, '¿Alguien más prueba los granos colombianos?'),
(9, 'Nueva rutina de entrenamiento funcional'),
(13, 'Tips para cuidar a tu gato'),
(14, 'Reseña del nuevo juego RPG'),
(15, 'Mi nuevo tema musical!'),
(17, 'Nuevo destino: Islandia'),
(18, 'Aprendiendo Python en LATAM'),
(20, 'Comparte tu mejor receta de café');


-- ===========================
--          VIDEOS
-- =========================== 

INSERT INTO Videos (id_publicacion, url_video, duracion, calidad) VALUES
(3, 'http://example.com/gameplay1.mp4', 180, '1080p'),
(7, 'http://example.com/latteart.mp4', 120, '720p'),
(12, 'http://example.com/timelapse.mp4', 240, '4K'),
(19, 'http://example.com/review.mp4', 200, '1080p');


-- ===========================
--       USUARIOS GRUPO
-- =========================== 

INSERT INTO Usuarios_Grupos (id_usuario, id_grupo) VALUES
(1, 5), (2, 1), (2, 6), (3, 5), (4, 2),
(4, 10), (5, 2), (5, 5), (6, 1), (7, 3),
(8, 3), (9, 4), (10, 4), (11, 7), (12, 7),
(13, 8), (14, 5), (15, 9), (16, 10), (17, 1),
(18, 2), (19, 5), (20, 3);

-- ===========================
--       COMENTARIOS
-- =========================== 

INSERT INTO Comentarios(id_publicacion, id_usuario, contenido) VALUES
(1, 2, 'Buen post!'),
(1, 3, 'Totalmente de acuerdo'),
(3, 5, 'Muy buen gameplay'),
(5, 1, 'Yo me anoto'),
(9, 10, 'Excelente rutina!'),
(11, 9, 'Qué buena foto'),
(12, 8, 'Hermoso timelapse'),
(14, 6, 'Gran reseña!'),
(18, 2, 'Python es genial!'),
(19, 1, 'Me encantó el video');

-- ===========================
--          AMISTADES
-- =========================== 

INSERT INTO Amistades (id_usuario1, id_usuario2) VALUES
(1, 2), (1, 3), (1, 5), (2, 3), (2, 4),
(3, 4), (3, 5), (4, 6), (4, 7), (5, 8),
(6, 9), (6, 10), (7, 11), (8, 12), (9, 13),
(10, 14), (11, 15), (12, 16), (13, 17), (14, 18),
(15, 19), (16, 20);


-- ===========================
--      NOTIFICACIONES
-- =========================== 

INSERT INTO Notificaciones (id_usuario) VALUES
(1), (2), (3), (4), (5),
(6), (7), (8), (9), (10),
(11), (12), (13), (14), (15),
(16), (17), (18), (19), (20);


-- ===========================
--  NOTIFICACIONES DE AMISTAD
-- =========================== 

INSERT INTO Notificaciones_Amistad (id_usuario_solicitante, fecha_de_solicitud, estado) VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '10 days', 'aceptada'),
(2, CURRENT_TIMESTAMP - INTERVAL '8 days', 'pendiente'),
(3, CURRENT_TIMESTAMP - INTERVAL '6 days', 'rechazada'),
(4, CURRENT_TIMESTAMP - INTERVAL '4 days', 'aceptada'),
(5, CURRENT_TIMESTAMP - INTERVAL '2 days', 'pendiente'),
(6, CURRENT_TIMESTAMP - INTERVAL '1 days', 'aceptada'),
(7, CURRENT_TIMESTAMP - INTERVAL '9 days', 'pendiente'),
(8, CURRENT_TIMESTAMP - INTERVAL '3 days', 'aceptada'),
(9, CURRENT_TIMESTAMP - INTERVAL '7 days', 'rechazada'),
(10, CURRENT_TIMESTAMP - INTERVAL '5 days', 'pendiente');


-- ===========================
--  NOTIFICACIONES DE PUBLICACION
-- =========================== 

INSERT INTO Notificaciones_Publicacion (id_usuario_publicador, id_publicacion, tipo) VALUES
(1, 3, 'like'),
(2, 10, 'comentario'),
(3, 14, 'like'),
(4, 5, 'comentario'),
(5, 9, 'like'),
(6, 12, 'comentario'),
(7, 19, 'like'),
(8, 3, 'comentario'),
(9, 11, 'like'),
(10, 4, 'comentario'),
(11, 16, 'like'),
(12, 7, 'comentario'),
(13, 18, 'like'),
(14, 14, 'comentario'),
(15, 5, 'like');


-- ===========================
--  NOTIFICACIONES DE GRUPO
-- =========================== 

INSERT INTO Notificaciones_Grupo (id_grupo, mensaje) VALUES
(1, 'Nuevo post en Viajeros por el mundo'),
(2, 'Nuevo miembro en Programadores LATAM'),
(3, 'Evento virtual de Amantes del café'),
(4, 'Rutina semanal publicada en Fitness Total'),
(5, 'Nuevo torneo anunciado en Gamers Unidos'),
(6, 'Película destacada en Cine y Series'),
(7, 'Desafío fotográfico semanal disponible'),
(8, 'Adopción responsable: casos nuevos'),
(9, 'Exposición de arte digital abierta'),
(10, 'Se lanzó una nueva guía de negocios 2025');


-- ========================
--        MENSAJES
-- ========================

INSERT INTO Mensajes (id_usuario_emisor, id_usuario_receptor, contenido, estado) VALUES
(1, 2, 'Hola Ana!', 'leido'),
(2, 1, 'Hola Facu!', 'leido'),
(3, 5, 'Jugamos esta noche?', 'no_leido'),
(5, 3, 'Sí, confirmo!', 'leido'),
(6, 1, 'Probaste el nuevo blend de café?', 'no_leido'),
(7, 8, 'Te mandé un video nuevo!', 'leido'),
(9, 10, 'Vamos al gym mañana?', 'no_leido'),
(11, 12, 'Linda foto!', 'leido'),
(13, 14, 'Excelente tip!', 'leido'),
(15, 16, 'Te gustó mi tema?', 'no_leido');

-- ========================
--        FAVORITOS
-- ========================

INSERT INTO Favoritos (id_usuario, id_publicacion) VALUES
(1, 3), (1, 5), (2, 3), (2, 10), (3, 11),
(3, 14), (4, 5), (4, 14), (5, 9), (6, 10),
(6, 12), (7, 2), (7, 14), (8, 3), (8, 19),
(9, 11), (10, 4), (11, 5), (12, 12), (13, 3),
(14, 10), (15, 11), (16, 14), (17, 1), (18, 5),
(19, 10), (20, 14);
