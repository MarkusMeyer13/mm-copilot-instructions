# mm-copilot-instructions context-debt cleanup plan

## Scope and evidence

This is a repository review and migration proposal only. No existing
instructions, agents, skills, prompts, plugins, or hooks were changed.

The inventory is based on tracked files. `instructions/` contains 63 files,
`agents/` contains 45, and `skills/` contains 2 `SKILL.md` files. The
reusable prompts live in `copilot-prompts/`, not `prompts/`; that directory
contains 4 files, including one empty file. `docs/` did not exist before this
plan was added. The repository also contains plugin manifests and
documentation, including plugins that repeat several local agent roles.

Ignored runtime settings and session data are not treated as source-of-truth
configuration. Their availability or contents are not required for this
assessment.

## Current-state inventory

| Area | Observed state | Context-debt implication |
|---|---|---|
| `copilot-instructions.md` | 4,528 characters; mixes general preferences, .NET standards, NuGet policy, EF Core rules, and persona guidance. | Several thousand characters load as personal core, including technology-specific rules that do not apply to every task. |
| `AGENTS.md` | 2,392 characters; combines PR mechanics with .NET 8/9 project assumptions and a fixed verification loop. | Duplicates build, test, and formatting rules; may conflict with the PlanB Harness loop and current project targets. |
| `instructions/` | 63 files; 17 declare `applyTo: '**'`, `'*'`, or `['*']`. | The all-path set is about 203,074 characters, or roughly 50,769 tokens using a 4-characters-per-token estimate. |
| `agents/` | 45 custom agent definitions. | Several generic workflow roles overlap one another, local instructions, or agent entries described by local plugin manifests. |
| `skills/` | 2 skills: APIM/OpenAPI and .NET warning remediation. | Both are good examples of on-demand specialist content; many larger specialist instruction files would fit this model. |
| `copilot-prompts/` | 4 prompt files; `analyze-repository.md` is empty. | Prompt files overlap agents and Harness workflows; the empty prompt has no value. |
| `hooks/` | One secrets-scanner bundle: README, configuration, and script. | The hook is a discrete, testable safeguard. Its configured script path should be checked against its installation documentation. |
| `plugins/` | 17 manifests with plugin documentation. | These manifests provide evidence of duplicated roles and external canonical copies; plugin availability is runtime-dependent. |
| Project overlays | No distinct project overlay structure is documented in the repository. | Project-specific .NET, Azure, Power Platform, and similar rules have no explicit home separate from personal core. |

### All-path context contributors

The following 17 files declare a wildcard covering all paths. Their combined
size is 203,074 characters, approximately 50,769 tokens by a rough character
ratio. This is a declared-scope estimate, not a measurement of what a specific
Copilot host actually inserts into a prompt.

| File | Characters |
|---|---:|
| `security-and-owasp.instructions.md` | 31,845 |
| `tasksync.instructions.md` | 29,047 |
| `ai-prompt-engineering-safety-best-practices.instructions.md` | 28,137 |
| `performance-optimization.instructions.md` | 27,201 |
| `devops-core-principles.instructions.md` | 16,592 |
| `code-review-generic.instructions.md` | 14,732 |
| `spec-driven-workflow-v1.instructions.md` | 12,171 |
| `qa-engineering-best-practices.instructions.md` | 7,664 |
| `exclude-prompt-data.instructions.md` | 6,544 |
| `taming-copilot.instructions.md` | 4,988 |
| `self-explanatory-code-commenting.instructions.md` | 4,886 |
| `agent-safety.instructions.md` | 4,263 |
| `copilot-thought-logging.instructions.md` | 3,253 |
| `no-heredoc.instructions.md` | 2,546 |
| `context-engineering.instructions.md` | 2,477 |
| `ms-sql-dba.instructions.md` | 1,413 |
| `playwright-dotnet.instructions.md` | 5,001 |

The four Markdown-wide rules add 20,773 characters when editing Markdown.
Other broad patterns also activate by common file type: the documentation
update rule is 18,240 characters, and the cliche-data rule is 7,913. Three
Power Platform documents also match general Markdown or JSON files. A
Markdown task can therefore activate substantially more content than the
all-path total above.

