# OpenAPI Guidelines

## Version

Default:

OpenAPI 3.0.3

## Naming

Paths:

- lowercase
- plural resource names
- kebab-case where necessary

Examples:

/monitoring-features
/monitoring-features/{monitoringFeatureId}

## HTTP Methods

GET    Read
POST   Create
PUT    Replace
PATCH  Partial update
DELETE Delete

## Status Codes

Typical:

200 OK
201 Created
204 No Content
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
500 Internal Server Error

## Request Headers

Cams-Correlation-Id

## Resonse Headers

Typical:

Cams-Build-Id
Cams-Correlation-Id
Cams-Result-Count

## Operation IDs

Use:

<Resource>-<Action>

Examples:

monitoringfeature-get
monitoringfeature-get-by-id
monitoringfeature-create
monitoringfeature-update
monitoringfeature-delete

## Schemas

Prefer reusable schemas:

components:
  schemas:

Avoid defining the same object inline multiple times.

## Error Model

All APIs should reuse the common error contract.

## Azure API Management

Specifications must be importable into Azure API Management.

Review known APIM OpenAPI import restrictions before introducing
advanced OpenAPI features.