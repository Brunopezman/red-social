# Red Social - SQL, PostgreSQL, Docker

Este proyecto implementa la base de datos de una Red Social utilizando PostgreSQL y Docker. El sistema cuenta con una arquitectura de roles (Admin y User), triggers de validación automática y una estructura diseñada para la escalabilidad.

### ✍️ Autor

Trabajo realizado por Bruno Pezman, Valentino Ceniceros, Camila Mantilla, Lautaro Torraca y Manuel Pato para la materia Base de Datos (BDD).

# 📂 Estructura del Proyecto

```
tp-bdd/
├── init-db/                # Scripts de inicialización automática
│   ├── 01-tablas.sql       # Esquema, triggers y funciones
│   ├── 02-inserciones.sql  # Carga de datos iniciales (Seed)
│   ├── 03-roles.sql        # Roles de acceso con permisos granulados
│   └── 04-permisos.sql     # Configuración de roles y privilegios
├── consultas.sql           # Consultas requeridas por el TP
├── preguntas.md            # Material de práctica para el examen
├── resumenFinal.pdf        # Resumen teórico para el final
├── modeloRelacional.md     # Documentación técnica del diseño
├── enunciadoTP.pdf         # Consigna oficial
├── .env.example            # Plantilla de variables de entorno
├── docker-compose.yml      # Orquestación del contenedor
└── README.md               # Instrucciones de uso
```

# 🚀 Requisitos Previos

Antes de ejecutar el proyecto, asegurate de tener instalado:

- [Docker](https://docs.docker.com/get-docker/)
- [Bash](https://www.gnu.org/software/bash/) (en sistemas Linux o WSL en Windows).

# ⚙️ Instrucciones de Uso

1. Configuración Inicial

Antes de levantar el servicio, crea tu archivo de variables de entorno:

```Bash
cp .env.example .env
```
(Asegúrate de que los valores en .env coincidan con los nombres de base de datos que esperas usar).

2. Levantar la Base de Datos

Construye e inicia el contenedor con el siguiente comando:

```Bash
docker compose up -d
```
Nota: Al iniciar, Docker ejecutará automáticamente los scripts dentro de init-db/ en orden alfanumérico. Esto solo ocurre la primera vez que se crea el volumen.

3. Acceso mediante Roles
Para interactuar con la base de datos, utiliza los siguientes comandos según el perfil de acceso:

Perfil Administrador (admin_role)
Tiene control total sobre el esquema y los datos.

```Bash
docker exec -it red_social_db psql -U admin_role -d red_social
```

Perfil Usuario (user_role)
Acceso limitado a la interacción social (lectura y creación de contenido).

```bash
docker exec -it red_social_db psql -U user_role -d red_social
```

4. Ejecución de Consultas del TP
Para verificar el funcionamiento y obtener los reportes solicitados en la consigna, puedes ejecutar el archivo externo:

```Bash
docker exec -i red_social_db psql -U admin_role -d red_social < consultas.sql
```

# 🧠 Notas Técnicas

Persistencia: Los datos se almacenan en un volumen de Docker (pgdata), lo que permite que la información no se pierda al reiniciar el contenedor.

Limpieza Total: Si deseas resetear la base de datos por completo (incluyendo datos y tablas), ejecuta:


```bash
docker compose down -v
```

Variables de Entorno: El sistema utiliza interpolación de variables desde el archivo .env para definir el puerto, usuario root y nombre de la base de datos.