## Classification of every instruction

Classification indicates the recommended destination or action. For grouped
`MERGE` entries, retain unique technical constraints while removing repeated
explanations and conflicting mandates.

### KEEP — 6

Keep these scoped authoring or format references. They are narrow enough to
remain useful when their target file type is being edited.

- `agent-skills.instructions.md`
- `draw-io.instructions.md`
- `genaiscript.instructions.md`
- `instructions.instructions.md`
- `prompt.instructions.md`
- `shell.instructions.md`

### SCOPE — 5

Keep a concise version and verify that each pattern matches only its intended
artifacts.

- `agents.instructions.md` — agent-file authoring only.
- `azure-naming.instructions.md` — infrastructure files and actual
  infrastructure directories only.
- `csharp.instructions.md` — C# source only; keep general .NET policy out.
- `powershell-pester-6.instructions.md` — Pester test files only.
- `powershell.instructions.md` — PowerShell scripts and modules only.

### MERGE — 20

Consolidate these overlapping guidance families. The destination should be a
short scoped instruction or an on-demand Skill, not a new always-loaded
document.

| Files | Consolidation |
|---|---|
| `agent-safety.instructions.md`; `ai-prompt-engineering-safety-best-practices.instructions.md` | Merge agent governance, prompt safety, and responsible-AI fundamentals into one optional safety resource. Keep only a few universal safeguards in core. |
| `azure-durable-functions-csharp.instructions.md`; `azure-functions-csharp.instructions.md` | Create one Azure Functions resource, with Durable Functions as a separate reference section. |
| `azure-verified-modules-bicep.instructions.md`; `bicep-code-best-practices.instructions.md` | Consolidate Bicep fundamentals and AVM-specific guidance. |
| `context-engineering.instructions.md`; `self-explanatory-code-commenting.instructions.md`; `taming-copilot.instructions.md` | Keep concise, non-conflicting principles in core; drop generic commentary and repeated behavioral rules. |
| `markdown-accessibility.instructions.md`; `markdown-content-creation.instructions.md`; `markdown-gfm.instructions.md`; `markdown.instructions.md` | Replace with one Markdown rule set. Resolve conflicting H1 and front-matter requirements and keep accessibility checks actionable. |
| `exclude-prompt-data.instructions.md`; `use-cliche-data-in-docs.instructions.md` | Merge into a short documentation-only rule for prompt leakage and fictional example data. |
| `declarative-agents-microsoft365.instructions.md`; `mcp-m365-copilot.instructions.md`; `power-platform-mcp-development.instructions.md` | Separate shared MCP concerns from Microsoft 365 declarative-agent and Power Platform-specific constraints. Correct file globs before activation. |
| `dotnet-architecture-good-practices.instructions.md`; `oop-design-patterns.instructions.md` | Consolidate overlapping architecture/design advice into an optional design resource; preserve only project-specific conventions in overlays. |

### MOVE_TO_SKILL — 20

Convert detailed technology or specialist material into Skills that load only
when the task calls for them. Keep a short, path-scoped pointer only where
automatic activation adds clear value.

- `aspnet-rest-apis.instructions.md`
- `azure-apim-ai-gateway.instructions.md`
- `azure-devops-pipelines.instructions.md`
- `csharp-mcp-server.instructions.md`
- `devcontainers.instructions.md`
- `dotnet-framework.instructions.md`
- `github-actions-ci-cd-best-practices.instructions.md`
- `hooks.instructions.md`
- `microsoft-foundry.instructions.md`
- `ms-sql-dba.instructions.md`
- `object-calisthenics.instructions.md`
- `performance-optimization.instructions.md`
- `playwright-dotnet.instructions.md`
- `power-apps-canvas-yaml.instructions.md`
- `power-apps-code-apps.instructions.md`
- `power-platform-connector.instructions.md`
- `rust.instructions.md`
- `security-and-owasp.instructions.md`
- `sql-sp-generation.instructions.md`
- `typespec-m365-copilot.instructions.md`

### MOVE_TO_AGENT — 1

