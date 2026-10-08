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

## Operation IDs

Use:

<Resource>_<Action>

Examples:

MonitoringFeature_Get
MonitoringFeature_GetById
MonitoringFeature_Create
MonitoringFeature_Update
MonitoringFeature_Delete

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