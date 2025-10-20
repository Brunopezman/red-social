-- ===========================
-- Crear roles/usuarios
-- ===========================
CREATE ROLE admin_user WITH LOGIN PASSWORD 'admin_pass';
CREATE ROLE app_user WITH LOGIN PASSWORD 'app_pass';
CREATE ROLE readonly_user WITH LOGIN PASSWORD 'readonly_pass';

-- ===========================
-- Permisos para admin_user (full access)
-- ===========================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;

-- ===========================
-- Permisos para app_user (lectura y escritura)
-- ===========================
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO app_user;

-- ===========================
-- Permisos para readonly_user (solo lectura)
-- ===========================
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO readonly_user;

-- ===========================
-- Asegurarse de que futuras tablas tengan permisos automáticos
-- ===========================
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin_user;
