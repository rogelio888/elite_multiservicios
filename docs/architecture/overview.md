# Arquitectura General del Sistema Empresarial

## 1. Visión Global
El **Sistema Empresarial Modular** es una plataforma centralizada de grado empresarial diseñada para administrar diferentes áreas operativas con alta escalabilidad, seguridad rigurosa y mantenibilidad.

```
                         SISTEMA EMPRESARIAL
                                 |
                 +---------------+---------------+
                 |                               |
                 v                               v
           FLUTTER CLIENT                    SERVERPOD
           (Frontend)                        (Backend Dart)
                 |                               |
                 |                         Lógica de Negocio
                 |                         Autenticación & JWT
                 |                         Autorización RBAC
                 |                         Auditoría Transversal
                 |                         Validaciones de Dominio
                 |                         Endpoints RPC & Streaming
                 |                         Servicios & Repositorios
                 |                               |
                 +---------------+---------------+
                                 |
                                 v
                            POSTGRESQL
```

## 2. Principio de Autoridad del Backend (Backend-First Authority)
- **Regla Inquebrantable**: La seguridad y autorización residen de manera absoluta en el backend (**Serverpod**).
- El cliente **Flutter** puede ocultar o deshabilitar opciones visuales por motivos ergonómicos y de experiencia de usuario, pero el backend jamás asume que una petición es válida solo porque proviene del frontend.
- Cada endpoint sensible ejecuta comprobaciones de autenticación y de permisos granulares (`RbacGuard.requirePermission(...)`).

## 3. Topología de Componentes
1. **`elite_multiservicios_server`**:
   - Desarrollado en Dart sobre Serverpod.
   - Acceso a base de datos PostgreSQL mediante ORM y migraciones formales.
   - Soporte para autenticación JWT, email y proveedores externos.
   - Bitácora de eventos de auditoría no bloqueante.
2. **`elite_multiservicios_client`**:
   - Paquete de contrato y llamadas RPC autogenerado por Serverpod CLI.
   - Código generado: **estrictamente prohibida su modificación manual**.
3. **`elite_multiservicios_flutter`**:
   - Cliente multiplataforma (Web, Windows, macOS, Linux, iOS, Android).
   - Separación estricta entre capa `core/` (rutas, temas, constantes, utilidades) y `features/` (módulos de negocio).

## 4. Política de Persistencia y Cero Datos Mock
- No se permiten arrays en memoria ni respuestas simuladas en producción o en endpoints activos.
- Los entornos de desarrollo y pruebas se sustentan en bases de datos PostgreSQL reales gestionadas por contenedores Docker y migraciones oficiales.
