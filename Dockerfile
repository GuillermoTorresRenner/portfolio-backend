FROM node:18-alpine

# Crear directorio de la aplicación
WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm ci --omit=dev

# Copiar el código fuente
COPY . .

# Crear directorios necesarios
RUN mkdir -p data data-seed

# Copiar datos iniciales como seed
COPY data-seed/sqlite.db /app/data-seed/sqlite.db

# Copiar scripts de inicialización
COPY scripts/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Construir la aplicación
RUN npm run build

# Exponer el puerto
EXPOSE 1337

# Comando para iniciar la aplicación con inicialización de DB
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
CMD ["npm", "start"]
