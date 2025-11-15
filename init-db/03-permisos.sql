-- ===========================
-- Crear roles/usuarios
-- ===========================
CREATE ROLE admin_role WITH NOLOGIN;
CREATE ROLE user_role WITH NOLOGIN;
-- ===========================
-- Permisos para admin_role (full access)
-- ===========================
GRANT ALL PRIVILEGES ON SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

-- ============================================
-- Permisos para user_role
-- ============================================
GRANT USAGE ON SCHEMA public TO user_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user_role;

-- Lectura general (las políticas controlan qué filas)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user_role;

-- Insertar contenido propio
GRANT INSERT ON Publicaciones, Imagenes, Videos, Textos,
    Grupos, Mensajes, Comentarios, Favoritos
TO user_role;

-- UPDATE solo sobre tablas donde edita lo suyo:
GRANT UPDATE ON Imagenes, Videos, Textos, Comentarios, Mensajes
TO user_role;

-- DELETE solo de lo propio (RLS se encarga)
GRANT DELETE ON Publicaciones, Imagenes, Videos, Textos,
    Comentarios, Mensajes, Favoritos, Usuarios_Grupos, Usuarios
TO user_role;


-- =====================================================================
-- 4. ACTIVACIÓN DE SEGURIDAD A NIVEL DE FILA (ROW-LEVEL SECURITY - RLS)
-- Se activa RLS en las tablas que contienen datos privados de los usuarios.
-- =====================================================================
ALTER TABLE Publicaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE Imagenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE Textos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Mensajes ENABLE ROW LEVEL SECURITY;
ALTER TABLE Comentarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Favoritos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Usuarios_Grupos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Grupos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Amistades ENABLE ROW LEVEL SECURITY;
ALTER TABLE Usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Notificaciones ENABLE ROW LEVEL SECURITY;

-- =====================================================================
-- 5. CREACIÓN DE POLÍTICAS DE SEGURIDAD
-- Las políticas definen QUÉ FILAS puede ver o modificar un usuario.
-- =====================================================================

-- Políticas para PUBLICACIONES
CREATE POLICY pub_select_all ON Publicaciones
  FOR SELECT USING (TRUE);

CREATE POLICY pub_insert_own ON Publicaciones
  FOR INSERT TO user_role
  WITH CHECK (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY pub_update_own ON Publicaciones
  FOR UPDATE TO user_role
  USING (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  )
  WITH CHECK (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY pub_delete_own ON Publicaciones
  FOR DELETE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

--Políticas para TEXTOS

CREATE POLICY txt_select ON Textos FOR SELECT USING (TRUE);

CREATE POLICY txt_insert ON Textos FOR INSERT TO user_role
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY txt_update ON Textos FOR UPDATE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER))
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY txt_delete ON Textos FOR DELETE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));


-- IMAGENES
CREATE POLICY img_select ON Imagenes FOR SELECT USING (TRUE);

CREATE POLICY img_insert ON Imagenes FOR INSERT TO user_role
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY img_update ON Imagenes FOR UPDATE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER))
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY img_delete ON Imagenes FOR DELETE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

-- VIDEOS

CREATE POLICY vid_select ON Videos FOR SELECT USING (TRUE);

CREATE POLICY vid_insert ON Videos FOR INSERT TO user_role
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY vid_update ON Videos FOR UPDATE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER))
  WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY vid_delete ON Videos FOR DELETE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));


-- Políticas para AMISTADES

