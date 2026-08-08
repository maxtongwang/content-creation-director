# content-creation-director

**中文自媒体编导工作流** —— 一个可安装的 Claude Skill。

把「做自媒体」拆成 13 个可执行环节，每个环节产出**结构化文件**，
文件在环节之间传递，末端可直接驱动自动剪辑。

装上之后，Claude 就能陪你从零把一个账号做起来并持续运营：
定位 → 选题 → 脚本 → 剪辑 → 发布 → 复盘 → 回流重做。

---

## In English

A Claude Skill for planning and running a Chinese social-media account
(Xiaohongshu / Douyin). It breaks account operation into 13 stages and makes
each stage emit a **structured file** that the next stage consumes as input —
positioning, topic selection, hooks, scripts, shot lists, edit plans,
performance review.

|                  |                                                                                   |
| ---------------- | --------------------------------------------------------------------------------- |
| What you install | A skill folder, or a built `.skill` bundle                                        |
| What it produces | `profile.yaml`, `topic-card.yaml`, `script.yaml`, `edit-plan.json`, `ledger.yaml` |
| Who it is for    | Creators starting an account, or fixing one that is not working                   |
| Language         | Workflows, templates and output are all in Chinese                                |

Install with the commands under [安装](#安装) below, then just describe your
account to Claude in Chinese — the skill triggers on its own.

---

## 安装

三选一。**方式一**最省事，改了代码立刻生效。

### 方式一 · Claude Code（推荐）

```bash
git clone https://github.com/maxtongwang/content-creation-director.git \
  ~/.claude/skills/content-creation-director
```

装完就能用，重开一个会话即可。想跟着仓库更新：

```bash
cd ~/.claude/skills/content-creation-director && git pull
```

> 这种装法会把整个仓库放进 skills 目录，包含 `archive/`（`.skill` 打包时是排除掉的）。
> `SKILL.md` 不会引用它，不影响运行；介意的话用方式二。

### 方式二 · 打包成 .skill 上传

适合在 Claude 网页版 / 桌面版里用。

```bash
git clone https://github.com/maxtongwang/content-creation-director.git
cd content-creation-director
bash scripts/build.sh          # 生成 dist/content-creation-director.skill
```

在 Claude 的 **Settings → Skills** 里上传生成的 `.skill` 文件。

### 方式三 · 只给某个项目用

```bash
git clone https://github.com/maxtongwang/content-creation-director.git \
  <你的项目>/.claude/skills/content-creation-director
```

### 装好了怎么确认

| 检查         | 预期                                                              |
| ------------ | ----------------------------------------------------------------- |
| 目录结构     | `<装的位置>/SKILL.md` 存在                                        |
| 会话里问一句 | 「我想做个小红书号，帮我看看怎么定位」                            |
| 正常表现     | Claude 开始走 `0-intake` 或 `1-account`，问你事实而不是给泛泛建议 |

---

## 怎么用

**不需要背命令。**直接用中文说你要干什么，skill 会自己接管并选路径。

| 你说                           | 进入                              |
| ------------------------------ | --------------------------------- |
| 「我想做个号，但不知道做什么」 | `1b-discover` 挖素材              |
| 「我号做了半年没起色」         | `1c-backfill` 反推定位 + 断层报告 |
| 「这条选题行不行」             | `3-topic` 选题决策                |
| 「帮我写个脚本」               | `5-script` 脚本与分镜             |
| 「这个标题怎么样」             | `4-hook` 标题·封面·开头           |
| 「数据不好，帮我看看」         | `7-review` 复盘诊断               |

**产出会落成文件。**每个环节产出一份结构化文件，下一环节把它当输入读。
个人产出文件已在 `.gitignore` 里排除，不会误提交回仓库。

**第一次用，从定位开始。**没有 `profile.yaml`，后面所有环节都缺输入。

---

## 这是一张网，不是一条线

统一入口直达任何环节；环节之间横向跳转；三种循环强制回流；
所有分支汇聚到统一验收再出口。完整架构图见 [`docs/architecture.md`](docs/architecture.md)。

---

## 数据流

```
profile.yaml  →  topic-card  →  script  →  edit-plan  →  ledger  →  diagnose ↺
   我是谁         拍什么        怎么拍      怎么剪       发了什么     哪出问题
```

上一环节的输出是下一环节的**输入**，不是参考。

---

## 环节

| #   | 环节               | 产出                               |
| --- | ------------------ | ---------------------------------- |
| 0   | 需求澄清           | 判断走哪条路（最多 3 个问题）      |
| 1   | 账号定位           | `profile.yaml`                     |
| 1b  | 素材挖掘（零基础） | 候选支柱清单                       |
| 1c  | 逆向导入（有账号） | 反推 profile + 断层报告            |
| 2   | 人设 IP 与验证     | `profile.yaml` 的 ip 段            |
| 3   | 选题决策           | `topic-card.yaml`                  |
| 4   | 标题·封面·开头     | `topic-card` 的 hook 段            |
| 5   | 脚本与分镜         | `script.yaml`                      |
| 6   | 剪辑交付           | `edit-plan.json` / `edit-sheet.md` |
| 7   | 复盘诊断           | 诊断 + 回流指令                    |
| 8   | 风格档案           | `profile.yaml` 的 styles 段        |
| 9   | 统一交付验收       | 所有分支的唯一出口                 |
| 10  | 编导训练           | 前后对照 + 验收标准                |

---

## 三种用户，三条入口

| 用户状态             | 入口                        | 为什么                                 |
| -------------------- | --------------------------- | -------------------------------------- |
| 零基础，说自己很普通 | `1b-discover` → `1-account` | 「你有什么」问不出来，得先挖事实       |
| 有账号有数据，想提效 | `1c-backfill` → 按断层切入  | 真实定位藏在已发内容里，不在自我描述里 |
| 有想法没成体系       | `0-intake` → `1-account`    | 常规路径                               |

---

## 三种剪辑交付

| 用户能力 | 产出                                        |
| -------- | ------------------------------------------- |
| 交给 AI  | `edit-plan.json`（机器执行）                |
| 自己剪   | `edit-sheet.md`（人读，带「为什么这么切」） |
| 半自动   | 两份都给：AI 出粗剪，人做精修               |

---

## 六条核心原则

1. **定位是闸门，爆款是放大。** 爆款元素只能在定位允许的范围内放大。
2. **一条数据流贯穿始终。** 上一环节的输出是下一环节的输入。
3. **剪辑能像成片，是因为分镜在脚本阶段就定完了。** 剪出来不对，先回脚本查 `cut_reason`。
4. **风格是一组剪辑参数，不是标签。** 剪之前先识别，识别不出就问。
5. **逼出否定比收集信息更重要。** 没有 `forbidden_topics` 的 profile 是废的。
6. **能循环的地方一定要循环。** 验收不过、复盘有问题、能力有短板，都回对应环节重做。

---

## 复用

所有个人化内容都通过流程重新产出，`templates/` 里是空模板。
换一个用户，从 `1-account`（或 `1b` / `1c`）重新走一遍即可。

---

## 两层结构

```
创作层（workflows/）  定位 → 选题 → 脚本 → 剪辑     判断，不能自动化
       ↓ ledger
automation（发布层）  分发 → 记账 → 配额 → 排期     规则，可以自动化
       ↑ 回流到 7-review
```

**创作靠判断，发布靠规则。**两层共用字段名，改任一层前查
[`docs/sync-notes.md`](docs/sync-notes.md)。

---

## 目录

```
SKILL.md              统一入口与路由
workflows/            13 个环节（创作层）
references/           方法论（skill 运行时读取，已改写为通用表述）
templates/            5 个结构化模板
automation/           发布与记账层（配额 · ledger · agents）
archive/              研究存档（学习笔记，不打包进 skill）
docs/architecture.md  架构图
docs/sync-notes.md    两层字段同步清单
scripts/build.sh      一键打包
```

---

## 关于 archive/

`archive/` 保留了原作者署名，**建议仓库保持 Private**。
该目录不会打包进 `.skill`，`build.sh` 会跳过它。详见
[`archive/README.md`](archive/README.md)。

要公开仓库的话，需要先清理该目录及其历史，或取得原作者许可。
`references/` 已改写成通用表述、去掉姓名，那部分公开是安全的。

---

## 许可

MIT（不含 `archive/` —— 该目录为第三方内容的学习笔记，权益归原作者）
