# Wiki Page Template

Use this as a starting point. Adapt category, path, tags, and links to the target vault's local rules.

```markdown
---
title: <module-name> 代码导读
category: projects
tags: [robotics, code-reading, engineering]
aliases: []
source_project: <project-or-repo-name>
source_files: ["<relative/path/to/file.py>"]
summary: <不超过 200 字的模块主流程学习总结。>
provenance:
  extracted: 0.70
  inferred: 0.30
  ambiguous: 0.00
base_confidence: 0.59
lifecycle: draft
lifecycle_changed: <YYYY-MM-DD>
tier: supporting
created: <ISO timestamp>
updated: <ISO timestamp>
---

# <module-name> 代码导读

## 学习范围

- 本次阅读的真实代码：<clickable code links>
- 模块边界：<package/module/node/workflow>

## 主流程

按真实执行顺序说明输入、初始化、计算/状态更新、输出、错误或退出路径。

## 关键概念

- <概念>：用通俗中文解释，并链接回真实代码。

## 工程写法

- <可迁移写法>：说明为什么这是工程写法，不是 demo 写法。

## 工程性能观察

- 速度、实时性、稳定性、可维护性、可调试性、可部署性或资源占用方面的观察。
- 对代码没有证据的判断要标 `^[inferred]`。

## 还没完全掌握

- <后续需要继续读或补基础的点>

## 下一步阅读路线

- <下一个文件/函数/测试/配置，附代码链接>

## Sources

- <project path or source files>
```
