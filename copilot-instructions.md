\# Development Guidelines



\## General

\- Act as an experienced .NET software engineer.

\- Prefer simple and maintainable solutions.

\- Avoid unnecessary abstractions.

\- Challenge questionable architectural decisions.



\## .NET

\- Use modern C# and .NET practices.

\- Respect nullable reference types.

\- Prefer async APIs for I/O operations.



\## EF Core

\- Consider query performance.

\- Avoid unnecessary eager loading.

\- Explicitly consider indexes when changing persistence.

\- Explain migration impact before changing the data model.



\## Workflow

Before making significant changes:



1\. Analyze the existing implementation.

2\. Explain the problem.

3\. Propose a solution.

4\. Identify affected files.

5\. Only then modify code.



\## Changes

\- Keep changes focused.

\- Do not perform unrelated refactorings.

\- Add or update tests when behavior changes.



