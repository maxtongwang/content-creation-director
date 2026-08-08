# 同步清单

创作层（`workflows/`）和 `automation`（发布层）共用同一套字段名。
**改一边就要检查另一边。**

改动前先跑：

```bash
grep -rn "SYNC:" . --include="*.md" --include="*.yaml" --include="*.json"
```

---

## 一、字段对照表

| 概念 | 创作层定义在 | automation 消费在 |
|---|---|---|
| `pillars` 内容支柱 | `templates/profile.template.yaml` | 配额、`pillar_roi` |
| `styles` 风格档案 | 同上 + `workflows/8-styles.md` | 剪辑参数、`style_roi`、风格配比 |
| `content_lines` 内容线 | 同上 | 内容线配比、`line_roi` |
| `targets` 变现目标 | 同上 | 配比权重 |
| `series` 系列 | 同上 | 连发上限、fallback 顺序 |
| `forbidden_topics` | 同上 | A6 定位闸门 |
| `topic_id` | `templates/topic-card.template.yaml` | `ledger.content_layer.topic_ref` |
| `script_id` | `templates/script.template.yaml` | `ledger.content_layer.script_ref` |
| `purpose` 作品目的 | topic-card | `ledger.content_layer.purpose` |
| `hooks_used` 开场句式 | `workflows/4-hook.md` 六类 | `hook_roi` 回验 |
| `platforms` 分平台档案 | `templates/profile.template.yaml` | `per_platform` 配额、平台适配器 |
| `platform_fit` 分平台封装 | `templates/topic-card.template.yaml` | 发布时按平台取对应标题与形态 |

---

## 二、改创作层时要检查 automation

| 改了什么 | 要同步 |
|---|---|
| `profile` 加/删字段 | `automation/spec.automation.yaml` 的 `<<from profile...>>` 引用 |
| `8-styles` 改剪辑参数结构 | `ledger.content_layer.style`、`style_roi`、风格配比 |
| `4-hook` 增删开场句式类型 | `ledger.semantic_index.hooks_used`、`hook_roi` |
| `9-deliver` 改人工守门项 | `spec.automation.yaml` 的 `never_automate` |
| `3-topic` 改闸门规则 | `agents.md` 的 A6 gate_1 |
| `6-edit` 改交付形态 | `agents.md` 的 A2 |
| 新增 workflow 环节 | `SKILL.md` 路由 + `docs/architecture.md` 图 + 本文件 |

---

## 三、改 automation 时要检查创作层

| 改了什么 | 要同步 |
|---|---|
| 配额数值 | `workflows/3-topic.md` 的闸门检查项 |
| 平台约束（标题长度等） | `workflows/4-hook.md` 的硬约束 |
| 指标口径 | `workflows/7-review.md` 的诊断标准 |
| `reuse_policy` | `workflows/3-topic.md`（不得以「讲过了」否决） |
| ledger 字段 | `templates/ledger.template.yaml`（精简版必须同步） |

---

## 四、已知的未完成同步

> 每次动结构时更新本节。

### ⚠️ `templates/ledger.template.yaml` 是精简版
完整版在 `automation/ledger.schema.yaml`。
两者字段必须一致——目前 template 缺 `semantic_index` 的部分字段、缺 `reuse_policy`。
**决定**：template 保持精简（创作层只需要读，不需要写全量），
但**字段名不得冲突**。加字段先加到 schema，再决定要不要进 template。

### ⚠️ `style` 是 v0.1 新增维度
旧的 spec 里没有「风格」概念。以下位置是新加的，尚未经实测验证：
- `spec.automation.yaml` → `rhythm.max_consecutive_same_style`
- `spec.automation.yaml` → `quotas.风格配比`
- `ledger.schema.yaml` → `content_layer.style`、`derived.style_roi`

**待验证**：风格配比的窗口（12）和权重来源是否合理。跑三个月再定。

### ⚠️ `hook_roi` 尚无数据
`4-hook` 的六类开场句式是设计出来的，没有实测支撑。
`ledger.derived.hook_roi` 就是为了验证它们——**跑够样本前不要当结论用**。

### ⚠️ `archive/viral-rules.yaml` 的定位
那是早期的规律库骨架，`conflict_level` 分级机制现已由
`agents.md` 的 A6 三道 gate 取代。**保留作为溯源，不再维护。**

---

## 五、版本约定

- 创作层改结构 → 升 minor（0.1 → 0.2）
- `automation` 单独改数值 → 升 patch
- 两层字段不一致 → **不允许发版**，先补同步
