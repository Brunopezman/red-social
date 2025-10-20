
INSERT INTO Usuarios (id_usuario, username, email, fecha_de_nacimiento, nombre, apellido, pais)
VALUES (22, 'milamantilla', 'milanesa@gmail.com', '2003-02-17', 'Mila', 'Nesa', 'Argentina');


CREATE USER milamantilla WITH LOGIN PASSWORD 'securepass123';
GRANT user_role TO milamantilla;


CREATE USER admin_app WITH LOGIN PASSWORD 'adminpass123';
GRANT admin_role TO admin_app;

SET ROLE milamantilla;

SELECT session_user, current_user, current_role;
SELECT id_usuario, username
FROM public.usuarios
WHERE username = current_role;      -- debe devolver 1 fila, p. ej. 22 / 'milamantilla'

SET ROLE milamantilla;
INSERT INTO Publicaciones (id_publicacion, id_usuario, id_grupo, url, contenido, cantidad_de_likes)
VALUES (999, 22, NULL, 'http://post11.com', 'Esta es mi nueva publicación de prueba.', 0);

UPDATE Publicaciones SET contenido = 'Mi contenido actualizado.' WHERE id_publicacion = 999;

DELETE FROM Publicaciones WHERE id_publicacion = 999;

UPDATE Publicaciones SET contenido = 'Intento de modificar algo ajeno.'
WHERE id_publicacion = (SELECT id_publicacion FROM Publicaciones WHERE id_usuario = 2 LIMIT 1);

DELETE FROM Publicaciones
WHERE id_publicacion = (SELECT id_publicacion FROM Publicaciones WHERE id_usuario = 2 LIMIT 1);