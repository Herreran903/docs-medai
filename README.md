# Docs (Docusaurus)

Este sitio se construye con [Docusaurus](https://docusaurus.io/) y se regenera en cada build con:
- Docs del FRONT via TypeDoc en `docs/api/front`
- Docs del BACK via OpenAPI en `docs/backend-api.mdx`
- OpenAPI del BACK en `openapi/backend.json` (Redocusaurus)

## Requisitos

- Node.js LTS (>= 20)
- npm

## Variables de entorno / Secrets

Configurar estos secrets en GitHub Actions (repo-docs):
- `GH_PAT` (PAT con permiso de lectura a `ORG/repo-front` y `ORG/repo-back` si son privados)

Variables opcionales para personalizar rutas y comandos:
- `FRONT_REPO` (default `ORG/repo-front`)
- `FRONT_REF` (default `main`)
- `FRONT_REPO_URL` (override URL de git)
- `FRONT_REPO_TOKEN` (override token para el front)
- `FRONT_TYPEDOC_CMD` (por ejemplo `npm run docs`)
- `FRONT_TYPEDOC_OUT` (directorio donde TypeDoc escribe)
- `BACK_REPO` (default `ORG/repo-back`)
- `BACK_BRANCH` (default `main`)
- `BACK_REPO_URL` (override URL de git)
- `BACK_REPO_TOKEN` (override token para el back)
- `DOCS_URL`, `BASE_URL`, `DOCS_ORG`, `DOCS_REPO` (Docusaurus/GitHub Pages)

## Instalacion

```bash
npm ci
```

## Local Development

```bash
npm run prebuild
npm run start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

## Build

```bash
npm run prebuild
npm run build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

GitHub Actions ejecuta el workflow `docs-build.yml` en cada push a `main` o via `repository_dispatch`.
