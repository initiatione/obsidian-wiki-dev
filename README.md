# liuchf Wiki Skills

这是我给自己维护的通用 wiki skill 分支，基于上游
[Ar9av/obsidian-wiki](https://github.com/Ar9av/obsidian-wiki)，面向我实际使用的 Codex 和 Claude。

它的目标不是把某一个 Obsidian vault 写死进 skill，而是提供一组通用的 wiki 维护能力：任何项目都可以作为知识来源，任何 vault 都可以通过自己的 `AGENTS.md` 和 `_meta/*` contract 决定最终怎么写入。

维护命令、分支同步和本机 junction 安装见 [MAINTENANCE.md](MAINTENANCE.md)。

## 这个分支解决什么问题

普通对话会把知识留在一次性上下文里；普通 RAG 往往每次重新检索、重新解释。这个分支采用 LLM Wiki 思路：把值得长期保存的知识蒸馏成 Obsidian markdown 页面，让 agent 负责维护知识图谱，人负责校准规则和事实边界。

这个分支重点支持三件事：

- 从项目、文档、网页、会话历史中抽取可复用知识。
- 把新知识合并进已有 wiki，而不是制造重复笔记。
- 让不同 vault 用自己的本地 contract 管 schema、目录、标签、语言风格和安全边界。

## Skill 功能图谱

核心方法层：

- `llm-wiki`：定义 LLM Wiki 的基础模式、frontmatter、关系、置信度、生命周期、检索成本控制等通用原则。
- `wiki-setup`：初始化或修复一个 Obsidian wiki vault。
- `wiki-switch`：在多个 vault profile 之间切换。

写入与导入层：

- `wiki-ingest`：把文档、PDF、图片、网页剪藏、`_raw/` 草稿蒸馏成 wiki 页面。
- `wiki-update`：从任意项目目录同步项目知识到 wiki。
- `obsidian-wiki-ingest`：项目内自动化 ingest 包装入口。
- `data-ingest`：导入原始文本、聊天导出、日志和非结构化资料。
- `ingest-url`：抓取 URL 并写入 wiki。
- `wiki-import`：导入外部 wiki/markdown 资料。
- `wiki-stage-commit`：处理 staged writes，把 `_staging/` 中的拟写入内容提升到正式位置。

查询与上下文层：

- `wiki-query`：用 wiki 回答问题，先读 index/frontmatter，再按需升级到 QMD、grep、页面全文。
- `wiki-context-pack`：为当前任务打包相关 wiki 上下文。
- `memory-bridge`：按不同 agent 来源浏览、比较 wiki 知识。

会话与研究捕获层：

- `help-my-code`：面向低基础学习者的真实机器人工程代码导读，支持可点击代码定位链接，并在模块主流程读完后沉淀学习总结到 wiki。
- `wiki-capture`：把当前对话保存成结构化 wiki note。
- `wiki-quick-chat-capture`：快速把会话中的 bug、经验、待办捕获到 `_raw/`。
- `wiki-research`：多轮 web research 后把结论写入 wiki。
- `wiki-history-ingest`：统一的 agent 历史导入入口。
- `wiki-agent`：按主题从指定 agent 历史中定向挖掘。
- `claude-history-ingest`、`codex-history-ingest`：分别导入 Claude 和 Codex 历史。

维护与治理层：

- `wiki-status`：查看 ingest 状态、pending source、token footprint、staged writes。
- `daily-update`：日常维护循环，刷新 source freshness、index 和 hot cache。
- `wiki-lint`：检查孤儿页、坏链接、frontmatter、重复和健康问题。
- `cross-linker`：自动发现并补充缺失 wikilink。
- `tag-taxonomy`：维护受控标签词表。
- `wiki-dedup`：发现并合并重复页面。
- `wiki-digest`：生成可阅读的 wiki 摘要。
- `wiki-synthesize`：发现跨页面综合机会。
- `wiki-dashboard`：生成 Obsidian Bases dashboard。
- `graph-colorize`：按标签、目录或 visibility 给 Obsidian graph 上色。
- `wiki-export`：导出知识图谱供外部工具使用。

开发与自检层：

- `skill-creator`：创建或改进 skill。
- `impl-validator`：对 agent/skill 产物做独立校验。

本机安装默认排除其他 agent 专属历史 skill：`hermes-history-ingest`、`openclaw-history-ingest`、`copilot-history-ingest`、`pi-history-ingest`。这些文件保留在仓库里，方便继续跟上游合并，但不进入我的 Codex/Claude 常用 skill 面。

## Obsidian Companion Skills

本分支可以和 [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) 并列安装。它不是替代 `wiki-*`，而是 Obsidian 格式与工具能力层。

| Companion skill | 在本系统中的角色 |
|---|---|
| `obsidian-markdown` | 帮助写出 Obsidian-flavored Markdown：properties、wikilinks、embeds、callouts、tags |
| `obsidian-bases` | 帮助创建和编辑 `.base` dashboard |
| `json-canvas` | 当用户明确要 Canvas、mind map、flowchart 时，帮助生成 `.canvas` |
| `obsidian-cli` | 仅在需要和运行中的 Obsidian app 交互时使用 |
| `defuddle` | 网页 ingest / research 前清洗网页正文，减少噪声和 token |

协作原则：

- `wiki-*` 仍是知识工作流主控，决定读什么、写什么、合并到哪里、如何标注 provenance。
- 目标 vault 的 `AGENTS.md` 和 `_meta/*` 永远高于 companion skill 的默认格式建议。
- companion skill 缺失或工具不可用时，`wiki-*` 应回退到自身流程，不应阻塞普通 wiki 维护。
- `obsidian-cli` 不用于常规 markdown 写入；只有用户明确要求 live Obsidian 操作时才使用。
- 本仓库同步脚本默认只安装 `obsidian-wiki` 主控 skills；需要 companion 层时显式使用 `-IncludeCompanionSkills`。

## Wiki 维护思路

这个分支倾向把 wiki 当作长期知识系统，而不是资料堆。

写入时优先问：

- 这条内容三个月后还值得找回吗？
- 它应该合并到已有概念，还是确实需要新页面？
- 哪些事实是源材料直接说的，哪些是 agent 推理出来的？
- 这条知识应该是项目局部知识，还是可提升为全局概念？

页面维护的默认原则：

- 先合并，后新建：已有概念页能承载时，不创建重复节点。
- 先结构，后文采：frontmatter、summary、sources、tags、wikilinks、relationships 比漂亮段落更重要。
- provenance 明确：直接来源无需标记，推理用 `^[inferred]`，不确定或冲突用 `^[ambiguous]`。
- lifecycle 保守：agent 可以写 draft，但 verified、archived、disputed 等状态应尊重 vault contract 或人工判断。
- 查询分层：先 index/frontmatter，再 QMD/grep，再少量全文阅读，避免把整个 vault 当上下文塞进去。

## 通用 Skill + Vault Contract

本分支最重要的结构是两层规则：

```text
通用 wiki skill
  定义能力、流程、frontmatter 约定、检索策略、QMD 接口、默认写作原则

目标 vault contract
  定义这个 vault 的目录、schema、taxonomy、语言风格、数学规则、source-of-truth 边界
```

实际优先级：

1. 用户当前明确指令。
2. 目标 vault 根目录的 `AGENTS.md`。
3. 目标 vault 的 `_meta/agent-operating-contract.md`。
4. 目标 vault 的 `_meta/schema.md`、`_meta/taxonomy.md`、`_meta/directory-structure.md`。
5. 本仓库 `.skills/` 中的通用 `llm-wiki` / `wiki-*` skill。
6. 上游默认行为。

这意味着同一套 skill 可以服务多个 vault。每个 vault 只需要提供更高优先级的本地 contract，就能决定：

- 页面放在哪些目录。
- 哪些 frontmatter 字段必须存在。
- 标签如何归一化。
- 普通知识页使用中文还是英文。
- 数学、LaTeX、Obsidian wikilink 怎么写。
- 哪些内容只能读不能写，哪些源更可信。

## 源项目规则与目标 Vault 规则

从项目同步到 wiki 时，需要分清两类规则：

- 源项目规则：决定怎么理解当前项目、哪些文件是事实源、哪些生成物不要误改、应该用哪个解释器或测试环境。
- 目标 vault 规则：决定理解出来的知识如何写进 wiki、放在哪、用什么标签、如何链接和标注 provenance。

例如在一个代码仓库里运行 `wiki-update`：

1. 先读源项目的 `AGENTS.md`、README、测试和配置，理解项目事实。
2. 再读目标 vault 的 `AGENTS.md` 与 `_meta/*`，决定写入规则。
3. 最后用通用 `wiki-update` 流程蒸馏、合并、更新 index/log/hot。

源项目不会支配目标 vault 的写作规则；目标 vault 也不会改变源项目的事实边界。这个隔离是为了避免“把项目规则误当成 wiki 规则”，也避免“把 wiki 风格反向污染源项目”。

## QMD 的位置

QMD 是可选搜索索引，不是事实源。

启用后，`wiki-query` 可以先用 QMD 做语义召回，`wiki-ingest` 和 `wiki-update` 可以先查已有相关页面，减少重复写入。未启用时，所有核心 skill 仍应回退到 index、frontmatter、grep 和少量全文读取。

常用变量包括：

```text
QMD_TRANSPORT=mcp
QMD_CLI=qmd
QMD_WIKI_COLLECTION=...
QMD_PAPERS_COLLECTION=...
QMD_CLI_SEARCH_MODE=quality
```

Markdown vault 始终是 source of truth；QMD 只负责帮 agent 更快找到该读的页面。

## 上游关系

上游 `Ar9av/obsidian-wiki` 负责通用能力演进；本分支负责个人使用面：

- 保留上游 `.skills/` 全量文件，方便 rebase/merge。
- 只把 Codex 和 Claude 需要的通用 skill 安装到本机。
- 把个人规则固化为“通用 skill + vault-local contract”，而不是写死某个 vault 路径。

许可证和上游通用说明以 [Ar9av/obsidian-wiki](https://github.com/Ar9av/obsidian-wiki) 为准。
