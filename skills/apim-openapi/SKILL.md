---
name: apim-openapi
description: Design, generate and review OpenAPI YAML specifications intended for Azure API Management. Use when creating or modifying APIM APIs, REST contracts or OpenAPI specifications.
---

# APIM OpenAPI Skill

Use this skill whenever an OpenAPI specification for
Azure API Management is designed, generated or reviewed.

Before generating YAML:

1. Understand the API resource model.
2. Determine paths and HTTP methods.
3. Define request models.
4. Define response models.
5. Define common error responses.
6. Consider authentication and authorization.
7. Check Azure API Management compatibility.

Prefer reusable definitions under components.

Read `openapi-guidelines.md` before generating or reviewing
an OpenAPI specification.

When finished, perform a second validation pass.

Do not silently invent missing business requirements.
State assumptions explicitly.