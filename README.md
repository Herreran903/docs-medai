# MedAI Docs (Docusaurus)

Repositorio de documentacion de MedAI, construido con [Docusaurus](https://docusaurus.io/) y desplegado en GitHub Pages:
- Sitio: https://herreran903.github.io/docs-medai/
- `baseUrl`: `/docs-medai/`

## Estructura de docs

- **Overview**: `docs/intro.md`
- **Frontend API**: generado por TypeDoc en `docs/api/front/**`
- **Backend API**: `docs/backend-api.mdx` renderiza ReDoc con el OpenAPI

## OpenAPI (Backend)

El OpenAPI se genera en CI y se publica como archivo estatico:
- Fuente local: `openapi/backend.json`
- Publicado en: `static/openapi/backend.json` -> `https://herreran903.github.io/docs-medai/openapi/backend.json`

El script que lo prepara es `scripts/fetch_back_openapi.sh`.

## Scripts principales

- `npm run prebuild`: ejecuta `scripts/fetch_front_docs.sh` y `scripts/fetch_back_openapi.sh`
- `npm run start`: desarrollo local
- `npm run build`: build para produccion

## Requisitos

- Node.js LTS (>= 20)
- npm

## Variables de entorno / Secrets

Configurar en GitHub Actions si los repos son privados:
- `GH_PAT` (token con permisos de lectura)

Opcionales para personalizar fuentes:
- `FRONT_REPO`, `FRONT_REF`, `FRONT_REPO_URL`, `FRONT_REPO_TOKEN`
- `FRONT_TYPEDOC_CMD`, `FRONT_TYPEDOC_OUT`
- `BACK_REPO`, `BACK_BRANCH`, `BACK_REPO_URL`, `BACK_REPO_TOKEN`

## Instalacion

```bash
npm ci
```

## Desarrollo local

```bash
npm run prebuild
npm run start
```

## Build

```bash
npm run prebuild
npm run build
```

## Deployment

GitHub Actions ejecuta `docs-build.yml` en cada push a `main` o via `repository_dispatch`.
