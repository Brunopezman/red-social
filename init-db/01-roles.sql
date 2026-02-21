-- Borrar si ya existen para evitar errores en reinicios de contenedor
DROP ROLE IF EXISTS admin_user;
DROP ROLE IF EXISTS app_user;
DROP ROLE IF EXISTS read_only_user;

CREATE ROLE admin_user WITH LOGIN PASSWORD 'admin123';

CREATE ROLE app_user WITH LOGIN PASSWORD 'user123';

CREATE ROLE read_only_user WITH LOGIN PASSWORD 'read123';
CREATE ROLE developer WITH LOGIN PASSWORD 'dev123';