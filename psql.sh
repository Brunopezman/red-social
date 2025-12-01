#!/bin/bash

# ============================================================
# CONFIGURACIÓN
# ============================================================

CONTAINER_NAME="red_social_db"
IMAGE_NAME="red_social_image"
VOLUME_NAME="red_social_data"

POSTGRES_USER="admin"
POSTGRES_PASSWORD="Much4sGr4c14sPal3rm0"
POSTGRES_DB="red_social"

INIT_DB_PATH="$(pwd)/init-db"

# Roles internos (estos sí se crearán en PostgreSQL)
ADMIN_ROLE="admin_role"
ADMIN_ROLE_PASS="admin123"

USER_ROLE="user_role"
USER_ROLE_PASS="username123"


# ============================================================
# 1. BORRAR CONTENEDOR SI EXISTE
# ============================================================

if docker ps -a --format '{{.Names}}' | grep -Eq "^$CONTAINER_NAME\$"; then
    echo "Eliminando contenedor existente $CONTAINER_NAME ..."
    docker rm -f $CONTAINER_NAME
else
    echo "No había contenedor previo."
fi


# ============================================================
# 2. BORRAR VOLUMEN SI EXISTE
# ============================================================

if docker volume ls -q | grep -Eq "^$VOLUME_NAME\$"; then
    echo "Eliminando volumen persistente $VOLUME_NAME ..."
    docker volume rm $VOLUME_NAME
else
    echo "No había volumen previo."
fi


# ============================================================
# 3. RECONSTRUIR IMAGEN
# ============================================================

echo "Construyendo imagen Docker..."
docker build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "Error al construir la imagen."
    exit 1
fi


# ============================================================
# 4. LEVANTAR CONTENEDOR LIMPIO
# ============================================================

echo "Creando contenedor limpio..."

docker run -d \
    --name $CONTAINER_NAME \
    -e POSTGRES_USER=$POSTGRES_USER \
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    -e POSTGRES_DB=$POSTGRES_DB \
    -v "$INIT_DB_PATH":/docker-entrypoint-initdb.d \
    -v $VOLUME_NAME:/var/lib/postgresql/data \
    -p 5432:5432 \
    --restart=unless-stopped \
    $IMAGE_NAME

if [ $? -ne 0 ]; then
    echo "Error creando el contenedor."
    exit 1
fi

echo "Esperando a que PostgreSQL inicie..."
sleep 7


# ============================================================
# 5. CREAR ROLES INTERNOS EN POSTGRESQL
# ============================================================

echo "Creando roles internos en PostgreSQL..."

docker exec -i $CONTAINER_NAME psql -U $POSTGRES_USER -d $POSTGRES_DB <<EOF

-- Crear rol administrador
CREATE ROLE $ADMIN_ROLE LOGIN PASSWORD '$ADMIN_ROLE_PASS';

-- Crear rol usuario común
CREATE ROLE $USER_ROLE LOGIN PASSWORD '$USER_ROLE_PASS';

-- Acceso básico
GRANT CONNECT ON DATABASE $POSTGRES_DB TO $USER_ROLE;
GRANT CONNECT ON DATABASE $POSTGRES_DB TO $ADMIN_ROLE;

EOF

echo "Roles creados correctamente."

# ============================================================
# 6. MOSTRAR INFORMACIÓN ÚTIL
# ============================================================

echo ""
echo "============================================================"
echo "CONTENEDOR INICIADO CORRECTAMENTE"
echo "============================================================"
echo "Contenedor: $CONTAINER_NAME"
echo "Base:       $POSTGRES_DB"
echo "Admin DB:   $POSTGRES_USER"
echo "Password:   $POSTGRES_PASSWORD"
echo "------------------------------------------------------------"
echo "Roles internos creados:"
echo " - $ADMIN_ROLE | pass: $ADMIN_ROLE_PASS"
echo " - $USER_ROLE  | pass: $USER_ROLE_PASS"
echo "------------------------------------------------------------"
echo "Conectarse dentro del contenedor como admin:"
echo "docker exec -it $CONTAINER_NAME psql -U $POSTGRES_USER -d $POSTGRES_DB"
echo ""
echo "Conectarse como admin_role:"
echo "docker exec -it $CONTAINER_NAME psql -U $ADMIN_ROLE -d $POSTGRES_DB"
echo ""
echo "Conectarse como user_role:"
echo "docker exec -it $CONTAINER_NAME psql -U $USER_ROLE -d $POSTGRES_DB"
echo "============================================================"
echo ""
