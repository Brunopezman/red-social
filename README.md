# Base de Datos (BDD)

Este repositorio contiene la configuración y los scripts necesarios para levantar una base de datos de una Red Social con PostgreSQL mediante Docker, con la inicialización automática de las tablas y los datos.

## 📂 Estructura del proyecto

```
tp-bdd/
├── Dockerfile
├── docker-compose.yml
├── enunciadoTP.pdf
├── resumenFinal.pdf
├── init-db/
│   ├── 01-tablas.sql
│   └── 02-inserciones.sql
│   └── 03-permisos.sql
│   └── 04-consultas.sql
├── preguntas.md
├── modeloRelacional.md
├── psql.sh 
└── README.md
```

### Descripción de archivos principales

- **Dockerfile** → Define la imagen de PostgreSQL personalizada.  
- **docker-compose.yml** → (Opcional) Permite levantar los servicios de forma orquestada.  
- **psql.sh** → Script que construye la imagen, levanta el contenedor y prepara la base de datos.  
- **init-db/** → Contiene los scripts SQL que se ejecutan automáticamente al iniciar el contenedor.  
- **informe.pdf** → Informe del trabajo práctico.  
- **modeloRelacional.md** 
- **preguntas.mdd** → Practica para final

---

## 🚀 Requisitos previos

Antes de ejecutar el proyecto, asegurate de tener instalado:

- [Docker](https://docs.docker.com/get-docker/)
- [Bash](https://www.gnu.org/software/bash/) (en sistemas Linux o WSL en Windows)

---

## ⚙️ Instrucciones de uso

1. **Cloná el repositorio:**
   ```bash
   git clone <URL-del-repo>
   cd tp-bdd
   ```

2. **Dale permisos de ejecución al script (solo la primera vez):**
   ```bash
   chmod +x psql.sh
   ```

3. **Ejecutá el script principal:**
   ```bash
   ./psql.sh
   ```

   El script realiza las siguientes acciones:
   - Construye la imagen Docker llamada `red_social_db`.
   - Elimina cualquier contenedor previo con el mismo nombre.
   - Levanta un nuevo contenedor con PostgreSQL configurado.
   - Monta automáticamente los scripts de `init-db/` para crear las tablas e insertar datos.

4. **Conectate a la base de datos:**

   Una vez que el contenedor esté corriendo, la terminal te mostrará el comando para ingresar:

   ```bash
   docker exec -it red_social_db psql -U admin -d red_social
   ```

   Desde ahí podrás ejecutar tus consultas SQL.

---

## 🧠 Variables del entorno (por defecto)

| Variable             | Valor                     |
|----------------------|---------------------------|
| `POSTGRES_USER`      | admin                     |
| `POSTGRES_PASSWORD`  | Much4sGr4c14sP4l3rm0      |
| `POSTGRES_DB`        | red_social                |
| `CONTAINER_NAME`     | red_social_db             |

---

## 📘 Licencia MIT

```
MIT License

Copyright (c) 2025 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

---

## ✍️ Autor

Trabajo realizado por **Bruno Pezman**, **Valentino Ceniceros**, **Camila Mantilla**, **Lautaro Torraca** y **Manuel Pato** para la materia **Base de Datos (BDD)**.
