
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (22, 'milamantilla', 'milanesa@gmail.com', '2003-02-17', 'Mila', 'Nesa', 'Argentina');

CREATE USER milamantilla WITH LOGIN PASSWORD 'securepass123';
GRANT user_rol TO milamantilla;

CREATE USER admin_app WITH LOGIN PASSWORD 'adminpass123';
GRANT admin_rol TO admin_app;

SET ROLE milamantilla;
SELECT id_usuario, username
FROM public.usuarios
WHERE username = current_role;      -- debe devolver 1 fila, p. ej. 22 / 'milamantilla'

SET ROLE milamantilla;
INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo, url, contenido, cantidad_de_likes)
VALUES (999, 22, NULL, 'http://post11.com', 'Esta es mi nueva publicación de prueba.', 1);

UPDATE Publicaciones SET contenido = 'Mi contenido actualizado.' WHERE id_publicacion = 999;

DELETE FROM Publicaciones WHERE id_publicacion = 999;

UPDATE Publicaciones SET contenido = 'Intento de modificar algo ajeno.'
WHERE id_publicacion = (SELECT id_publicacion FROM Publicaciones WHERE id_usuario = 2 LIMIT 1);

DELETE FROM Publicaciones
WHERE id_publicacion = (SELECT id_publicacion FROM Publicaciones WHERE id_usuario = 22 LIMIT 1);

INSERT INTO Mensajes (id_mensaje, id_usuario_emisor, id_usuario_receptor, contenido)
VALUES (100, 22, 1, 'Hola mjuarez, soy milamantilla');
-- este insert no se puede hacer porque el emisor no coincide con el user actual (milamantilla)(101, 22, 4, 'Mensaje secreto para Carla Dominguez');
-- asimismo no puedo eliminar un mensaje con el rol de milamantilla si el emisor no coincide. La política no permitirá borrar un mensaje que no enviaste
DELETE FROM mensajes
WHERE id_mensaje = (SELECT id_mensaje FROM Mensajes WHERE id_mensaje = 10 LIMIT 1);

DELETE FROM Usuarios WHERE username = 'lcastro';

SELECT id_usuario_emisor, id_usuario_receptor, contenido
FROM public.mensajes;

SELECT CURRENT_USER;
UPDATE Mensajes SET contenido = 'editado por emisor'
WHERE id_mensaje = 100;

--Las politicas propuestas no permiten modificar los mensajes propios.
UPDATE Mensajes SET contenido = 'editado por emisor'
WHERE id_mensaje = (SELECT id_mensaje FROM Mensajes WHERE id_mensaje = 2 LIMIT 1);
--pero si eliminar el mensaje (propio obvio).
DELETE FROM Mensajes WHERE id_mensaje = 100;
DELETE FROM Mensajes WHERE id_mensaje = 2;

INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido)
VALUES (100, 101, (SELECT id_usuario FROM public.usuarios WHERE username=current_role), 'comment de mila');

INSERT INTO Comentarios (id_comentario, id_publicacion, id_usuario, contenido)
VALUES (101, 101, 1, 'esto debería fallar');

INSERT INTO Favoritos (id_usuario, id_publicacion)
VALUES ((SELECT id_usuario FROM public.usuarios WHERE username=current_role), 101);

INSERT INTO public.favoritos (id_usuario, id_publicacion)
VALUES (1, 101);