CREATE POLICY am_select_own
  ON Amistades FOR SELECT TO user_role
  USING (
    (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
      IN (username_1, username_2)
  );

CREATE POLICY am_insert_own
  ON Amistades FOR INSERT TO user_role
  WITH CHECK (
    (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
      IN (username_1, username_2)
  );

CREATE POLICY am_delete_own
  ON Amistades FOR DELETE TO user_role
  USING (
    (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
      IN (username_1, username_2)
  );
-- para USUARIOS_GRUPOS
CREATE POLICY ug_select_own ON Usuarios_Grupos
  FOR SELECT TO user_role
  USING (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY ug_insert_own ON Usuarios_Grupos
  FOR INSERT TO user_role
  WITH CHECK (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY ug_delete_own ON Usuarios_Grupos
  FOR DELETE TO user_role
  USING (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

-- para NOTIFICACIONES
CREATE POLICY noti_select_own ON Notificaciones
  FOR SELECT TO user_role
  USING (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY noti_insert_own ON Notificaciones
  FOR INSERT TO user_role
  WITH CHECK (
    username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
  );

CREATE POLICY noti_admin_all ON Notificaciones
  FOR ALL TO admin_role
  USING (TRUE) WITH CHECK (TRUE);

-- Políticas para MENSAJES
CREATE POLICY msg_select_own ON Mensajes FOR SELECT USING (
    username_emisor = (SELECT username FROM Usuarios WHERE username = CURRENT_USER) OR
    username_receptor = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
);
CREATE POLICY msg_insert_own ON Mensajes FOR INSERT WITH CHECK (username_emisor = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY msg_delete_own ON Mensajes FOR DELETE USING (username_emisor = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para COMENTARIOS
CREATE POLICY com_select_all ON Comentarios FOR SELECT USING (TRUE);
CREATE POLICY com_insert_own ON Comentarios FOR INSERT WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY com_delete_own ON Comentarios FOR DELETE USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para FAVORITOS
CREATE POLICY fav_select_all ON Favoritos FOR SELECT USING (TRUE);
CREATE POLICY fav_insert_own ON Favoritos FOR INSERT WITH CHECK (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY fav_delete_own ON Favoritos FOR DELETE USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para USUARIOS (Para permitir que un usuario se elimine a sí mismo)
CREATE POLICY user_select_all ON Usuarios FOR SELECT USING (TRUE);
CREATE POLICY user_delete_own ON Usuarios FOR DELETE USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY ug_select_own
  ON public.usuarios_grupos
  FOR SELECT TO user_role
  USING (
    EXISTS (
      SELECT 1 FROM public.usuarios u
      WHERE u.username = public.usuarios_grupos.username
        AND u.username   = CURRENT_USER
    )
  );

CREATE POLICY ug_insert_own
  ON public.usuarios_grupos
  FOR INSERT TO user_role
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.usuarios u
      WHERE u.username = public.usuarios_grupos.username
        AND u.username   = CURRENT_USER
    )
  );

ALTER TABLE Grupos ENABLE ROW LEVEL SECURITY;

-- Todos pueden ver los grupos
CREATE POLICY grp_select_all ON Grupos
    FOR SELECT
    USING (TRUE);

-- Cualquier usuario puede crear grupos
CREATE POLICY grp_insert_any ON Grupos
    FOR INSERT TO user_role
    WITH CHECK (
        id_creador = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
    );

-- Solo el creador puede modificar su grupo
CREATE POLICY grp_update_own ON Grupos
    FOR UPDATE TO user_role
    USING (
        id_creador = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
    )
    WITH CHECK (
        id_creador = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
    );

-- Solo el creador puede eliminar su grupo
CREATE POLICY grp_delete_own ON Grupos
    FOR DELETE TO user_role
    USING (
        id_creador = (SELECT username FROM Usuarios WHERE username = CURRENT_USER)
    );

-- admin puede todo
CREATE POLICY grp_admin_all ON Grupos
    FOR ALL TO admin_role
    USING (TRUE)
    WITH CHECK (TRUE);

-- Permitir que cada uno se BORRE a sí mismo del grupo
CREATE POLICY user_select_all ON Usuarios FOR SELECT USING (TRUE);

CREATE POLICY user_delete_own ON Usuarios
  FOR DELETE TO user_role
  USING (username = (SELECT username FROM Usuarios WHERE username = CURRENT_USER));


CREATE POLICY noti_insert_admin ON Notificaciones
  FOR INSERT TO admin_role
  WITH CHECK (TRUE);

CREATE POLICY noti_select_admin ON Notificaciones
  FOR SELECT TO admin_role
  USING (TRUE);

-- ===========================
-- Asegurarse de que futuras tablas tengan permisos automáticos
-- ===========================
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO user_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin_role;
