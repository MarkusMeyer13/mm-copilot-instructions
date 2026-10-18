# mm-copilot-instructions

Personal configuration repository for [GitHub Copilot CLI](https://github.com/github/copilot-cli), containing custom agents, instructions, prompts, skills, plugins, and repository hooks used across projects.

## Structure

| Folder | Purpose |
| --- | --- |
| `agents/` | Custom agent definitions (`*.agent.md`) that define specialized personas and behaviors Copilot can be invoked as. |
| `copilot-prompts/` | Reusable prompt files (`*.md`) for common workflows such as repository analysis, architecture review, and PR comment handling. |
| `hooks/` | Repository-level Copilot CLI hooks (e.g. `nuget-updater`, `secrets-scanner`) that run automated checks before Copilot performs certain actions. |
| `instructions/` | Scoped instruction files (`*.instructions.md`) applied automatically based on file path patterns (`applyTo`), covering languages, frameworks, and conventions. |
| `plugins/` | Copilot CLI plugin definitions and manifests. |
| `skills/` | Agent Skills (`SKILL.md` files) that extend Copilot with specific, invokable capabilities. |

## Root instruction files

- `copilot-instructions.md` — global coding standards, NuGet dependency policy, and agent persona/communication style.
- `AGENTS.md` — GitHub pull request workflow mechanics (branching, commits, verification loop, `gh` CLI usage).

See the scope notes at the top of each file for how they relate to one another.

## Notes

Runtime and session state (e.g. `config.json`, `session-store.db`, `installed-plugins/`, `logs/`) is excluded via `.gitignore` and not part of the versioned configuration.
