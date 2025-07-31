#!/bin/sh

# Script de inicialización de base de datos
# Si no existe la base de datos en el volumen persistente, copia desde seed

DB_PATH="/app/data/sqlite.db"
SEED_PATH="/app/data-seed/sqlite.db"

if [ ! -f "$DB_PATH" ]; then
    echo "🗄️ Base de datos no encontrada en volumen persistente"
    if [ -f "$SEED_PATH" ]; then
        echo "📦 Copiando datos iniciales desde imagen..."
        cp "$SEED_PATH" "$DB_PATH"
        echo "✅ Base de datos inicializada con datos seed"
    else
        echo "⚠️ No se encontraron datos seed, Strapi creará una base de datos vacía"
    fi
else
    echo "✅ Base de datos existente encontrada, manteniendo datos persistentes"
fi

# Iniciar Strapi
exec "$@"
