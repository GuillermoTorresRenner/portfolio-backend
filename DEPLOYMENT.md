# Despliegue con Docker

## Estrategia de Persistencia de Datos

Esta aplicación utiliza una **estrategia híbrida** para la persistencia de datos:

1. **Datos iniciales**: Se incluyen en la imagen Docker como "seed data"
2. **Datos persistentes**: Se almacenan en volúmenes Docker que persisten entre despliegues
3. **Migración automática**: Si no hay datos persistentes, se copian automáticamente desde la imagen

## Desarrollo Local

```bash
# Construir y ejecutar localmente
docker compose up --build
```

## Producción

### 1. Configurar variables de entorno

```bash
# Copiar y editar archivo de configuración
cp .env.prod.example .env.prod

# Editar con tus valores reales
nano .env.prod
```

### 2. Desplegar desde Docker Hub

```bash
# Usar la imagen pre-construida desde Docker Hub
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

### 3. Verificar despliegue

```bash
# Ver logs
docker compose -f docker-compose.prod.yml logs -f

# Verificar salud del contenedor
docker compose -f docker-compose.prod.yml ps
```

## Ventajas de esta Estrategia

✅ **Datos preservados**: Tus datos actuales se incluyen en cada imagen
✅ **Persistencia**: Los nuevos datos se mantienen entre actualizaciones
✅ **Zero downtime**: Actualizaciones sin pérdida de datos
✅ **Backup simple**: Solo respaldar el volumen `strapi_data`
✅ **Rollback fácil**: Volver a versión anterior manteniendo datos

## Flujo de Trabajo

1. **Push a main** → GitHub Actions construye imagen → Docker Hub
2. **En producción** → Pull nueva imagen → Restart contenedor
3. **Primera vez** → Datos se copian desde imagen
4. **Subsecuentes** → Datos persisten en volumen

## Backup y Restore

### Backup

```bash
# Backup del volumen de datos
docker run --rm -v strapi_data:/data -v $(pwd):/backup alpine tar czf /backup/strapi-backup-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore

```bash
# Restore desde backup
docker run --rm -v strapi_data:/data -v $(pwd):/backup alpine tar xzf /backup/strapi-backup-YYYYMMDD.tar.gz -C /data
```
