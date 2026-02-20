-- 1. Permisos para el Usuario Común (user_role)
-- Solo puede ver y escribir, pero no borrar la estructura
GRANT CONNECT ON DATABASE red_social TO user_role;
GRANT USAGE ON SCHEMA public TO user_role;

-- Dar permiso de lectura (SELECT) y escritura (INSERT, UPDATE) en todas las tablas
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO user_role;

-- Dar permisos sobre las secuencias (necesario para los IDs autoincrementales)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user_role;

-- 2. Permisos para el Administrador (admin_role)
-- El admin sí puede borrar registros o alterar tablas si es necesario
GRANT CONNECT ON DATABASE red_social TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

-- 3. Revocar permisos al rol público (por seguridad)
REVOKE ALL ON DATABASE red_social FROM PUBLIC;

ALTER ROLE admin_role CREATEROLE;

-- Rol para crear roles
GRANT USAGE ON SCHEMA public TO admin_role;
GRANT CREATE ON SCHEMA public TO admin_role;
GRANT user_role TO admin_role WITH ADMIN OPTION;

------------------------------------------------------------
-- ASIGNAR DUEÑOS (todas las tablas → admin_role)
------------------------------------------------------------

ALTER TABLE Paises             OWNER TO admin_role;
ALTER TABLE Usuarios           OWNER TO admin_role;
ALTER TABLE Grupos             OWNER TO admin_role;
ALTER TABLE Publicaciones      OWNER TO admin_role;
ALTER TABLE Imagenes           OWNER TO admin_role;
ALTER TABLE Textos             OWNER TO admin_role;
ALTER TABLE Videos             OWNER TO admin_role;
ALTER TABLE Usuarios_Grupos    OWNER TO admin_role;
ALTER TABLE Comentarios        OWNER TO admin_role;
ALTER TABLE Amistades          OWNER TO admin_role;
ALTER TABLE Notificaciones     OWNER TO admin_role;
ALTER TABLE Mensajes           OWNER TO admin_role;
ALTER TABLE Favoritos          OWNER TO admin_role;

------------------------------------------------------------
-- ROW LEVEL SECURITY (RLS)
--    Activación + políticas específicas por tabla
------------------------------------------------------------

------------------------------------------------------------
-- Usuarios
------------------------------------------------------------
ALTER TABLE Usuarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY usuarios_select ON Usuarios
  FOR SELECT TO public USING (true);

CREATE POLICY usuarios_insert ON Usuarios
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY usuarios_update ON Usuarios
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY usuarios_delete ON Usuarios
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Grupos
------------------------------------------------------------
ALTER TABLE Grupos ENABLE ROW LEVEL SECURITY;

CREATE POLICY grupos_select ON Grupos
  FOR SELECT TO public USING (true);

CREATE POLICY grupos_insert ON Grupos
  FOR INSERT TO user_role
  WITH CHECK (id_creador = session_user);

CREATE POLICY grupos_update ON Grupos
  FOR UPDATE TO user_role
  USING (id_creador = session_user)
  WITH CHECK (id_creador = session_user);

CREATE POLICY grupos_delete ON Grupos
  FOR DELETE TO user_role
  USING (id_creador = session_user);


------------------------------------------------------------
-- Publicaciones
------------------------------------------------------------
ALTER TABLE Publicaciones ENABLE ROW LEVEL SECURITY;

CREATE POLICY publicaciones_select ON Publicaciones
  FOR SELECT TO public USING (true);

CREATE POLICY publicaciones_insert ON Publicaciones
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY publicaciones_update ON Publicaciones
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY publicaciones_delete ON Publicaciones
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Imagenes
------------------------------------------------------------
ALTER TABLE Imagenes ENABLE ROW LEVEL SECURITY;

CREATE POLICY imagenes_select ON Imagenes
  FOR SELECT TO public USING (true);

CREATE POLICY imagenes_insert ON Imagenes
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY imagenes_update ON Imagenes
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY imagenes_delete ON Imagenes
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Textos
------------------------------------------------------------
ALTER TABLE Textos ENABLE ROW LEVEL SECURITY;

CREATE POLICY textos_select ON Textos
  FOR SELECT TO public USING (true);

CREATE POLICY textos_insert ON Textos
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY textos_update ON Textos
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY textos_delete ON Textos
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Videos
------------------------------------------------------------
ALTER TABLE Videos ENABLE ROW LEVEL SECURITY;

