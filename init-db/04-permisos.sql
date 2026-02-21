-- OTORGAR PERMISOS SEGÚN EL ROL

-- Permisos para el Desarrollador (Acceso total en el esquema público)
GRANT ALL PRIVILEGES ON SCHEMA public TO developer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO developer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO developer;

-- Permisos para el App User (DML: Insertar, Actualizar, Borrar, Seleccionar)
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;

-- Permisos para Read Only (Solo consultas)
GRANT USAGE ON SCHEMA public TO read_only_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only_user;

-- IMPORTANTE: Asegurar permisos para futuras tablas que se creen
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO read_only_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO developer;