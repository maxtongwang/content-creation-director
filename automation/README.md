# automation · 发布与记账层

创作层（`workflows/`）管**创作**（定位 → 选题 → 脚本 → 剪辑）。
`automation/` 管**发布之后的事**（分发 → 记账 → 回采 → 配额 → 排期）。

两层通过 `ledger` 连接：

```
创作层产出内容  →  发布  →  ledger 记账  →  数据回采
                                    ↓
                        配额判断 ← 回流到 workflows/7-review
```

---

## 为什么要分两层

创作是**一次性**的（这条内容怎么做），发布是**连续性**的（最近 10 条的配比对不对）。
两者的判断依据完全不同：

| | 创作层 | automation |
|---|---|---|
| 判断单位 | 单条内容 | 滚动窗口（近 N 条） |
| 依赖 | `profile.yaml` | `ledger` |
| 失败表现 | 这条不好看 | 账号跑偏了 |

`workflows/7-review.md` 的诊断依赖本层的 `ledger` 和数据回采。
**没有 ledger，配额类规则全是空转。**

---

## ⚠️ 同步责任

本层的字段名必须与 `templates/profile.template.yaml` 保持一致。

**创作层工作流更新时，本层可能需要跟着改。**
所有需要同步的位置都标了 `# SYNC:` 注释，改动前先搜一遍：

```bash
grep -rn "SYNC:" automation/ templates/ workflows/
```

同步清单见 [`../docs/sync-notes.md`](../docs/sync-notes.md)。

---

## 文件

| 文件 | 内容 |
|---|---|
| `spec.automation.yaml` | 平台能力、配额、节奏、发布策略 |
| `ledger.schema.yaml` | 发布履历完整结构（双层 + 时间序列指标） |
| `agents.md` | 自动化 agent 的职责边界与建设顺序 |