- `dotnet-upgrade.instructions.md` — its body is itself a multi-step upgrade
  workflow. Merge it into the .NET upgrade agent or a dedicated upgrade
  workflow; do not keep a second, ambient copy.

### MOVE_TO_PROJECT — 2

- `memory-bank.instructions.md` — enable only in repositories that use the
  Memory Bank pattern.
- `task-implementation.instructions.md` — place in the project or workflow
  that actually uses `.copilot-tracking/changes/`.

### REPLACE_BY_HARNESS — 5

Use the PlanB Harness for the standard engineering loop. Preserve only
specialist criteria that are not in the Harness.

- `code-review-generic.instructions.md`
- `devops-core-principles.instructions.md`
- `qa-engineering-best-practices.instructions.md`
- `spec-driven-workflow-v1.instructions.md`
- `update-docs-on-code-change.instructions.md`

### REMOVE — 3

- `copilot-thought-logging.instructions.md` — forces process files and
  phase-by-phase narration for unrelated tasks.
- `no-heredoc.instructions.md` — promotes a tool-specific limitation as a
  universal rule and conflicts with otherwise valid command workflows.
- `tasksync.instructions.md` — demands indefinite session continuation,
  terminal polling, and extra tracking files. These requirements conflict
  with normal user-directed task completion.

### REVIEW — 1

- `update-code-from-shorthand.instructions.md` — `${input:file}` in
  `applyTo` is not established by the other instruction patterns, and there
  is no evidence here of a workflow that needs it. Validate the host support
  and actual use before retaining it.

## Classification of every custom agent

The local plugin READMEs and manifests establish some duplicates. They do
not describe PlanB Harness roles, so the Harness classifications below are
based only on the stated goal that it owns the standard engineering loop.

### KEEP — 12

Retain these distinct specialist agents, subject to normal least-privilege
tool review.

- `adr-generator.agent.md`
- `agent-governance-reviewer.agent.md`
- `apim-implementer.agent.md`
- `github-actions-expert.agent.md`
- `kusto-assistant.agent.md`
- `mcp-m365-agent-expert.agent.md`
- `microsoft-study-mode.agent.md`
- `openapi-reviewer.agent.md`
- `project-documenter.agent.md`
- `prompt-builder.agent.md`
- `sast-sca-security-analyzer.agent.md`
- `trojan-skill-hunter.agent.md`

### MERGE — 19

Reduce overlapping or copied role definitions. Pick one maintained source;
do not preserve multiple near-identical agent prompts.

- `CSharpExpert.agent.md`, `csharp-dotnet-janitor.agent.md`, and
  `dotnet-upgrade.agent.md` — reconcile with the C#/.NET plugin and the
  .NET warning Skill. The `.NET Upgrade` agent description currently says
  “janitorial tasks” while its body describes framework migration.
- `context-architect.agent.md` and `orchestrator.agent.md` — combine only
  their overlapping planning and delegation duties.
- `critical-thinking.agent.md` and `devils-advocate.agent.md` — retain one
  explicit challenge/assumption-testing role if it adds value beyond the
  Harness.
- `modernization.agent.md` and `tech-debt-remediation-plan.agent.md` —
  consolidate their assessment and remediation planning boundaries.
- `repo-architect.agent.md` and `custom-agent-foundry.agent.md` — combine
  project scaffolding and agent/instruction authoring behind one clear
  entry point.
- `ms-sql-dba.agent.md` — the Database & Data Management plugin also lists
  an agent with this ID.
- `playwright-tester.agent.md` — the Testing Automation plugin also lists
  an agent with this ID.
- `research-technical-spike.agent.md` — this role is also listed by the
  local Project Planning plugin.
- `se-gitops-ci-specialist.agent.md`,
  `se-responsible-ai-code.agent.md`, `se-security-reviewer.agent.md`,
  `se-system-architecture-reviewer.agent.md`, and
  `se-technical-writer.agent.md` — the Software Engineering Team plugin
  lists these same five agent IDs. Prefer the plugin's canonical copies
  unless the local versions contain deliberate, documented customizations.

### MOVE_TO_SKILL — 1

