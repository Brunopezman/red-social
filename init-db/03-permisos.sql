-- ===========================
-- Crear roles/usuarios
-- ===========================
CREATE ROLE admin_role WITH NOLOGIN;
CREATE ROLE user_role WITH NOLOGIN;

-- ===========================
-- Permisos para admin_user (full access)
-- ===========================
GRANT ALL PRIVILEGES ON SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

-- ===========================
-- Permisos para app_user
-- ===========================
GRANT USAGE ON SCHEMA public TO user_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user_role;

-- Permisos de LECTURA (SELECT) en todas las tablas.
-- La seguridad de qué filas puede ver se controla con RLS.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user_role;
GRANT USAGE ON SCHEMA public TO user_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user_role;
-- Permisos de ESCRITURA (INSERT)
GRANT INSERT ON public.Publicaciones, Grupos, Usuarios_Grupos, Mensajes, Amistades, Comentarios, Favoritos TO user_role;

-- Permisos de MODIFICACIÓN (UPDATE)
-- El usuario solo podrá actualizar sus propias publicaciones, comentarios, etc. (controlado por RLS)
GRANT UPDATE ON Publicaciones, Comentarios, Mensajes TO user_role;

-- Permisos de BORRADO (DELETE)
-- El usuario solo podrá borrar su propio contenido (controlado por RLS)
GRANT DELETE ON Publicaciones, Comentarios, Mensajes, Favoritos, Usuarios_Grupos, Amistades, Usuarios TO user_role;

-- =====================================================================
-- 4. ACTIVACIÓN DE SEGURIDAD A NIVEL DE FILA (ROW-LEVEL SECURITY - RLS)
-- Se activa RLS en las tablas que contienen datos privados de los usuarios.
-- =====================================================================
ALTER TABLE public.publicaciones ENABLE ROW LEVEL SECURITY;
--ALTER TABLE Publicaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE Mensajes ENABLE ROW LEVEL SECURITY;
ALTER TABLE Comentarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Favoritos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Usuarios_Grupos ENABLE ROW LEVEL SECURITY;
ALTER TABLE Amistades ENABLE ROW LEVEL SECURITY;
ALTER TABLE Usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE Notificaciones ENABLE ROW LEVEL SECURITY;

-- =====================================================================
-- 5. CREACIÓN DE POLÍTICAS DE SEGURIDAD
-- Las políticas definen QUÉ FILAS puede ver o modificar un usuario.
-- =====================================================================

-- Políticas para PUBLICACIONES
CREATE POLICY pub_select_all ON public.Publicaciones FOR SELECT USING (TRUE);
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
-- ===========================
-- Asegurarse de que futuras tablas tengan permisos automáticos
-- ===========================
--ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO user_role;
--ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin_role;
