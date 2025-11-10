# modelo relacional

Paises(<span style="text-decoration: underline"> nombre_pais </span>)

- PK -> nombre_pais
- FK -> ninguno
- Claves candidatas -> nombre_pais

Usuarios( <span style="text-decoration: underline">id_usuario</span>, username, email, fecha_de_alta, fecha_de_nacimiento,nombre, apellido, <span style="border-bottom: 1px dotted;">nombre_pais</span>, cantidad_de_ingresos)

- PK -> id_usuario
- FK -> nombre_pais
- Claves candidatas -> id_usuario, username, email


Publicaciones(<span style="text-decoration: underline">id_publicaciones</span>, <span style="border-bottom: 1px dotted;">id_grupo</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>)

- PK -> id_publicaciones
- FK -> id_grupo, id_usuario
- Claves candidatas -> id_publicaciones


Imagenes(<span style="text-decoration: underline">id_publicaciones</span>, <span style="border-bottom: 1px dotted;">id_grupo</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>,url_imagen)

- PK -> id_publicaciones
- FK -> id_grupo, id_usuario
- Claves candidatas -> id_publicaciones

Videos(<span style="text-decoration: underline">id_publicaciones</span>, contenido, <span style="border-bottom: 1px dotted;">id_grupo</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>, url_video, duracion, calidad)

- PK -> id_publicaciones
- FK -> id_grupo, id_usuario
- Claves candidatas -> id_publicaciones

Textos(<span style="text-decoration: underline">id_publicaciones</span>, contenido, <span style="border-bottom: 1px dotted;">id_grupo</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>, texto)

- PK -> id_publicaciones
- FK -> id_grupo, id_usuario
- Claves candidatas -> id_publicaciones

Grupos(<span style="text-decoration: underline">id_grupo</span>, nombre_grupo, descripcion, fecha_de_creacion)

- PK -> id_grupo
- FK -> ninguno
- Claves candidatas -> id_grupo, nombre_grupo

UsuariosGrupos(<span style="text-decoration: underline">id_grupo</span>, <span style="border-bottom: 1px dotted;"><span style="text-decoration: underline"> id_usuario </span></span>, fecha_de_ingreso)

- PK -> id_grupo, id_usuario
- FK -> id_grupo, id_usuario
- Claves candidatas -> id_grupo, id_usuario

Comentarios(<span style="text-decoration: underline">id_comentario</span>, contenido, <span style="border-bottom: 1px dotted;">id_usuario</span>, <span style="border-bottom: 1px dotted;">id_publicacion</span>)

- PK -> id_comentario
- FK -> id_usuario, id_publicacion
- Claves candidatas -> id_comentario

Amistades(<span style="text-decoration: underline"><span style="border-bottom: 1px dotted;">id_usuario1</span>, <span style="border-bottom: 1px dotted;">id_usuario2</span></span>, fecha_de_amistad)

- PK -> id_usuario1, id_usuario2
- FK -> id_usuario1, id_usuario2
- Claves candidatas -> id_usuario1, id_usuario2

Notificaciones(<span style="text-decoration: underline">id_notificacion</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>)

- PK -> id_notificacion
- FK -> id_usuario
- Claves candidatas -> id_notificacion

NotificacionesDeAmistad(<span style="text-decoration: underline">id_notificacion</span>, <span style="border-bottom: 1px dotted;">id_usuario_solicitante</span>,<span style="border-bottom: 1px dotted;">id_usuario_receptor</span>, fecha_solicitud, estado)

- PK -> id_notificacion
- FK -> id_usuario_solicitante, id_usuario_receptor
- Claves candidatas -> id_notificacion


NotificacionesDePublicacion(<span style="text-decoration: underline">id_notificacion</span>, <span style="border-bottom: 1px dotted;">id_usuario</span>,, <span style="border-bottom: 1px dotted;">id_publicacion</span>,tipo)

- PK -> id_notificacion
- FK -> id_usuario, id_publicacion
- Claves candidatas -> id_notificacion


NotificacionesDeGrupos(<span style="text-decoration: underline">id_notificacion</span>, <span style="border-bottom: 1px dotted;">id_grupo</span>, mensaje)

- PK -> id_notificacion
- FK -> id_grupo
- Claves candidatas -> id_notificacion

mensajes( <span style="text-decoration: underline"> id_mensaje</span>, estado, contenido, fecha_de_envio, <span style="border-bottom: 1px dotted;">id_usuario_emisor</span>, <span style="border-bottom: 1px dotted;">id_usuario_receptor</span>)

- PK -> id_mensaje
- FK -> id_usuario_emisor, id_usuario_receptor
- Claves candidatas -> id_mensaje

favoritos(<span style="text-decoration: underline"> <span style="border-bottom: 1px dotted;">id_usuario</span>, <span style="border-bottom: 1px dotted;">id_publicacion</span></span>)

- PK -> id_usuario, id_publicacion
- FK -> id_usuario, id_publicacion
- Claves candidatas -> id_usuario, id_publicacion