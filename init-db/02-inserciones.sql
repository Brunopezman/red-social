-- ===========================
-- 10 Inserciones en Paises
-- ===========================
INSERT INTO Paises(nombre_pais) VALUES
('Argentina'),('Brasil'),('Chile'),('Uruguay'),('Paraguay'),
('Bolivia'),('Peru'),('Colombia'),('Ecuador'),('Venezuela');

-- ===========================
-- 10 Inserciones en Usuarios
-- ===========================
INSERT INTO Usuarios(id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais, cantidad_de_ingresos) VALUES
(1,'bruno_pez','bruno@example.com','1990-05-12','Bruno','Pezman','Argentina',5),
(2,'ana_garcia','ana@example.com','1985-08-23','Ana','Garcia','Brasil',3),
(3,'juan_perez','juan@example.com','1992-11-05','Juan','Perez','Chile',2),
(4,'maria_lopez','maria@example.com','1995-01-17','Maria','Lopez','Uruguay',4),
(5,'carlos_rodriguez','carlos@example.com','1988-07-30','Carlos','Rodriguez','Paraguay',1),
(6,'sofia_martinez','sofia@example.com','1993-03-21','Sofia','Martinez','Bolivia',0),
(7,'diego_sanchez','diego@example.com','1991-12-11','Diego','Sanchez','Peru',6),
(8,'laura_gomez','laura@example.com','1989-09-09','Laura','Gomez','Colombia',2),
(9,'federico_ramos','federico@example.com','1994-06-02','Federico','Ramos','Ecuador',3),
(10,'camila_vasquez','camila@example.com','1996-02-14','Camila','Vasquez','Venezuela',0);

-- ===========================
-- 10 Inserciones en Grupos
-- ===========================
INSERT INTO Grupos(id_grupo, nombre_grupo, descripcion) VALUES
(1,'Programadores','Grupo de desarrolladores de software'),
(2,'Fotografia','Amantes de la fotografia y cámaras'),
(3,'Viajes','Compartimos experiencias de viajes'),
(4,'Cocina','Recetas y tips de cocina'),
(5,'Deportes','Aficionados a varios deportes'),
(6,'Musica','Intercambio de música y artistas'),
(7,'Cine','Cine y series'),
(8,'Tecnologia','Noticias y novedades tecnológicas'),
(9,'Lectura','Club de lectura'),
(10,'Gaming','Videojuegos y esports');

-- ===========================
-- 10 Inserciones en Publicaciones
-- ===========================
INSERT INTO Publicaciones(id_publicacion, id_usuario, id_grupo, url, contenido) VALUES
(1,1,1,'http://post1.com','Primera publicación de Bruno'),
(2,2,2,'http://post2.com','Publicación de Ana sobre fotografía'),
(3,3,3,'http://post3.com','Juan comparte su viaje a la montaña'),
(4,4,4,'http://post4.com','Maria su receta favorita'),
(5,5,5,'http://post5.com','Carlos comenta sobre deportes'),
(6,6,6,'http://post6.com','Sofia recomienda música'),
(7,7,7,'http://post7.com','Diego comenta película'),
(8,8,8,'http://post8.com','Laura habla de tecnología'),
(9,9,9,'http://post9.com','Federico recomienda libro'),
(10,10,10,'http://post10.com','Camila comparte su experiencia gaming');

-- ===========================
-- 10 Inserciones en Imagenes
-- ===========================
INSERT INTO Imagenes(id_publicacion, url_imagen) VALUES
(1,'http://img1.com'),(2,'http://img2.com'),(3,'http://img3.com'),
(4,'http://img4.com'),(5,'http://img5.com'),(6,'http://img6.com'),
(7,'http://img7.com'),(8,'http://img8.com'),(9,'http://img9.com'),(10,'http://img10.com');

-- ===========================
-- 10 Inserciones en Textos
-- ===========================
INSERT INTO Textos(id_publicacion, texto) VALUES
(1,'Texto adicional 1'),(2,'Texto adicional 2'),(3,'Texto adicional 3'),
(4,'Texto adicional 4'),(5,'Texto adicional 5'),(6,'Texto adicional 6'),
(7,'Texto adicional 7'),(8,'Texto adicional 8'),(9,'Texto adicional 9'),(10,'Texto adicional 10');