- `terminal-helper.agent.md` — command syntax help is a compact reference
  capability, not a distinct multi-step agent role.

### REPLACE_BY_HARNESS — 6

Retire these as default workflow stages if the Harness already owns the
standard engineering loop. Keep an agent only for a separately invoked,
measurably distinct task.

- `devops-expert.agent.md`
- `principal-software-engineer.agent.md`
- `tdd-green.agent.md`
- `tdd-red.agent.md`
- `tdd-refactor.agent.md`
- `wg-code-alchemist.agent.md`

The Testing Automation plugin also lists the TDD trio and `playwright-tester`.
Confirm plugin precedence and Harness coverage before removing or disabling
any local definition.

### REVIEW — 7

The role names alone do not establish whether these duplicate the PlanB
agents Polly, Carl, Tessa, or Rita. Compare each role's purpose, tools,
permissions, and outputs with their actual Harness definitions before
retaining or retiring them.

- `api-architect.agent.md`
- `azure-principal-architect.agent.md`
- `debug.agent.md`
- `doublecheck.agent.md`
- `explorer.agent.md`
- `reasoning.agent.md`
- `specification.agent.md`

## Classification of every Skill

### KEEP — 2

- `skills/apim-openapi/SKILL.md` — a useful on-demand API-contract Skill;
  retain its examples and linked guidelines.
- `skills/dotnet-warning-remediation/SKILL.md` — a focused specialist
  workflow that directly matches the Skills model. De-duplicate its
  overlap with C# instructions and janitor agents.

## Prompts, root guidance, hooks, and configuration

These are ancillary to the 110 instruction, agent, and Skill files counted
above.

| Component | Classification | Recommendation |
|---|---|---|
| `copilot-prompts/analyze-repository.md` | REMOVE | It is empty. |
| `copilot-prompts/architecture-review.md` | MERGE | Consolidate its read-only architecture review criteria with the single retained architecture-review role. |
| `copilot-prompts/ef-core-review.md` | MOVE_TO_SKILL | Keep EF Core-specific review criteria on demand, separate from generic engineering checks. |
| `copilot-prompts/review-changes.md` | REPLACE_BY_HARNESS | Use the Harness review step; retain a prompt only if it provides a distinct user-invoked output format. |
| `copilot-instructions.md` | MERGE | Reduce to a small universal core; move .NET, NuGet, and EF Core rules to project overlays or Skills. |
| `AGENTS.md` | MOVE_TO_PROJECT | Retain repository-specific PR mechanics only where needed; remove duplicated fixed build/test gates after Harness mapping. |
| `README.md` | KEEP | Update after migration so folder names and canonical sources match reality. |
| `hooks/secrets-scanner/` bundle | KEEP | Retain as one bounded, deterministic safeguard. Verify config path and installation layout before changing it. |

The tracked plugin manifests and READMEs are useful evidence for duplicate
roles, but the repository does not include PlanB Harness agent definitions.
The installed-plugin and user settings in ignored runtime state are not a
reliable repository contract and were not used to infer which plugins are
active.

## Major overlaps and conflicts

1. **Several all-path policies compete to control the whole task.** The
   all-path files include process rules, code-review rules, QA rules, DevOps
   principles, security catalogues, performance standards, and formatting
   advice. They repeat priorities and sometimes give conflicting
   instructions about how to communicate, plan, test, and finish.
2. **TaskSync and process tracking conflict with normal task boundaries.**
   TaskSync requires indefinite terminal polling. Process tracking requires
   extra files, rigid phases, and exact response text. Neither belongs in a
   personal universal core.
3. **The Harness, AGENTS, and instruction files all prescribe engineering
   loops.** The PR workflow mandates a .NET restore/build/format/test sequence;
   the spec workflow mandates six phases and multiple artifacts; QA and
   review files prescribe their own checks; TDD agents split implementation
   into three stages. Establish one owner: the PlanB Harness for the standard
   loop, with opt-in specialists for exceptions.
