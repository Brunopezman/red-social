CREATE ROLE role_admin   NOLOGIN;
CREATE ROLE role_usuario NOLOGIN;
DROP ROLE IF EXISTS role_admin;
DROP ROLE IF EXISTS role_usuario;

-- app_admin has all permissions, app_user only queries + inserts
--GRANT role_admin   TO app_admin;
--GRANT role_usuario TO app_user;

GRANT USAGE ON SCHEMA public TO role_usuario;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_usuario;
GRANT INSERT ON TABLE public.publicaciones TO role_usuario;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_usuario;

ALTER TABLE Publicaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE Mensajes      ENABLE ROW LEVEL SECURITY;
ALTER TABLE Grupos        ENABLE ROW LEVEL SECURITY;
ALTER TABLE Comentarios   ENABLE ROW LEVEL SECURITY;
ALTER TABLE Favoritos     ENABLE ROW LEVEL SECURITY;


CREATE POLICY pub_select_all ON Publicaciones
  FOR SELECT USING (TRUE);


CREATE POLICY pub_insert_own ON Publicaciones
  FOR INSERT TO role_usuario
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM Usuarios u
      WHERE u.id_usuario = Publicaciones.id_usuario
        AND u.username = CURRENT_USER
    )
  );

CREATE POLICY pub_update_own
  ON Publicaciones
  FOR UPDATE TO role_usuario
  USING (
    EXISTS (
      SELECT 1 FROM Usuarios u
      WHERE u.id_usuario = Publicaciones.id_usuario
        AND u.username = CURRENT_USER
    )
  );

CREATE POLICY pub_delete_own
  ON Publicaciones
  FOR DELETE TO role_usuario
  USING (
    EXISTS (
      SELECT 1 FROM Usuarios u
      WHERE u.id_usuario = Publicaciones.id_usuario
        AND u.username = CURRENT_USER
    )
  );

/*
CREATE POLICY msg_select_own ON Mensajes
  FOR SELECT TO role_usuario
  USING (
    EXISTS (SELECT 1 FROM Usuarios u WHERE u.id_usuario = Mensajes.id_usuario_emisor   AND u.username = CURRENT_USER)
    OR
    EXISTS (SELECT 1 FROM Usuarios u WHERE u.id_usuario = Mensajes.id_usuario_receptor AND u.username = CURRENT_USER)
  );

CREATE POLICY msg_insert_emisor ON Mensajes
  FOR INSERT TO role_usuario
  WITH CHECK (
    EXISTS (SELECT 1 FROM Usuarios u WHERE u.id_usuario = Mensajes.id_usuario_emisor AND u.username = CURRENT_USER)
  );

CREATE POLICY msg_modify_emisor ON Mensajes
  FOR UPDATE, DELETE TO role_usuario
  USING (
    EXISTS (SELECT 1 FROM Usuarios u WHERE u.id_usuario = Mensajes.id_usuario_emisor AND u.username = CURRENT_USER)
  );
*/