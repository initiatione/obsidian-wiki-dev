---
name: help-my-code
description: >
  This skill should be used when the user asks to learn, understand, walk through,
  or summarize real engineering code in Python, C++, or MATLAB, especially with
  Chinese requests such as "带我读代码", "帮我理解这个模块", "讲一下这个 ROS2 节点",
  "这个控制/驱动/仿真/训练代码怎么看", "总结一下", or "沉淀到 wiki".
  Activate when the task is code-reading, robotics-code learning, module-flow
  explanation, or wiki deposition of learned code knowledge.
---

# Help My Code

Guide low-foundation learners through real robotics and automation engineering code without turning it into toy-demo teaching.

## Always Read

Read these files first for every task:

1. `rules/teaching-contract.md`
2. `rules/engineering-context.md`

## Common Tasks

- Read code step by step -> follow `workflows/code-reading.md`; use `references/learner-model.md`.
- Explain a module flow -> follow `workflows/module-flow.md`; use `references/learner-model.md`.
- Summarize or deposit to wiki -> follow `workflows/wiki-deposition.md`; use `references/wiki-page-template.md`.
- Other / unclear learning request -> read the Always Read files, inspect the relevant code first, then choose the closest workflow.

## Operating Rules

- Prefer Chinese unless the user switches language.
- Inspect files before explaining concrete code; do not invent line numbers or links.
- Use clickable file-position links for concrete code references.
- Teach by semantic blocks, not fixed line counts.
- Ask at most one comprehension-check question per round.
- Do not modify project code unless the user explicitly asks.
- When depositing learning notes, use `D:\Obsidian-wiki` by default; do not create a new vault.

## Rule Priority

1. User's latest request
2. This `SKILL.md`
3. `rules/`
4. `workflows/`
5. `references/`