4. **Security, prompt safety, and responsible AI are repeated.** The
   all-path security file covers many unrelated stacks, while agent safety,
   prompt engineering, responsible-AI agents, and plugin prompts overlap.
   Keep a small universal safety core and load domain-specific material only
   when relevant.
5. **Markdown rules conflict and multiply.** Four files all activate on
   Markdown. One requires no H1; another says one H1 is required. Blog
   metadata requirements do not fit every Markdown artifact. Consolidate
   around the actual repository documentation format.
6. **Documentation rules apply too broadly.** The documentation-update rule
   applies across many code extensions and directs README/changelog changes
   in cases where a targeted doc update may not be needed. Prompt-data and
   cliche-data rules repeat restrictions over broad file sets.
7. **The same specialist agent appears in multiple places.** Local agent
   definitions overlap entries named by the Software Engineering Team,
   Testing Automation, Project Planning, C#/.NET, and Database plugins.
   Prefer one canonical source per role and verify plugin version/activation
   before removing local customization.
8. **Project and technology assumptions leak into shared files.**
   `copilot-instructions.md` and `AGENTS.md` include .NET-specific rules.
   ASP.NET, C#, Azure, SQL, Power Apps, MCP, Rust, and other platform
   guidance is available on common file types, sometimes far beyond the
   project scope that needs it.
9. **Some activation metadata needs validation.** The declarative-agent
   pattern starts with `**.json`; the shorthand rule uses `${input:file}`;
   and the prompt-safety rule uses a list-valued `applyTo`. Verify these
   against the actual target host rather than assuming they work.
10. **Hook documentation and configuration may disagree.** The scanner's
    README demonstrates installing under `.github/hooks/`, while its
    checked-in configuration refers to a different root-relative script
    path. Verify how the configuration is loaded and the working directory
    before changing either path.

## CAMS and PlanB Harness overlap

No tracked file in the inspected `instructions/`, `agents/`, `skills/`,
`copilot-prompts/`, or plugin documentation identifies CAMS or defines
Polly, Carl, Tessa, or Rita. The Harness mapping therefore remains
unverified. Do not infer agent responsibilities from names alone.

The intended boundary is clear even without that mapping:

- PlanB Harness owns the default analyze/plan/implement/verify/review loop.
- Custom agents remain for bounded specialist work with distinct tools,
  permissions, inputs, and outputs.
- Skills hold reusable domain knowledge and repeatable specialist procedures.
- A Harness agent should replace a local workflow only after comparing its
  actual contract with that workflow and confirming required checks remain.

## Proposed target architecture

1. **Small personal core:** retain only universal interaction preferences,
   minimal safe-edit behavior, and a concise rule to use evidence before
   claiming verification. Move .NET policy and persona detail out of
   universal context.
2. **Precisely scoped instructions:** use short `applyTo` rules for formats
   and conventions that must activate automatically. Avoid wildcard
   instructions for optional specialist knowledge.
3. **On-demand Skills:** move detailed platform references and repeatable
   specialist procedures into Skills with concise discovery descriptions,
   progressive references, and a small set of high-signal gotchas.
4. **Bounded agents:** keep only genuinely distinct roles or workflows.
   Give each the minimum tools required, and avoid agent definitions that
   merely repeat Harness stages.
5. **Project overlays:** put project-specific .NET, Azure, Power Platform,
   database, and deployment conventions in the relevant project repository,
   not in personal global context.
6. **PlanB Harness:** use it as the sole standard engineering loop. Keep
   optional specialty gates only when the Harness does not provide them.
7. **Explicit ancillary roles:** keep prompts as short, user-invoked
   templates; use hooks only for deterministic automation; treat plugins as
   optional integrations with one canonical copy of each agent.

## Ordered migration slices

Each slice should be a separate reviewable change. Measure context size and
run representative tasks before moving to the next slice.

