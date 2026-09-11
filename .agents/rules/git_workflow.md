# Regla de Gobernanza: Flujo de Trabajo Git

> **Regla de oro absoluta**: NUNCA hagas `git push` directo a `main` ni a `develop`. NUNCA uses `--force` en ramas remotas compartidas.

---

## 1. Ramas protegidas

Las ramas `main` y `develop` están estrictamente protegidas por Rulesets en GitHub:
- `main`: Reservada exclusivamente para versiones de producción etiquetadas.
- `develop`: Rama base de desarrollo e integración activa.

---

## 2. Flujo completo de contribución

Todo cambio en el código debe seguir sin excepción los siguientes 10 pasos:

1. **Sincronizar base local**:
   ```bash
   git checkout develop
   git pull origin develop
   ```
2. **Crear rama de tarea descriptiva**:
   ```bash
   git checkout -b <tipo>/nombre-descriptivo-corto
   ```
3. **Implementar y verificar calidad local**:
   - Escribir código y pruebas unitarias/widgets correspondientes.
   - Ejecutar la suite de calidad local:
     - `dart format --set-exit-if-changed .`
     - `cd elite_multiservicios_server && dart analyze`
     - `cd elite_multiservicios_flutter && flutter analyze`
     - `flutter test`
     - `cd elite_multiservicios_server && dart test`
4. **Registrar commits atómicos**:
   - Aplicar el estándar de Conventional Commits:
   ```bash
   git add .
   git commit -m "<tipo>(<modulo>): descripción clara y concisa"
   ```
5. **Subir rama de tarea al repositorio remoto**:
   ```bash
   git push -u origin <tipo>/nombre-descriptivo-corto
   ```
6. **Abrir Pull Request hacia `develop`**:
   - Base: `develop`.
   - Revisor obligatorio asignado: `@rogelio888` (vía `.github/CODEOWNERS`).
7. **Esperar verificación del pipeline CI**:
   - Los 4 jobs obligatorios deben estar en verde ✅:
     1. `Secret Leak Detection (Gitleaks)`
     2. `Code Formatting & Static Analysis`
     3. `Flutter Unit & Widget Tests`
     4. `Serverpod Tests & Database Integration`
8. **DETENERSE Y PEDIR APROBACIÓN AL HUMANO**:
   - Queda terminantemente prohibido que la IA intente mergear por iniciativa propia.
   - Informar al humano con el resumen del PR y solicitar confirmación explícita.
9. **Mergear únicamente tras aprobación**:
   - Solo cuando el humano responda con su autorización expresa se procede al merge en GitHub.
10. **Limpiar entorno local pos-merge**:
    ```bash
    git checkout develop
    git pull origin develop
    git branch -d <tipo>/nombre-descriptivo-corto
    ```

---

## 3. Nomenclatura oficial de ramas

| Prefijo | Propósito | Ejemplo |
|---|---|---|
| `feat/` | Nuevas funcionalidades de negocio o producto | `feat/auth-mfa-support` |
| `fix/` | Corrección de bugs o errores | `fix/session-token-timeout` |
| `docs/` | Documentación, guías o READMEs | `docs/update-architecture-guide` |
| `chore/` | Mantenimiento, dependencias o configuración interna | `chore/upgrade-serverpod-3-4` |
| `refactor/` | Reestructuración de código sin alterar comportamiento | `refactor/rbac-guard-extraction` |
| `test/` | Inclusión o ajuste exclusivo de pruebas | `test/add-audit-integration-tests` |

---

## 4. Gestión del error de protección GH013

Si al intentar un push recibes el error:
```text
remote: error: GH013: Repository rule violations found for refs/heads/develop.
remote: - Changes must be made through a pull request.
To https://github.com/rogelio888/elite_multiservicios.git
 ! [remote rejected] develop -> develop (push declined due to repository rule violations)
```

**Diagnóstico y acción obligatoria**:
1. Esto confirma que la protección de Ruleset está activa y funcionando correctamente.
2. **NO uses `--force`**.
3. Crea de inmediato una nueva rama para tus cambios con `git checkout -b feat/nombre-tarea`.
4. Sube la rama y abre el Pull Request correspondiente hacia `develop`.

---

## 5. Convención de commits (Conventional Commits)

Cada commit debe estructurarse como:
`<tipo>(<alcance opcional>): <descripción imperativa>`

Ejemplos:
- `feat(security): implementa RBAC granular en endpoints de auditoria`
- `fix(flutter): corrige layout overflow en pantalla de login`
- `docs(onboarding): actualiza guia de configuracion local`

---

## 6. Prohibiciones explícitas

- ❌ Hacer `git push origin main` o `git push origin develop` de forma directa.
- ❌ Utilizar `git push --force` o flags equivalentes en ramas remotas.
- ❌ Commitear secretos, contraseñas o archivos `.env` / `passwords.yaml`.
- ❌ Mergear un Pull Request sin tener los 4 checks de CI en estado verde.
- ❌ Mergear sin la aprobación explícita del Tech Lead humano (`@rogelio888`).
