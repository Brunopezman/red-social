# Red Social - SQL, PostgreSQL, Docker

Este proyecto implementa la base de datos de una Red Social utilizando PostgreSQL y Docker. El sistema cuenta con una arquitectura de roles (Admin y User), triggers de validación automática y una estructura diseñada para la escalabilidad.

### ✍️ Autor

Trabajo realizado por Bruno Pezman, Valentino Ceniceros, Camila Mantilla, Lautaro Torraca y Manuel Pato para la materia Base de Datos (BDD).

# 📂 Estructura del Proyecto

```
tp-bdd/
├── init-db/                # Scripts de inicialización automática
│   ├── 01-roles.sql        # Roles de acceso con permisos granulados
│   ├── 02-tablas.sql       # Esquema, triggers y funciones
│   ├── 03-inserciones.sql  # Carga de datos iniciales (Seed)
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

Perfil Desarrollador (Acceso Total)
Ideal para mantenimiento, pruebas en SQLTools y cambios en el esquema. Tiene todos los privilegios sobre el esquema público.

```Bash
docker exec -it red_social_db psql -U developer -d red_social_db
```

Perfil Aplicación (Usuario de App)
Acceso limitado para el funcionamiento del Backend (DML). Puede consultar, insertar, actualizar y borrar datos en las tablas existentes.(lectura y creación de contenido).

```bash
docker exec -it red_social_db psql -U app_user -d red_social_db
```

Perfil Solo Lectura
Para auditorías o reportes rápidos sin riesgo de modificar la información.

```bash
docker exec -it red_social_db psql -U read_only_user -d red_social_db
```

4. Ejecución de Consultas del TP
Para verificar el funcionamiento y obtener los reportes solicitados en la consigna, puedes ejecutar el archivo externo:

```Bash
docker exec -i red_social_db psql -U developer -d red_social_db < consultas.sql
```

# 🧠 Notas Técnicas

Persistencia: Los datos se almacenan en un volumen de Docker (pgdata), lo que permite que la información no se pierda al reiniciar el contenedor.

Limpieza Total: Si deseas resetear la base de datos por completo (incluyendo datos y tablas), ejecuta:


```bash
docker compose down -v
```

Variables de Entorno: El sistema utiliza interpolación de variables desde el archivo .env para definir el puerto, usuario root y nombre de la base de datos.
