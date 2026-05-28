# liuchf Wiki Skills Maintenance

这是 `liuchf/wiki-skills` 分支的个人运维手册。README 介绍 skill 能力和 wiki 维护模型；本文件只记录分支、remote、本机同步和验证命令。

## 分支策略

长期只维护两个分支：

- `main`：尽量保持等同于 `upstream/main`，不放个人修改。
- `liuchf/wiki-skills`：个人通用 wiki skill 适配分支，本机 Codex/Claude 实际使用这一分支。

当前 remote 结构：

```powershell
git remote -v
# origin   https://github.com/initiatione/obsidian-wiki-dev.git
# upstream https://github.com/Ar9av/obsidian-wiki.git
```

说明：GitHub 当前账号 `initiatione` 已存在此上游项目的 fork，仓库名是 `obsidian-wiki-dev`，所以本机 `origin` 使用这个实际 fork。

## 本机安装

本机用 Windows junction 把选定 skill 指向当前分支的 `.skills/`。

目标目录：

- `C:\Users\liuchf\.codex\skills`
- `C:\Users\liuchf\.claude\skills`

先 dry-run：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-liuchf-skills.ps1
```

确认后应用：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-liuchf-skills.ps1 -Apply
```

脚本只处理目标 skill 名单，不会删除 Codex/Claude 目录里已有的非目标 skill。替换已有普通目录或文件前，会先移动到对应的 `skills-backup\<timestamp>\`。

## 同步名单

默认同步 `.skills/` 下所有带 `SKILL.md` 的通用 wiki skills，并排除其他 agent 专属历史 skills：

- `hermes-history-ingest`
- `openclaw-history-ingest`
- `copilot-history-ingest`
- `pi-history-ingest`

如需临时同步指定 skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-liuchf-skills.ps1 -Apply -SkillNames wiki-query,wiki-update
```

## 更新上游

常规流程：

```powershell
git fetch upstream

git switch main
git reset --hard upstream/main
git push origin main --force-with-lease

git switch liuchf/wiki-skills
git rebase upstream/main
git push origin liuchf/wiki-skills --force-with-lease
```

冲突处理原则：

- 保留上游新增 skill 和安装能力。
- 保留本分支的 vault-local contract 读取协议。
- 保留 QMD CLI/MCP 配置入口。
- 保留中文优先、Obsidian 数学渲染和 LaTeX 写作规则。
- 不把任何单一 vault 路径写进通用 skill。

更新后再次运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-liuchf-skills.ps1 -Apply
```

因为 Codex/Claude 使用 junction，通常只要当前分支文件更新，agent 读到的就是同一份新 skill。

## QMD 配置

wiki skill 通过 config resolution 读取配置，优先级由 `llm-wiki/SKILL.md` 定义。常用位置是项目 `.env` 或 `~/.obsidian-wiki/config`。

常用变量：

```text
OBSIDIAN_VAULT_PATH=...
OBSIDIAN_LINK_FORMAT=wikilink
QMD_TRANSPORT=mcp
QMD_CLI=qmd
QMD_WIKI_COLLECTION=...
QMD_PAPERS_COLLECTION=...
QMD_CLI_SEARCH_MODE=quality
```

QMD 是搜索索引，不是 wiki 的事实源。Markdown vault 仍然是 source of truth。

## 常用验证

查看当前分支和 remote：

```powershell
git status --short --branch
git branch -vv
git remote -v
```

确认远端分支：

```powershell
git ls-remote origin refs/heads/main refs/heads/liuchf/wiki-skills
```

检查 junction：

```powershell
Get-Item C:\Users\liuchf\.codex\skills\wiki-query
Get-Item C:\Users\liuchf\.claude\skills\wiki-query
```

检查 skill 可读：

```powershell
Test-Path C:\Users\liuchf\.codex\skills\wiki-query\SKILL.md
Test-Path C:\Users\liuchf\.claude\skills\wiki-query\SKILL.md
```

检查 Claude firecrawl skills 没被误动：

```powershell
Get-ChildItem C:\Users\liuchf\.claude\skills\firecrawl*
```

检查目标 vault 没被这套维护流程误改：

```powershell
git -C D:\Obsidian-wiki status --short
```

## 本次初始化记录

首次应用本同步脚本时，Codex 侧已有 wiki skill 普通目录已备份到：

```text
C:\Users\liuchf\.codex\skills-backup\20260529-063808\
```

Codex 和 Claude 当前均通过 junction 指向：

```text
C:\Users\liuchf\tools\obsidian-wiki\.skills\
```