| Slice | Small change | Verification and exit criteria |
|---|---|---|
| 1. Stop forced continuation | Remove `tasksync.instructions.md` from active instructions. | Search tracked files for TaskSync references. Confirm a task can finish without terminal polling, an extra tracking file, or forced response text. |
| 2. Remove global process noise | Remove `copilot-thought-logging.instructions.md` and `no-heredoc.instructions.md`; retain legitimate user preferences in the core. | Confirm no process-tracking or tool-specific rule is required by an actual repository workflow. Verify normal file editing, shell execution, and task completion remain available. |
| 3. Document Harness contract | Record Polly/Carl/Tessa/Rita roles, tool permissions, expected artifacts, and the Harness verification gate before retiring workflow agents. | A role-to-role comparison identifies what is covered, what remains specialist, and which validations have evidence. |
| 4. Replace generic workflow layer | Replace generic QA, review, DevOps, spec, and documentation loops with concise Harness references. | Run one small code task, one review, and one documentation-only task. Confirm only relevant checks run and no mandatory artifacts are created unnecessarily. |
| 5. Shrink the personal core | Keep universal preferences in `copilot-instructions.md`; move .NET and PR-specific rules to overlays; resolve root-file conflicts. | Compare core character count before/after. Test a non-.NET task and a .NET task to confirm relevant guidance still appears only where intended. |
| 6. Consolidate general cross-cutting rules | Merge safety/prompt guidance, Markdown guidance, code-comment guidance, and documentation privacy rules into small scoped files or Skills. | Check frontmatter and glob behavior. Test prompts, Markdown docs, and code changes for missing guidance and for removal of conflicting H1/front-matter demands. |
| 7. Convert specialist guidance incrementally | Move one domain family at a time into Skills, starting with the largest files: security, performance, GitHub Actions, Microsoft Foundry, Power Platform, and Dev Containers. | Test Skill discovery with representative requests. Confirm unrelated tasks do not load detailed references. Preserve examples and project-specific constraints. |
| 8. Deduplicate agents and plugins | Compare local definitions with plugin-provided roles and Harness contracts. Remove or merge only verified duplicates. | For each changed role, test user invocation, tool permissions, and output. Confirm no needed local customization is lost. |
| 9. Move project rules to overlays | Create project-local instruction overlays only for projects that need them. | Open a matching project and a non-matching project; verify each receives its own rules and not the other's. |
| 10. Clean prompts and ancillary configuration | Remove the empty repository prompt, align prompt names, update README structure, and resolve the hook path discrepancy after confirming runtime behavior. | Validate Markdown, prompt inventory, hook configuration path, and the secrets scanner on harmless fixtures. Do not test with real credentials. |
| 11. Measure and lock in the result | Record before/after active-context sizes by task class and run a small task matrix. | No broad rule activates without purpose; each claim about build/test/hook behavior has a recorded command or test result. |

## Risks and verification criteria

### Risks

- Removing a broad rule may expose an edge case that had useful specialist
  guidance. Preserve unique constraints in a Skill or project overlay before
  retiring the source.
- Harness capabilities may differ from the assumed standard loop. Verify the
  actual agent contracts and tools before replacing local TDD, review, or
  implementation roles.
- Plugin-provided agents may be unavailable, change versions, or omit local
  customizations. Keep local copies only when the difference is intentional
  and documented.
- Skill discovery and instruction glob semantics vary by host. Validate
  activation in the intended Copilot CLI/IDE rather than relying on
  frontmatter syntax alone.
- Moving project rules out of personal core can make them disappear from
  projects without overlays. Identify actual consumers before moving them.
- Context estimates use file characters divided by four; model tokenization,
  host behavior, and deduplication can change real prompt costs.
- The secrets-scanner configuration may not resolve its script path from all
  installation layouts. Verify the path before relying on blocking behavior.

### Verification criteria

- Every instruction, agent, and Skill has exactly one assigned disposition.
- All surviving automatic instructions have a documented file-pattern
  rationale and tested activation.
- The universal core is short, non-contradictory, and contains no
  technology-specific workflow.
- The standard engineering loop has one owner: the PlanB Harness.
- Each custom agent is retained only for unique specialist value, with
  least-privilege tools and no duplicate canonical plugin copy.
- Skills are discoverable from short descriptions and load detailed material
  only for relevant requests.
- A representative task matrix covers a general code change, .NET work,
  security review, Markdown authoring, API/OpenAPI work, and hook operation.
