#!/bin/bash

# Nombre del contenedor
CONTAINER_NAME="red_social_db"

# Variables de entorno
POSTGRES_USER="admin"
POSTGRES_PASSWORD="Much4sGr4c14sP4l3rm0"
POSTGRES_DB="red_social"

# Construir la imagen
echo "Construyendo imagen Docker..."
docker build -t red_social_db .

# Verificar si el contenedor ya existe
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Eliminando contenedor existente..."
    docker rm -f $CONTAINER_NAME
fi

# Levantar el contenedor en segundo plano
echo "Levantando contenedor PostgreSQL en segundo plano..."
docker run -d --name $CONTAINER_NAME \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -v "$(pwd)/init-db":/docker-entrypoint-initdb.d \
  -p 5432:5432 \
  red_social_db

# Verificar si el contenedor está corriendo
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Contenedor está corriendo correctamente."
    echo "Podés conectarte con:"
    echo "docker exec -it $CONTAINER_NAME psql -U $POSTGRES_USER -d $POSTGRES_DB"
else
    echo "Hubo un problema al levantar el contenedor."
fi

# Otorgar permisos de ejecución al propio script
chmod +x "$0"