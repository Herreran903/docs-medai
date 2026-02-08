---
sidebar_position: 1
---

# MedAI

MedAI is a web application focused on clinical entity extraction from medical text and documents (PDF, DOCX, free text). The platform combines a FastAPI (Python) backend and a React/Next.js frontend to deliver end-to-end clinical NLP.

## Architecture

- **Backend (FastAPI)**: exposes endpoints like `POST /extract`, `POST /extract-batch`, and `GET /notes/{id}` to process text and fetch results.
- **Supported models**: LSTM, Transformers such as BETO/Roberta, and LLMs such as GPT/Claude.
- **Persistence**: results are stored in MongoDB.
- **OpenAPI**: specs are generated automatically by `scripts/export_openapi.py` in the backend repo, one per service (gateway + model services).

## Frontend

The frontend consumes the backend API and provides helpers, types, and hooks documented with TypeDoc. This makes it easy to integrate extraction features in web interfaces.

## Documentation and deployment

Documentation lives in a separate repository (`docs-medai`) built with Docusaurus. In CI:

- The frontend repo is cloned to generate Markdown with TypeDoc.
- The backend repo is cloned to generate multiple specs under `openapi/` (plus a legacy `openapi.json`).
- The spec is rendered with ReDoc.

The site is published on GitHub Pages with `baseUrl=/docs-medai/`, and the OpenAPI is served at:
`https://herreran903.github.io/docs-medai/openapi/gateway.json`,
`https://herreran903.github.io/docs-medai/openapi/ner-transformer.json`,
`https://herreran903.github.io/docs-medai/openapi/ner-bilstm.json`,
`https://herreran903.github.io/docs-medai/openapi/ner-llm.json`.

## Main repositories

- Frontend: https://github.com/Herreran903/medai-frontend
- Backend: https://github.com/Herreran903/medai-backend
- Documentation: https://github.com/Herreran903/docs-medai
- Published site: https://herreran903.github.io/docs-medai/
- App: https://medai-frontend-seven.vercel.app/
