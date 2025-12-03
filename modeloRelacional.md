# modelo relacional

Paises(<span style="text-decoration: underline"> nombre_pais </span>)

- PK -> nombre_pais
- FK -> ninguno
- Claves candidatas -> nombre_pais

Usuarios( <span style="text-decoration: underline">nombre_usuario</span>, username, email, fecha_de_alta, fecha_de_nacimiento,nombre, apellido, <span style="border-bottom: 1px dotted;">nombre_pais</span>, cantidad_de_ingresos)

- PK -> nombre_usuario
- FK -> nombre_pais
- Claves candidatas -> nombre_usuario, username, email


Publicaciones(<span style="text-decoration: underline">id_publicaciones</span>, <span style="border-bottom: 1px dotted;">nombre_grupo</span>, <span style="border-bottom: 1px dotted;">nombre_usuario</span>)

- PK -> id_publicaciones
- FK -> nombre_grupo, nombre_usuario
- Claves candidatas -> id_publicaciones


Imagenes(<span style="text-decoration: underline">id_publicaciones</span>, <span style="border-bottom: 1px dotted;">nombre_grupo</span>, <span style="border-bottom: 1px dotted;">nombre_usuario</span>,url_imagen)

- PK -> id_publicaciones
- FK -> nombre_grupo, nombre_usuario
- Claves candidatas -> id_publicaciones

Videos(<span style="text-decoration: underline">id_publicaciones</span>, contenido, <span style="border-bottom: 1px dotted;">nombre_grupo</span>, <span style="border-bottom: 1px dotted;">nombre_usuario</span>, url_video, duracion, calidad)

- PK -> id_publicaciones
- FK -> nombre_grupo, nombre_usuario
- Claves candidatas -> id_publicaciones

Textos(<span style="text-decoration: underline">id_publicaciones</span>, contenido, <span style="border-bottom: 1px dotted;">nombre_grupo</span>, <span style="border-bottom: 1px dotted;">nombre_usuario</span>, texto)

- PK -> id_publicaciones
- FK -> nombre_grupo, nombre_usuario
- Claves candidatas -> id_publicaciones

Grupos(<span style="text-decoration: underline">nombre_grupo</span>, id_creador, descripcion, fecha_de_creacion)

- PK -> nombre_grupo
- FK -> id_creador
- Claves candidatas -> nombre_grupo

UsuariosGrupos(<span style="text-decoration: underline">nombre_grupo</span>, <span style="border-bottom: 1px dotted;"><span style="text-decoration: underline"> nombre_usuario </span></span>, fecha_de_ingreso)

- PK -> nombre_grupo, nombre_usuario
- FK -> nombre_grupo, nombre_usuario
- Claves candidatas -> nombre_grupo, nombre_usuario

Comentarios(<span style="text-decoration: underline">id_comentario</span>, contenido, <span style="border-bottom: 1px dotted;">nombre_usuario</span>, <span style="border-bottom: 1px dotted;">id_publicacion</span>)

- PK -> id_comentario
- FK -> nombre_usuario, id_publicacion
- Claves candidatas -> id_comentario

Amistades(<span style="text-decoration: underline"><span style="border-bottom: 1px dotted;">nombre_usuario_1</span>, <span style="border-bottom: 1px dotted;">nombre_usuario_2</span></span>, fecha_de_amistad)

- PK -> nombre_usuario_1, nombre_usuario_2
- FK -> nombre_usuario_1, nombre_usuario_2
- Claves candidatas -> nombre_usuario_1, nombre_usuario2

Notificaciones(<span style="text-decoration: underline">id_notificacion</span>, <span style="border-bottom: 1px dotted;">nombre_usuario</span>)

- PK -> id_notificacion
- FK -> nombre_usuario
- Claves candidatas -> id_notificacion

mensajes( <span style="text-decoration: underline"> id_mensaje</span>, estado, contenido, fecha_de_envio, <span style="border-bottom: 1px dotted;">nombre_usuario_emisor</span>, <span style="border-bottom: 1px dotted;">nombre_usuario_receptor</span>)

- PK -> id_mensaje
- FK -> nombre_usuario_emisor, nombre_usuario_receptor
- Claves candidatas -> id_mensaje

favoritos(<span style="text-decoration: underline"> <span style="border-bottom: 1px dotted;">nombre_usuario</span>, <span style="border-bottom: 1px dotted;">id_publicacion</span></span>)

- PK -> nombre_usuario, id_publicacion
- FK -> nombre_usuario, id_publicacion
- Claves candidatas -> nombre_usuario, id_publicacion
