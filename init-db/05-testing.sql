-- Inserts de prueba
INSERT INTO Paises(nombre_pais) VALUES
('Argentina'),('Brasil'),('Chile'),('Uruguay'),('Paraguay'),
('Bolivia'),('Peru'),('Colombia'),('Ecuador'),('Venezuela');

INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (10, 'milamantilla', 'milanesa@gmail.com', '2003-02-17', 'Mila', 'Mantilla', 'Argentina');
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (20, 'mpato', 'mpato@gmail.com', '2003-05-22', 'Manuel', 'Pato', 'Colombia');

-- Asigno roles
CREATE USER milamantilla WITH LOGIN PASSWORD 'securepass123';
GRANT user_role TO milamantilla;

CREATE USER mjuarez WITH LOGIN PASSWORD 'securepass123';
GRANT user_role TO mjuarez;

-- Realizo consultas, inserciones, updates y deletes 
SET ROLE milamantilla;
SELECT id_usuario, username
FROM usuarios
WHERE username = CURRENT_USER;

INSERT INTO Imagenes (id_publicacion, id_usuario, url_imagen)
VALUES (10, 10, 'http://post11.com');

INSERT INTO Imagenes (id_publicacion, id_usuario, id_grupo, url_imagen)
VALUES (11, 10, 101, 'http://sandunga.com');

-- Siendo un usuario no puedo publicar con el id de otro usuario
INSERT INTO Imagenes (id_publicacion, id_usuario, id_grupo, url_imagen)
VALUES (998, 2, NULL, 'http://post12.com');

-- Ahora, si
SET ROLE mjuarez;
INSERT INTO Imagenes (id_publicacion, id_usuario, id_grupo, url_imagen)
VALUES (998, 2, NULL, 'http://post12.com');

-- Actualizo la publi siendo milamantilla
SET ROLE milamantilla;
UPDATE Imagenes SET url_imagen = 'http://post18.com' WHERE id_publicacion = 999;

-- Borro siendo milamantilla
DELETE FROM Imagenes WHERE id_publicacion = 998;

-- Intento modificar una publicacion que no es de milamantilla, estando en milamantilla, da error
UPDATE Imagenes SET url_imagen = 'http://post404.com'
WHERE id_publicacion = (SELECT id_publicacion FROM Imagenes WHERE id_usuario = 3 LIMIT 1);

-- Le mando amistad a pato
INSERT INTO Notificaciones_amistad (id_evento, id_usuario_solicitante, id_usuario_receptor)
VALUES (12, 10, 20);

-- La solicitud de amistas es aceptada
UPDATE notificaciones_amistad SET estado = 'aceptada' WHERE id_evento = 12;

-- Se crea dicha amistad :)
INSERT INTO Amistades (id_usuario1, id_usuario2) VALUES (10, 20);



INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (111, 'aaaa', 'aaaaa@gmail.com', '2003-02-17', 'Mila', 'Mantilla', 'Argentina');
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (222, 'bbbb', 'bbbb@gmail.com', '2003-05-22', 'Manuel', 'Pato', 'Colombia');

UPDATE notificaciones_amistad SET estado = 'aceptada' WHERE id_evento = 20;

INSERT INTO Notificaciones_amistad (id_evento, id_usuario_solicitante, id_usuario_receptor)
VALUES (333, 222, 111);

INSERT INTO Amistades (id_usuario1, id_usuario2) VALUES (222, 111);


-- Le mando un mensaje a mpato
INSERT INTO Mensajes (id_mensaje, id_usuario_emisor, id_usuario_receptor, contenido)
VALUES (10, 10, 20, 'Hola mpato, soy milamantilla');

SELECT id_usuario_emisor, id_usuario_receptor, contenido
FROM Mensajes;

--Las politicas propuestas no permiten modificar los mensajes propios.
UPDATE Mensajes SET contenido = 'no se permite'
WHERE id_mensaje = (SELECT id_mensaje FROM Mensajes WHERE id_mensaje = 10 LIMIT 1);

--pero si eliminar el mensaje propio.
DELETE FROM Mensajes WHERE id_mensaje = 10;

-- Agrego un comentario a la publicacion con id = 100
INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido)
VALUES (100, 998, (SELECT id_usuario FROM public.usuarios WHERE username=current_user), 'comment de mila');

INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido)
VALUES (101, 101, 1, 'esto debería fallar');

-- Marco como favorita la publicacion con id = 100
INSERT INTO Favoritos (id_usuario, id_publicacion)
VALUES ((SELECT id_usuario FROM public.usuarios WHERE username=current_user), 998);