# Workflow: Wiki Deposition

Use this when the user explicitly asks to summarize, deposit, write, or save a code-learning session to wiki, or after a module-flow reading when the user confirms deposition.

## Setup

1. Use `D:\Obsidian-wiki` as the default target vault.
2. Do not create a new wiki vault and do not run wiki setup.
3. If the user explicitly provides another vault path for the current task, use that path only for that task.
4. Keep the source-code repository untouched unless the user explicitly asks for source edits.
5. Read vault-local rules if present:
   - `AGENTS.md`
   - `_meta/schema.md`
   - `_meta/taxonomy.md`
   - `_meta/directory-structure.md`
6. Use `references/wiki-page-template.md` as the starting template, adapting category/path to vault rules.

## Page Grain

- Write at module-flow granularity.
- Do not create one page per tiny function or chat fragment.
- A page may cover a ROS2 package/module, node lifecycle, controller pipeline, actuator-driver flow, training/validation workflow, or navigation/localization pipeline.
- Include multiple related files when they belong to the same learning unit.

## Content Rules

- Distill learning, not chat chronology.
- Write Chinese-first prose.
- Preserve real code links to exact files and lines.
- Include what was learned from real engineering code.
- Include reusable engineering patterns and performance/reliability observations.
- Mark inferred claims with `^[inferred]` and uncertainty with `^[ambiguous]`.
- Do not store secrets, private credentials, or irrelevant personal details.

## After Writing

- Update root `index.md`, `log.md`, and `hot.md` when the vault convention requires it.
- Update `.manifest.json` if the vault uses manifest tracking for project/code learning pages.
- Refresh QMD only if the vault config provides `QMD_WIKI_COLLECTION`; keep vault writes even if QMD fails.
- Report the written page path and whether indexing/bookkeeping was updated.
