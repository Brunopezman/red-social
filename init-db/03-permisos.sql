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

-- ===========================
-- Permisos para user_role
-- ===========================
GRANT USAGE ON SCHEMA public TO user_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user_role;

-- Permisos de LECTURA (SELECT) en todas las tablas.
-- La seguridad de qué filas puede ver se controla con RLS.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user_role;
-- Permisos de ESCRITURA (INSERT)
GRANT INSERT ON Publicaciones, Imagenes, Videos, Textos, Grupos, Mensajes, Notificaciones_Amistad, Comentarios, Favoritos TO user_role;

-- Permisos de MODIFICACIÓN (UPDATE)
-- El usuario solo podrá actualizar sus propias publicaciones, comentarios, etc. (controlado por RLS)
GRANT UPDATE ON Imagenes, Videos, Textos, Notificaciones_Amistad, Comentarios, Mensajes TO user_role;

-- Permisos de BORRADO (DELETE)
-- El usuario solo podrá borrar su propio contenido (controlado por RLS)
GRANT DELETE ON Publicaciones, Imagenes, Videos, Textos, Notificaciones_Amistad, Comentarios, Mensajes, Favoritos, Usuarios_Grupos, Usuarios TO user_role;

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
ALTER TABLE Amistades ENABLE ROW LEVEL SECURITY;
ALTER TABLE Usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Notificaciones_Amistad ENABLE ROW LEVEL SECURITY;

-- =====================================================================
-- 5. CREACIÓN DE POLÍTICAS DE SEGURIDAD
-- Las políticas definen QUÉ FILAS puede ver o modificar un usuario.
-- =====================================================================

-- Políticas para PUBLICACIONES
CREATE POLICY pub_select_all ON public.Publicaciones FOR SELECT USING (TRUE);
-- Insert: trigger inserta la fila con el mismo id_usuario del que inserta en Texto/Imagen/Video
CREATE POLICY pub_insert_own ON public.Publicaciones FOR INSERT TO user_role
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.usuarios u
      WHERE u.id_usuario = public.publicaciones.id_usuario
        AND u.username   = CURRENT_USER
    )
  );
CREATE POLICY pub_update_own ON public.Publicaciones FOR UPDATE USING (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY pub_delete_own ON public.Publicaciones FOR DELETE USING (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));

--Políticas para TEXTOS

CREATE POLICY txt_select
  ON public.textos
  FOR SELECT TO user_role
  USING (TRUE);

-- Insertar / Actualizar / Borrar solo el propietario
CREATE POLICY txt_insert
  ON public.textos
  FOR INSERT TO user_role
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.textos.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY txt_update
  ON public.textos
  FOR UPDATE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.textos.id_usuario
                   AND u.username   = CURRENT_ROLE))
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.textos.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY txt_delete
  ON public.textos
  FOR DELETE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.textos.id_usuario
                   AND u.username   = CURRENT_ROLE));
-- IMAGENES
CREATE POLICY img_select
  ON public.imagenes
  FOR SELECT TO user_role
  USING (TRUE);

-- Insertar / Actualizar / Borrar solo el propietario
CREATE POLICY img_insert
  ON public.imagenes
  FOR INSERT TO user_role
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.imagenes.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY img_update
  ON public.imagenes
  FOR UPDATE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.imagenes.id_usuario
                   AND u.username   = CURRENT_ROLE))
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.imagenes.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY img_delete
  ON public.imagenes
  FOR DELETE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.imagenes.id_usuario
                   AND u.username   = CURRENT_ROLE));

CREATE POLICY video_insert
  ON public.videos
  FOR INSERT TO user_role
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.videos.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY video_update
  ON public.videos
  FOR UPDATE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.videos.id_usuario
                   AND u.username   = CURRENT_ROLE))
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u
                      WHERE u.id_usuario = public.videos.id_usuario
                        AND u.username   = CURRENT_ROLE));

CREATE POLICY video_delete
  ON public.videos
  FOR DELETE TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u
                 WHERE u.id_usuario = public.videos.id_usuario
                   AND u.username   = CURRENT_ROLE));


-- Políticas para AMISTADES

CREATE POLICY na_select_own
  ON public.notificaciones_amistad
  FOR SELECT TO user_role
  USING (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND (u.id_usuario = public.notificaciones_amistad.id_usuario_solicitante
                   OR u.id_usuario = public.notificaciones_amistad.id_usuario_receptor))
  );

-- Insertar: sólo si YO soy el solicitante
CREATE POLICY na_insert
  ON public.notificaciones_amistad
  FOR INSERT TO user_role
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND u.id_usuario = public.notificaciones_amistad.id_usuario_solicitante)
    AND public.notificaciones_amistad.id_usuario_solicitante
        <> public.notificaciones_amistad.id_usuario_receptor
  );
