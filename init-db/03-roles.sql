-- Creamos los roles (asegúrate de que las variables coincidan con tu .env o cámbialas por valores fijos aquí)
CREATE ROLE admin_role LOGIN PASSWORD 'admin123';
CREATE ROLE user_role LOGIN PASSWORD 'username123';

-- Permisos de conexión básicos
GRANT CONNECT ON DATABASE red_social TO user_role;
GRANT CONNECT ON DATABASE red_social TO admin_role;