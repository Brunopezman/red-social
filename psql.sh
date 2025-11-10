#!/bin/bash

# ===========================
# Configuración
# ===========================
CONTAINER_NAME="red_social_db"
POSTGRES_USER="admin_user"
POSTGRES_PASSWORD="admin123"
POSTGRES_DB="red_social"
VOLUME_NAME="red_social_data"
INIT_DB_PATH="$(pwd)/init-db"
IMAGE_NAME="red_social_db"

# Roles y contraseñas para mostrar al usuario
declare -A ROLES
ROLES=( ["admin_role"]="admin123" ["user_role"]="user123")

# ===========================
# Construir la imagen Docker
# ===========================
echo "Construyendo/actualizando imagen Docker..."
docker build -t $IMAGE_NAME .

# ===========================
# Crear volumen persistente si no existe
# ===========================
if [ -z "$(docker volume ls -q -f name=$VOLUME_NAME)" ]; then
    echo "Creando volumen persistente $VOLUME_NAME..."
    docker volume create $VOLUME_NAME
else
    echo "Volumen $VOLUME_NAME ya existe. Los datos se conservarán."
fi

# ===========================
# Verificar si el contenedor ya existe
# ===========================
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Contenedor $CONTAINER_NAME ya existe."
    
    # Si el contenedor está detenido, iniciar
    if [ -z "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Iniciando contenedor detenido..."
        docker start $CONTAINER_NAME
    else
        echo "Contenedor ya está corriendo."
    fi
else
    echo "Creando y ejecutando contenedor $CONTAINER_NAME..."
    docker run -d --name $CONTAINER_NAME \
        -e POSTGRES_USER=$POSTGRES_USER \
        -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
        -e POSTGRES_DB=$POSTGRES_DB \
        -v "$INIT_DB_PATH":/docker-entrypoint-initdb.d \
        -v $VOLUME_NAME:/var/lib/postgresql/data \
        -p 5432:5432 \
        --restart unless-stopped \
        $IMAGE_NAME
fi

# ===========================
# Mostrar usuarios y cómo conectarse
# ===========================
echo ""
echo "==============================="
echo "Usuarios disponibles y contraseñas:"
for role in "${!ROLES[@]}"; do
    echo "Rol: $role | Contraseña: ${ROLES[$role]}"
done
echo "==============================="
echo ""
echo "Ejemplos para conectarse:"
echo " - Como admin: docker exec -it $CONTAINER_NAME psql -U admin_role -d $POSTGRES_DB"
echo " - Como usuario: docker exec -it $CONTAINER_NAME psql -U user_role -d $POSTGRES_DB"
echo ""

# ===========================
# Verificar si el contenedor está corriendo
# ===========================
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Contenedor $CONTAINER_NAME está corriendo correctamente."
else
    echo "Hubo un problema al levantar el contenedor."
fi

# ===========================
# Permisos de ejecución
# ===========================
chmod +x "$0"
