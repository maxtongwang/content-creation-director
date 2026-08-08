# content-creation-director

**中文自媒体编导工作流** —— 一个可安装的 Claude Skill。

把「做自媒体」拆成 15 个可执行环节，每个环节产出**结构化文件**，
文件在环节之间传递，末端可直接驱动自动剪辑。

装上之后，Claude 就能陪你从零把一个账号做起来并持续运营：
定位 → 选题 → 脚本 → 剪辑 → 发布 → 复盘 → 回流重做。

**支持小红书 / 抖音 / YouTube**，分平台判断什么算好内容。
接上 MCP 之后还能直接读你的账号数据，不用你一条条贴。

---

## In English

A Claude Skill for planning and running a Chinese social-media account
(Xiaohongshu / Douyin / YouTube). It breaks account operation into 15 stages and makes
each stage emit a **structured file** that the next stage consumes as input —
positioning, topic selection, hooks, scripts, shot lists, edit plans,
performance review.

|                  |                                                                                   |
| ---------------- | --------------------------------------------------------------------------------- |
| What you install | A skill folder, or a built `.skill` bundle                                        |
| What it produces | `profile.yaml`, `topic-card.yaml`, `script.yaml`, `edit-plan.json`, `ledger.yaml` |
| Who it is for    | Creators starting an account, or fixing one that is not working                   |
| Language         | Workflows, templates and output are all in Chinese                                |
| Platforms | Xiaohongshu, Douyin, YouTube — each judged by its own standard |
| Optional | Connect the Xiaohongshu / YouTube MCP servers and it reads your account directly |

It is a **generator, not a checker** — ask for topics and you get 8, ask for a
title and you get 10. Style, fixed elements (intro, catchphrase, recurring
segments) and verified findings persist in `profile.yaml`, so it stops asking
things you already told it and gets sharper the longer you use it.