-- ===========================
-- 10 Inserciones en Videos
-- ===========================
INSERT INTO Videos(id_publicacion, url_video, duracion, calidad) VALUES
(1,'http://video1.com',120,'720p'),(2,'http://video2.com',300,'1080p'),
(3,'http://video3.com',60,'480p'),(4,'http://video4.com',200,'4K'),
(5,'http://video5.com',150,'720p'),(6,'http://video6.com',180,'1080p'),
(7,'http://video7.com',90,'480p'),(8,'http://video8.com',240,'4K'),
(9,'http://video9.com',110,'720p'),(10,'http://video10.com',130,'1080p');

-- ===========================
-- 10 Inserciones en Usuarios_Grupos
-- ===========================
INSERT INTO Usuarios_Grupos(id_usuario, id_grupo) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- ===========================
-- 10 Inserciones en Comentarios
-- ===========================
INSERT INTO Comentarios(id_comentario, id_publicacion, id_usuario, contenido) VALUES
(1,1,2,'Comentario de Ana en publicación de Bruno'),
(2,2,3,'Comentario de Juan en publicación de Ana'),
(3,3,4,'Comentario de Maria en publicación de Juan'),
(4,4,5,'Comentario de Carlos en publicación de Maria'),
(5,5,6,'Comentario de Sofia en publicación de Carlos'),
(6,6,7,'Comentario de Diego en publicación de Sofia'),
(7,7,8,'Comentario de Laura en publicación de Diego'),
(8,8,9,'Comentario de Federico en publicación de Laura'),
(9,9,10,'Comentario de Camila en publicación de Federico'),
(10,10,1,'Comentario de Bruno en publicación de Camila');

-- ===========================
-- 10 Inserciones en Amistades
-- ===========================
INSERT INTO Amistades(id_usuario1, id_usuario2) VALUES
(1,2),(1,3),(2,4),(2,5),(3,6),
(3,7),(4,8),(4,9),(5,10),(6,10);

-- ===========================
-- 10 Inserciones en Favoritos
-- ===========================
INSERT INTO Favoritos(id_usuario, id_publicacion) VALUES
(1,2),(1,3),(2,1),(2,4),(3,5),
(3,6),(4,7),(4,8),(5,9),(5,10);

-- ===========================
-- 10 Inserciones en Mensajes
-- ===========================
INSERT INTO Mensajes(id_mensaje, id_usuario_emisor, id_usuario_receptor, contenido) VALUES
(1,1,2,'Hola Ana!'),(2,2,1,'Hola Bruno!'),
(3,3,4,'Hola Maria!'),(4,4,3,'Hola Juan!'),
(5,5,6,'Hola Sofia!'),(6,6,5,'Hola Carlos!'),
(7,7,8,'Hola Laura!'),(8,8,7,'Hola Diego!'),
(9,9,10,'Hola Camila!'),(10,10,9,'Hola Federico!');

-- ===========================
-- 10 Inserciones en Notificaciones
-- ===========================
INSERT INTO Notificaciones(id_notificacion, id_usuario) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- ===========================
-- 10 Inserciones en Notificaciones_Amistad
-- ===========================
INSERT INTO Notificaciones_Amistad(id_notificacion, id_usuario_solicitante) VALUES
(1,2),(2,3),(3,4),(4,5),(5,6),
(6,7),(7,8),(8,9),(9,10),(10,1);

-- ===========================
-- 10 Inserciones en Notificaciones_Publicacion
-- ===========================
INSERT INTO Notificaciones_Publicacion(id_notificacion, id_usuario_publicador, id_publicacion, tipo) VALUES
(1,1,1,'like'),(2,2,2,'comentario'),
(3,3,3,'like'),(4,4,4,'comentario'),
(5,5,5,'like'),(6,6,6,'comentario'),
(7,7,7,'like'),(8,8,8,'comentario'),
(9,9,9,'like'),(10,10,10,'comentario');

-- ===========================
-- 10 Inserciones en Notificaciones_Grupo
-- ===========================
INSERT INTO Notificaciones_Grupo(id_notificacion, id_grupo, mensaje) VALUES
(1,1,'Nuevo post en Programadores'),
(2,2,'Nuevo post en Fotografia'),
(3,3,'Nuevo post en Viajes'),
(4,4,'Nuevo post en Cocina'),
(5,5,'Nuevo post en Deportes'),
(6,6,'Nuevo post en Musica'),
(7,7,'Nuevo post en Cine'),
(8,8,'Nuevo post en Tecnologia'),
(9,9,'Nuevo post en Lectura'),
(10,10,'Nuevo post en Gaming');
