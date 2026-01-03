---
sidebar_position: 1
---

# MedAI

MedAI es una aplicacion web orientada al procesamiento y extraccion de entidades clinicas a partir de texto medico y documentos (PDF, DOCX, texto libre). La plataforma combina un backend en FastAPI (Python) y un frontend en React/Next.js para ofrecer una experiencia completa de analisis clinico.

## Arquitectura general

- **Backend (FastAPI)**: expone endpoints como `POST /extract`, `POST /extract-batch` y `GET /notes/{id}` para procesar texto y recuperar resultados.
- **Modelos soportados**: LSTM, Transformers como BETO/Roberta y LLMs como GPT/Claude.
- **Persistencia**: los resultados se guardan en MongoDB.
- **OpenAPI**: la especificacion se genera automaticamente con `scripts/export_openapi.py`.

## Frontend

El frontend consume la API del backend y ofrece helpers, tipos y hooks documentados con TypeDoc. Esto permite integrar facilmente la funcionalidad de extraccion en interfaces web.

## Documentacion y despliegue

La documentacion vive en un repositorio separado (`docs-medai`) construido con Docusaurus. En CI:

- Se clona el repo del frontend para generar Markdown con TypeDoc.
- Se clona el repo del backend para generar `openapi.json`.
- La especificacion se renderiza con ReDoc.

El sitio se publica en GitHub Pages con `baseUrl=/docs-medai/` y el OpenAPI se sirve en:
`https://herreran903.github.io/docs-medai/openapi/backend.json`.

## Repositorios principales

- Frontend: https://github.com/Herreran903/medai-frontend
- Backend: https://github.com/Herreran903/medai-backend
- Documentacion: https://github.com/Herreran903/docs-medai
- Sitio publicado: https://herreran903.github.io/docs-medai/