-- Actualizar: sólo el RECEPTOR puede cambiar estado ('pendiente' -> 'aceptada'/'rechazada')
CREATE POLICY na_update_resp
  ON public.notificaciones_amistad
  FOR UPDATE TO user_role
  USING (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND u.id_usuario = public.notificaciones_amistad.id_usuario_receptor)
  )
  WITH CHECK (
    -- misma condición del USING y además forzar transición de estado
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND u.id_usuario = public.notificaciones_amistad.id_usuario_receptor)
    AND public.notificaciones_amistad.estado IN ('pendiente','aceptada','rechazada')
  );

CREATE POLICY na_admin_all
  ON public.notificaciones_amistad
  FOR ALL TO admin_role
  USING (TRUE) WITH CHECK (TRUE);

CREATE POLICY am_select_own
  ON public.amistades
  FOR SELECT TO user_role
  USING (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND (u.id_usuario = public.amistades.id_usuario1
                   OR u.id_usuario = public.amistades.id_usuario2))
  );

-- Insert/Delete: sólo si soy uno de los dos (el insert real lo hará tu lógica/trigger)
CREATE POLICY am_insert_own
  ON public.amistades
  FOR INSERT TO user_role
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND (u.id_usuario = public.amistades.id_usuario1
                   OR u.id_usuario = public.amistades.id_usuario2))
  );

CREATE POLICY am_delete_own
  ON public.amistades
  FOR DELETE TO user_role
  USING (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.username = CURRENT_ROLE
              AND (u.id_usuario = public.amistades.id_usuario1
                   OR u.id_usuario = public.amistades.id_usuario2))
  );
-- Políticas para MENSAJES
CREATE POLICY msg_select_own ON Mensajes FOR SELECT USING (
    id_usuario_emisor = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER) OR
    id_usuario_receptor = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER)
);
CREATE POLICY msg_insert_own ON Mensajes FOR INSERT WITH CHECK (id_usuario_emisor = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY msg_delete_own ON Mensajes FOR DELETE USING (id_usuario_emisor = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para COMENTARIOS
CREATE POLICY com_select_all ON Comentarios FOR SELECT USING (TRUE);
CREATE POLICY com_insert_own ON Comentarios FOR INSERT WITH CHECK (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY com_delete_own ON Comentarios FOR DELETE USING (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para FAVORITOS
CREATE POLICY fav_select_all ON Favoritos FOR SELECT USING (TRUE);
CREATE POLICY fav_insert_own ON Favoritos FOR INSERT WITH CHECK (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));
CREATE POLICY fav_delete_own ON Favoritos FOR DELETE USING (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));

-- Políticas para USUARIOS (Para permitir que un usuario se elimine a sí mismo)
CREATE POLICY user_select_all ON Usuarios FOR SELECT USING (TRUE);
CREATE POLICY user_delete_own ON Usuarios FOR DELETE USING (id_usuario = (SELECT id_usuario FROM Usuarios WHERE username = CURRENT_USER));

CREATE POLICY ug_select_own
  ON public.usuarios_grupos
  FOR SELECT TO user_role
  USING (
    EXISTS (
      SELECT 1 FROM public.usuarios u
      WHERE u.id_usuario = public.usuarios_grupos.id_usuario
        AND u.username   = CURRENT_USER
    )
  );

CREATE POLICY ug_insert_own
  ON public.usuarios_grupos
  FOR INSERT TO user_role
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.usuarios u
      WHERE u.id_usuario = public.usuarios_grupos.id_usuario
        AND u.username   = CURRENT_USER
    )
  );

-- Permitir que cada uno se BORRE a sí mismo del grupo
CREATE POLICY ug_delete_own
  ON public.usuarios_grupos
  FOR DELETE TO user_role
  USING (
    EXISTS (
      SELECT 1 FROM public.usuarios u
      WHERE u.id_usuario = public.usuarios_grupos.id_usuario
        AND u.username   = CURRENT_USER
    )
  );

CREATE POLICY noti_select_own ON public.notificaciones
  FOR SELECT TO user_role
  USING (EXISTS (SELECT 1 FROM public.usuarios u WHERE u.id_usuario = public.notificaciones.id_usuario AND u.username = CURRENT_ROLE));

CREATE POLICY noti_insert_own ON public.notificaciones
  FOR INSERT TO user_role
  WITH CHECK (EXISTS (SELECT 1 FROM public.usuarios u WHERE u.id_usuario = public.notificaciones.id_usuario AND u.username = CURRENT_ROLE));

CREATE POLICY noti_select_own
  ON public.notificaciones
  FOR SELECT TO user_role
  USING (
    EXISTS (SELECT 1 FROM public.usuarios u
            WHERE u.id_usuario = public.notificaciones.id_usuario
              AND u.username   = CURRENT_ROLE)
  );

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
