# Workflow: Module Flow

Use this when the user asks to understand a module, package, node lifecycle, controller pipeline, actuator-driver flow, training workflow, validation workflow, or navigation/localization pipeline.

## Steps

1. Map the module boundary:
   - source files
   - package metadata
   - launch/config assets if present
   - tests
   - external dependencies
2. Identify the main flow:
   - entry point
   - initialization
   - data inputs
   - computation or state update
   - outputs
   - shutdown/error path
3. Present a compact route through the files using clickable links.
4. Walk the main flow in order, explaining only the files needed for that flow.
5. Distinguish:
   - must-understand now
   - can defer
   - good follow-up for deeper engineering learning
6. After the main flow is complete, ask whether to deposit the learning summary to wiki.

## Wiki Trigger

Ask before writing:

```text
这个模块主流程已经读完。要不要把本次学习总结沉淀到 wiki？
```

If the user explicitly says "总结一下", "沉淀到 wiki", "写入 wiki", or equivalent, do not ask again; follow `workflows/wiki-deposition.md`.
