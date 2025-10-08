-- Crear roles
CREATE ROLE app_admin LOGIN PASSWORD 'admin123';
CREATE ROLE app_user LOGIN PASSWORD 'user123';


-- Permisos del administrador (puede hacer todo)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_admin;



-- Permisos del usuario 
GRANT SELECT, INSERT, UPDATE, DELETE ON 
    Usuarios,
    Publicaciones,
    Textos,
    Imagenes,
    Videos,
    Favoritos,
    Comentarios
TO app_user;


-- Puede leer información (no modificar)
GRANT SELECT ON 
    Grupos,
    Pais
TO app_user;