CREATE POLICY videos_select ON Videos
  FOR SELECT TO public USING (true);

CREATE POLICY videos_insert ON Videos
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY videos_update ON Videos
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY videos_delete ON Videos
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Usuarios_Grupos
------------------------------------------------------------
ALTER TABLE Usuarios_Grupos ENABLE ROW LEVEL SECURITY;

CREATE POLICY ug_select ON Usuarios_Grupos
  FOR SELECT TO public USING (true);

CREATE POLICY ug_insert ON Usuarios_Grupos
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY ug_delete ON Usuarios_Grupos
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Comentarios
------------------------------------------------------------
ALTER TABLE Comentarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY comentarios_select ON Comentarios
  FOR SELECT TO public USING (true);

CREATE POLICY comentarios_insert ON Comentarios
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY comentarios_update ON Comentarios
  FOR UPDATE TO user_role
  USING (nombre_usuario = session_user)
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY comentarios_delete ON Comentarios
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);


------------------------------------------------------------
-- Amistades
------------------------------------------------------------
ALTER TABLE Amistades ENABLE ROW LEVEL SECURITY;

CREATE POLICY amistades_select ON Amistades
  FOR SELECT TO user_role
  USING (
    session_user = nombre_usuario_1 OR
    session_user = nombre_usuario_2
  );

CREATE POLICY amistades_insert ON Amistades
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario_1 = session_user);

CREATE POLICY amistades_update ON Amistades
  FOR UPDATE TO user_role
  USING (
    session_user = nombre_usuario_1 OR
    session_user = nombre_usuario_2
  )
  WITH CHECK (
    session_user = nombre_usuario_1 OR
    session_user = nombre_usuario_2
  );

CREATE POLICY amistades_delete ON Amistades
  FOR DELETE TO user_role
  USING (
    session_user = nombre_usuario_1 OR
    session_user = nombre_usuario_2
  );


------------------------------------------------------------
-- Notificaciones
------------------------------------------------------------
ALTER TABLE Notificaciones ENABLE ROW LEVEL SECURITY;

CREATE POLICY notificaciones_select ON Notificaciones
  FOR SELECT TO user_role
  USING (nombre_usuario_destino = session_user);

CREATE POLICY notificaciones_insert ON Notificaciones
  FOR INSERT TO user_role
  WITH CHECK (true);

CREATE POLICY notificaciones_update ON Notificaciones
  FOR UPDATE TO user_role
  USING (nombre_usuario_destino = session_user)
  WITH CHECK (nombre_usuario_destino = session_user);

CREATE POLICY notificaciones_delete ON Notificaciones
  FOR DELETE TO user_role
  USING (nombre_usuario_destino = session_user);


------------------------------------------------------------
-- Mensajes
------------------------------------------------------------
ALTER TABLE Mensajes ENABLE ROW LEVEL SECURITY;

CREATE POLICY mensajes_select ON Mensajes
  FOR SELECT TO user_role
  USING (
    session_user = nombre_usuario_emisor OR
    session_user = nombre_usuario_receptor
  );

CREATE POLICY mensajes_insert ON Mensajes
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario_emisor = session_user);

CREATE POLICY mensajes_update ON Mensajes
  FOR UPDATE TO user_role
  USING (
    session_user = nombre_usuario_emisor OR
    session_user = nombre_usuario_receptor
  )
  WITH CHECK (
    session_user = nombre_usuario_emisor OR
    session_user = nombre_usuario_receptor
  );

CREATE POLICY mensajes_delete ON Mensajes
  FOR DELETE TO user_role
  USING (
    session_user = nombre_usuario_emisor OR
    session_user = nombre_usuario_receptor
  );


------------------------------------------------------------
-- Favoritos
------------------------------------------------------------
ALTER TABLE Favoritos ENABLE ROW LEVEL SECURITY;

CREATE POLICY fav_select ON Favoritos
  FOR SELECT TO public USING (true);

CREATE POLICY fav_insert ON Favoritos
  FOR INSERT TO user_role
  WITH CHECK (nombre_usuario = session_user);

CREATE POLICY fav_delete ON Favoritos
  FOR DELETE TO user_role
  USING (nombre_usuario = session_user);