Native install for **Claude Code** and **Claude desktop/web/mobile**; usable as a
knowledge base in **ChatGPT** and via `AGENTS.md` in **Codex CLI**. See
[安装](#安装), then just describe your account to Claude in Chinese — the skill
triggers on its own.

---

## 安装

按你用的工具选一条。前两条是原生支持，后两条是「拿它当参考资料用」。

| 工具 | 支持程度 | 装法 |
|---|---|---|
| Claude Code | 原生 | 克隆进 skills 目录 |
| Claude 桌面版 / 网页 / 手机 | 原生 | 上传打包好的 `.skill` |
| ChatGPT | 非原生 | 建 Project，把文件当知识库 |
| Codex CLI | 非原生 | 克隆后在 `AGENTS.md` 里指过去 |

---

### Claude Code

```bash
git clone https://github.com/maxtongwang/content-creation-director.git \
  ~/.claude/skills/content-creation-director
```

重开一个会话即可用。跟随更新：

```bash
cd ~/.claude/skills/content-creation-director && git pull
```

项目级安装把路径换成 `<你的项目>/.claude/skills/content-creation-director`。

---

### Claude 桌面版 / 网页 / 手机

先打包，再上传：

```bash
git clone https://github.com/maxtongwang/content-creation-director.git
cd content-creation-director
bash scripts/build.sh          # 生成 dist/content-creation-director.skill
```

**Settings → Capabilities → Skills → 上传该文件**，然后重启客户端。

上传后 skill 存在你的账号上，**网页、手机、桌面版都会自动同步**，只需传一次。

---

### ChatGPT

ChatGPT 没有 skill 机制，但这套东西本质是「一份路由 + 一批工作流文档」，
当知识库用一样成立。

1. 新建一个 **Project**
2. 把 `SKILL.md`、`workflows/`、`references/`、`templates/` 里的文件上传为项目文件
3. 把 `SKILL.md` 的正文粘进 **Project instructions**（那是路由表，决定什么时候读哪个文件）

**差别要知道**：ChatGPT 不会像 Claude 那样按需只读一个环节文件，
它一次看到全部上下文——所以路由的「不要一次读全部」在这里失效，
效果会比原生 skill 差一些，但流程和判断标准照样能用。

---

### Codex CLI

Codex 读 `AGENTS.md`。克隆到项目里，然后在 `AGENTS.md` 指过去：

```bash
git clone https://github.com/maxtongwang/content-creation-director.git \
  .agents/content-creation-director
```

```markdown
<!-- AGENTS.md -->
## 内容创作

做自媒体相关的事（定位、选题、脚本、剪辑、复盘）时，
先读 `.agents/content-creation-director/SKILL.md`，按其中的环节地图选文件。
不要一次读全部。
```

也可以直接把 `SKILL.md` 的内容并进 `AGENTS.md`，省一次跳转，代价是每次都占上下文。

---

### 装好了怎么确认

| 检查 | 预期 |
|---|---|
| 文件在位 | `<装的位置>/SKILL.md` 存在 |
| 会话里问一句 | 「我想做个小红书号，帮我看看怎么定位」 |
| 正常表现 | 开始走 `0-intake` 或 `1-account`，问你事实而不是给泛泛建议 |

---

### 关于 MCP

MCP 工具是**单独的东西，不随 skill 安装**——skill 是文档，MCP 是跑在你机器上的服务。
没有 MCP 也能用（全部退化成人工贴数据），接上则能直接读账号与素材库。见下一节。

---

## 接入 MCP（可选，但强烈建议）

**不接也能用**——所有环节都有「让你贴数据」的人工路径。
接上之后的区别是：**能自己读的，就不问你了。**

| MCP | 装了之后能做什么 |
|---|---|
| [xiaohongshu-mcp](https://github.com/xpzouying/xiaohongshu-mcp) | 读自己主页、读笔记互动数据、读评论区、搜同赛道、发布图文/视频 |
| [youtube-mcp-server](https://github.com/ZubeidHendricks/youtube-mcp-server) | 读频道与视频数据、**拉字幕反推语言习惯**、搜同赛道、找对标账号 |
| [VideoSemantics](https://github.com/maxtongwang/VideoSemantics) | 按旁白语义找 b-roll、搜素材库、拉转写 |
| DaVinci Resolve MCP | 建时间线、铺配音、自动生成字幕、渲染 |
| TTS / 声音克隆（如 Artlist） | **克隆你自己的声音**做配音，或用通用合成音 |
| 抖音 | 目前没有可用的 MCP，走人工贴数据 |

### 装了之后的差别

```
没接 MCP：  「你近 20 条标题是什么？数据怎么样？评论都说什么？」  ← 你贴半天
接了 MCP：  自动读完 → 只问三个数据里没有的问题
```

那三个问题是：靠什么赚钱、什么不想做、哪条自己最满意但数据一般。
其余全部从数据里反推——见 [`workflows/1d-scan.md`](workflows/1d-scan.md)。

### 注意

| 事项 | 说明 |
|---|---|
| 小红书海外账号 | 在 `rednote.com`，与大陆站是两套，需配置对应域名 |
| YouTube 配额 | 每天 10000 单位，搜索一次 100 单位；拉字幕不耗配额 |
| 发布类工具 | 会真的发出去，走 `9-deliver` 验收之后才调用 |
| 探测不到 | 直接转人工，不会卡住流程 |

工具清单与各环节怎么用：[`references/mcp-tools.md`](references/mcp-tools.md)

---

## b-roll + 配音：产能最高的一条路

不用出镜、不用打光、不用背稿，素材可复用——这是全流程里**唯一能端到端自动化**的形态。

```
script.yaml  →  配音  →  按段找 b-roll  →  edit-plan.json  →  DaVinci 搭时间线  →  通看  →  渲染
             真人/AI    find_broll         本 skill 产出       自动建轨+字幕      人工
```

| 环节 | 靠什么 | 没有工具时 |
|---|---|---|
| 找 b-roll | `find_broll(旁白文本)` 按段返回候选 | 自己挑素材 |
| 搭时间线 | DaVinci MCP 导入 → 排轨 → 铺配音 | 输出 `edit-sheet.md` 自己剪 |
| 字幕 | 从配音轨自动生成 | 手打 |
| 配音 | 真人录 或 TTS 合成 | 真人录（本来就是默认） |

**缺一环就退化一环，不会卡住。**

### 配音有三种，不是两种

| 模式 | 是谁的声音 | 身份 | 语气 |
|---|---|---|---|
| 真人现录 | 你 | 你 | 你 |
| **本人声音克隆** | 你 | **你** | 念稿感 |
| 通用合成音 | 陌生人 | 不是你 | 无 |

**本人克隆 + b-roll 里有你的脸 = 身份问题解决。**
`self_presence` 要的是画面里有你（无声出镜也算），与配音怎么来的无关。

剩下的唯一问题是**语气**：克隆复制音色，不复制说话方式——它不卡壳、不改口、没气口。
所以：

| 内容类型 | 本人克隆 |
|---|---|
| 搜索型 / 攻略 / 榜单 / 日常旁白 / 观点类 | 可以 |
| **态度类**（「这个单我不接」） | **自己录** |

**混录是最优解**——全片用克隆，最需要语气的三五句自己录，多花两分钟，差别很大。

克隆音一般只能文本转语音，**不能**把你随口录的粗剪「翻唱」成带你节奏的版本。
细节见 [`workflows/6b-autoedit.md`](workflows/6b-autoedit.md)。

---

## 平台支持

**人性不变，评判标准变。**同一条内容在三个平台会得到完全不同的分数。

| | 小红书 | 抖音 | YouTube |
|---|---|---|---|
| 什么算好 | 值得存下来 | 看完还转发 | 值得花时间看完 |
| 第一指标 | 收藏 | 完播率 | 观看时长 / AVD |
| 决定生死 | 封面 | 前 3 秒 | 缩略图 + 标题 |
| 标题 | ≤20 字（硬） | 较宽松 | 较宽松 |
| 长尾 | 强 | 弱 | 最强 |

**定位跨平台，封装分平台。**选题内核可以复用，标题、封面、时长、成败判据必须分开。
`3-topic` 会给出「这条发哪个平台、每个平台怎么改」，`7-review` 会分平台各判各的。

完整标准见 [`references/platform-playbook.md`](references/platform-playbook.md)。

---

## 怎么用

**它是编导，不是审稿的。**你来要东西，它就产出东西——
不是等你写好了拿去给它打分。

**不需要背命令。**直接用中文说你要什么。

### 要东西（主要用法）

| 你说 | 你会拿到 |
|---|---|
| 「帮我想几个选题」 | **8 个**选题，标好角度、爆款类型、建议平台 |
| 「这条选题起个标题」 | **10 个**标题，三种句式，多平台分开给 |
| 「开头怎么说」 | **5 句**能直接念的第一句 |
| 「我想拍一条关于搬家的 vlog」 | 沿用你的固定片头和环节 → 8 个角度 → 标题 → 脚本 |
| 「帮我写个脚本」 | 口播骨架 + 镜头表 + 拍摄清单 |
| 「起个系列名」 | **5 个**，每个过完命名四关 |
| 「我这个号叫什么好」 | **5 个**昵称 + 5 版简介 |

**默认多给。**只要一个的时候明说，否则一次给一批，排好序、标明推荐哪个。

### 让它看看（次要用法）

| 你说 | 它会做 |
|---|---|
| 「这个标题怎么样」 | **先给你十个更好的**，再说你那个的问题 |
| 「这条选题行不行」 | 把它放进一批候选里一起比，不是单独打分 |
| 「数据不好，帮我看看」 | 分平台画漏斗 → 定位到哪一环 → 回流指令 |

### 选题从哪来

不是凭空想。四个来源，能取几个取几个：

| 来源 | 拿什么 |
|---|---|
| 你是谁 | 定位、支柱、禁区、验证过的有效做法 |
| 观众要什么 | 评论区反复问的问题 |
| 平台现在在推什么 | 同赛道当下的排名与量级 |
| **你拍得出什么** | **素材库里已有的画面** |

第四个最实用：每个选题会标 **[今天能做]** 还是 **[需补拍]**。
一个今天就能做的普通选题，往往强过一个要拍三天的好选题。

**关于「最近热门」，先说清楚**：没有热榜接口。
YouTube 能查「近 N 天发布、按播放排序」，这是真实的近期表现；
小红书只能看某个词当下的排名；抖音没有接口。
小红书首页推荐是**推给你的**，不是全网热的——拿它当趋势会把你自己的兴趣误当成大盘。

### 剪辑到粗剪就停

AI 剪完粗剪**会停下来等你**，不会自己冲去渲染：

```
粗剪完成 → 告诉你：做了什么 / 哪几处不确定 / 什么没做
         → 你说「通过」才渲染
         → 你说「改这里」就留在这一环，改完再给你看
```

渲染和发布不可逆，所以这是流程里唯一一个必须等你开口的地方。

### 让它记住

| 你说 | 它做什么 |
|---|---|
| 「我 vlog 有个固定片头，每期都说那句话」 | 写进 `profile.styles.<风格>.fixed_elements`，**以后每次自动带上** |
| 「我不做测评类内容」 | 写进 `forbidden_topics`，以后不会再提 |
| 「我一周只能拍两条」 | 写进 `production`，选题量按这个给 |

**说过一次的，不会再问第二遍。**`profile.yaml` 就是它的长期记忆。

### 它会越用越准

`7-review` 每次复盘会把**验证过的结论**写回 `profile.learned`：

```
works   验证有效 → 以后优先用
fails   证伪过的 → 以后不再提
audience.常问   观众反复问的 → 天然选题库
```

下次出选题、出标题前先读这一段。**用得越久，给的东西越贴你的号。**

### 起步

| 情况 | 怎么开始 |
|---|---|
| 已有账号 + 连了 MCP | 「扫一下我的号」 |
| 已有账号 + 没连 | 「我号做了半年没起色」，然后贴数据 |
| 还没开号 | 「我想做个号，但不知道做什么」 |
| 只想要一个东西 | 直接要，缺的信息它会自己推，不会拦着你 |

**产出会落成文件**（`profile.yaml` / `topic-card.yaml` / `script.yaml`…），
在环节之间传递。个人产出已在 `.gitignore` 里排除，不会误提交。

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
| 1d  | 自动扫号（有 MCP） | 读账号数据 → 反推 profile          |
| 2   | 人设 IP 与验证     | `profile.yaml` 的 ip 段            |
| 3   | 选题决策           | `topic-card.yaml`                  |
| 4   | 标题·封面·开头     | `topic-card` 的 hook 段            |
| 5   | 脚本与分镜         | `script.yaml`                      |
| 6   | 剪辑交付           | `edit-plan.json` / `edit-sheet.md` |
| 6b  | b-roll+配音 全自动 | `edit-plan.json` + 搭好的时间线    |
| 7   | 复盘诊断           | 诊断 + 回流指令                    |
| 8   | 风格档案           | `profile.yaml` 的 styles 段        |
| 9   | 统一交付验收       | 所有分支的唯一出口                 |
| 10  | 编导训练           | 前后对照 + 验收标准                |

---

## 四种用户，四条入口

| 用户状态 | 入口 | 为什么 |
|---|---|---|
| 还没开号，说自己很普通 | `1b-discover` → `1-account` | 「你有什么」问不出来，得先挖事实 |
| 有账号，且连了 MCP | `1d-scan` → 按断层切入 | 能自己读的就不问你 |
| 有账号，没连 MCP | `1c-backfill` → 按断层切入 | 同样的逻辑，改成你贴数据 |
| 有想法没成体系 | `0-intake` → `1-account` | 常规路径 |

**四条不是隔离的。**你可能小红书有号、YouTube 还没开——
那就小红书扫号，YouTube 从定位补起。流程不会因为你不属于任何一类就卡住。

---

## 三种剪辑交付

| 用户能力 | 产出                                        |
| -------- | ------------------------------------------- |
| 交给 AI  | `edit-plan.json`（机器执行）                |
| 自己剪   | `edit-sheet.md`（人读，带「为什么这么切」） |
| 半自动   | 两份都给：AI 出粗剪，人做精修               |

---

## 十条核心原则

1. **定位是闸门，爆款是放大。** 爆款元素只能在定位允许的范围内放大。
2. **一条数据流贯穿始终。** 上一环节的输出是下一环节的输入。
3. **剪辑能像成片，是因为分镜在脚本阶段就定完了。** 剪出来不对，先回脚本查 `cut_reason`。
4. **风格是一组剪辑参数，不是标签。** 剪之前先识别，识别不出就问。
5. **逼出否定比收集信息更重要。** 没有 `forbidden_topics` 的 profile 是废的。
6. **能循环的地方一定要循环。** 验收不过、复盘有问题、能力有短板，都回对应环节重做。
7. **有什么用什么，缺什么补什么。** 不要求你先填齐再开工——能推的先推，只问缺了就做不下去的。
8. **默认生成，不默认评判。** 你来要东西，就给一批，不是给你的东西打分。
9. **记住的东西不再问第二遍。** 风格、固定元素、忌讳一次写进 profile，长期复用。
10. **人性不变，平台标准变。** 定位跨平台，封装分平台。

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
workflows/            15 个环节（创作层）
references/           方法论 + 平台手册 + MCP 工具清单（运行时读取）
templates/            5 个结构化模板
automation/           发布与记账层（配额 · ledger · agents）
docs/architecture.md  架构图
docs/sync-notes.md    两层字段同步清单
scripts/build.sh      一键打包
```

---

## 许可

MIT