- Test, build, format, review, and hook outcomes are reported only when they
  were actually run and observed.
- The only file changed in this planning task is this cleanup plan.

## Recommended first slice

Remove `instructions/tasksync.instructions.md` first. It is a single,
all-path file with a clear and testable failure mode: it attempts to keep
sessions running indefinitely and forces terminal input after task
completion. This slice is small, immediately reduces context, and does not
depend on knowing the Harness internals. Verify that no other tracked file
requires it and that ordinary tasks still start, finish, and report
verification normally.

## Component counts by classification

Counts below cover all 110 instruction, agent, and Skill components. The
ancillary prompt/root/hook/documentation classifications are listed
separately afterward.

| Classification | Instructions | Agents | Skills | Total |
|---|---:|---:|---:|---:|
| KEEP | 6 | 12 | 2 | 20 |
| SCOPE | 5 | 0 | 0 | 5 |
| MERGE | 20 | 19 | 0 | 39 |
| MOVE_TO_SKILL | 20 | 1 | 0 | 21 |
| MOVE_TO_AGENT | 1 | 0 | 0 | 1 |
| MOVE_TO_PROJECT | 2 | 0 | 0 | 2 |
| REPLACE_BY_HARNESS | 5 | 6 | 0 | 11 |
| REMOVE | 3 | 0 | 0 | 3 |
| REVIEW | 1 | 7 | 0 | 8 |
| **Total** | **63** | **45** | **2** | **110** |

Ancillary components: 4 prompts (1 MERGE, 1 MOVE_TO_SKILL,
1 REPLACE_BY_HARNESS, 1 REMOVE); 2 root guidance files
(1 MERGE, 1 MOVE_TO_PROJECT); README and secrets-scanner bundle (2 KEEP).

## Top 10 cleanup opportunities

1. Remove the 29,047-character all-path TaskSync file.
2. Move the 31,845-character OWASP catalogue out of all-path context into an
   on-demand security Skill.
3. Move the 28,137-character prompt-safety catalogue into a scoped Skill
   and merge its overlap with agent-safety guidance.
4. Move the 27,201-character web performance catalogue into an on-demand
   frontend Skill.
5. Move the 54,220-character GitHub Actions guide to a Skill and leave only
   concise workflow-file rules active.
6. Consolidate four Markdown-wide files (20,773 characters) and resolve
   their H1 and front-matter contradictions.
7. Replace generic QA, code-review, DevOps, and specification loops with
   the PlanB Harness after verifying its contract.
8. Remove or scope the process-tracking file (3,253 characters) and the
   universal no-heredoc rule (2,546 characters).
9. Narrow the 18,240-character documentation-update rule and merge the
   7,913-character cliche-data rule with prompt-data guidance.
10. Deduplicate local TDD, Playwright tester, SQL DBA, and Software
    Engineering Team agents against plugin entries and the Harness.

## Estimated reduction of always-loaded context

The 17 wildcard instruction files total approximately 50,769 tokens by the
rough character heuristic. If the migration replaces them with a concise
personal core of about 1,000-2,000 tokens and moves specialist detail to
Skills, the all-path portion could fall by roughly 96-98% (about 48,800-
49,800 estimated tokens). This is a target estimate, not a runtime token
measurement. Markdown and common-code tasks may currently load additional
wide-scope files, so their potential reduction is larger. Measure actual
context use in the target host before claiming an achieved reduction.

## Remaining unverified

- The definitions, tool permissions, and responsibilities of PlanB Harness
  agents Polly, Carl, Tessa, and Rita are not present in the tracked
  repository.
- No tracked CAMS-specific instruction, agent, Skill, or project overlay
  was found; any CAMS-specific overlap remains unknown.
- Copilot CLI and IDE behavior for each unusual or malformed-looking
  `applyTo` pattern was not tested.
- Plugin installation, active versions, precedence, and runtime availability
  were not inferred from ignored user settings.
- The hook's actual script resolution and blocking behavior were not
  executed.
- No host-level token telemetry was available; all context figures are
  character-based estimates.
- The newest framework and platform recommendations inside domain guidance
  were not independently validated against current official documentation.
