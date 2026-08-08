# 参考｜MCP 工具能力

**有工具就去读真实数据，没工具就问人。**两条路都要能走通。

本 skill 不依赖任何 MCP。连上了，能少问很多问题、能看到真实数据；
没连上，全部退化成「让用户贴过来」，流程照常。

---

## 一、先探测，再决定问什么

开工前先看手上有哪些工具，**不要假设，也不要让用户去装**：

| 探测到       | 能做什么                             | 用在                           |
| ------------ | ------------------------------------ | ------------------------------ |
| 小红书工具   | 读账号、读笔记数据、搜同赛道、发布   | `1d-scan` `3-topic` `7-review` |
| YouTube 工具 | 读频道、读视频数据、读字幕、搜同赛道 | `1d-scan` `3-topic` `7-review` |
| 素材库工具   | 按旁白找 b-roll、语义搜素材、拉转写  | `6b-autoedit`                  |
| 剪辑软件工具 | 建时间线、铺配音、出字幕、渲染       | `6b-autoedit`                  |
| TTS 工具     | 合成配音（仅限特定内容类型）         | `6b-autoedit`                  |
| 都没有       | 全部走人工贴数据                     | 同上，退化模式                 |

**探测不到不是错误，是常态。**直接进人工模式，不要停下来让用户配置。

---

## 二、小红书（xiaohongshu-mcp）

来源：[xpzouying/xiaohongshu-mcp](https://github.com/xpzouying/xiaohongshu-mcp)
本地起一个 HTTP 服务，用自己的登录态操作，18 个工具。

| 工具                                                         | 本 skill 怎么用                               |
| ------------------------------------------------------------ | --------------------------------------------- |
| `check_login_status`                                         | 开工前确认登录态，未登录先提示                |
| `get_my_profile`                                             | 读自己的账号资料 → `1d-scan` 填 profile       |
| `user_profile`                                               | 读任意账号 → 对标账号研究                     |
| `list_feeds`                                                 | 首页推荐流 → 看平台当下在推什么               |
| `search_feeds`                                               | 按关键词搜 → 选题竞品研究、搜索词验证         |
| `get_feed_detail`                                            | 单条笔记详情 + 评论 + 互动数据 → 反推观众认知 |
| `post_comment_to_feed` `reply_comment_in_feed`               | 评论区运营                                    |
| `like_feed` `favorite_feed`                                  | 互动                                          |
| `list_notifications` `get_unread_count` `reply_notification` | 消息处理                                      |
| `publish_content` `publish_with_video`                       | 发布（图文 / 视频）                           |

### 注意

- 标题 ≤20 字、正文 ≤1000 字是平台硬约束，发布前先校验
- 本地图片路径比网络图片可靠
- 海外账号在 `rednote.com`，与大陆站是两套；工具需配置对应域名
- **发布类工具会真的发出去**，走 `9-deliver` 验收之后再调用

---

## 三、YouTube（youtube-mcp-server）

来源：[ZubeidHendricks/youtube-mcp-server](https://github.com/ZubeidHendricks/youtube-mcp-server)
需要 YouTube Data API v3 的 key，10 个工具。

| 工具                                                 | 本 skill 怎么用                         |
| ---------------------------------------------------- | --------------------------------------- |
| `channels_getChannel`                                | 读频道基础数据 → `1d-scan`              |
| `channels_listVideos`                                | 列出频道视频 → 反推支柱与发布节奏       |
| `videos_getVideo`                                    | 单条视频数据 → 单条诊断                 |
| `videos_searchVideos`                                | 搜同赛道 → 选题研究、标题句式取样       |
| `transcripts_getTranscript`                          | 拉字幕 → **反推语言习惯、口头禅、结构** |
| `channels_searchChannels` `channels_findCreators`    | 找对标账号                              |
| `playlists_getPlaylist` `playlists_getPlaylistItems` | 看系列怎么组织的                        |

### 注意

- **配额有限**：每天 10000 单位，搜索一次 100 单位、查视频 1 单位。
  搜索省着用，能用 `videos_getVideo` 就别用 `videos_searchVideos`
- `transcripts_getTranscript` 不走 Data API，**不消耗配额**，可以放心用
- 只读，没有发布能力

---

## 四、素材库（VideoSemantics）

本地视频素材库的语义检索。**b-roll + 配音链路的核心依赖。**

| 工具 | 本 skill 怎么用 |
|---|---|
| `find_broll` | **按旁白文本找 b-roll 候选**，一段口播调一次 → `6b-autoedit` |
| `find_clips` | 用自然语言描述想要的画面（任何语言） |
| `search_clips` | 关键词搜字幕 / 画面文字（OCR）/ 描述 |
| `get_clip` | 单个片段完整记录（含转写与词级时间） |
| `get_transcript` | 片段转写，带分段与词时间 → 对齐剪辑点 |
| `library_status` | 索引量与存储位置，**开工前先看一眼库是不是空的** |
| `list_people` `person_clips` `name_person` | 按人物找素材 |
| `record_correction` `learn_from_edited_captions` | 纠错回流，库会越用越准 |

**注意**：`find_broll` 给的是候选，不是决定。
语义相关 ≠ 剪辑正确——景别重复、切镜无理由这些它不管，
仍要按 `workflows/6-edit.md` 的选镜规则筛一遍。

### 实测要点（1120 条素材的真实库）

| 事实 | 影响 |
|---|---|
| **词面重合打分**，非语义向量 | 用画面词检索，别用抽象概念；**打标签回报最高**（权重 +4） |
| 无关题材仍返回 1.2–1.4 分 | **要设下限**：<2 视为没找到，≥4 才算命中 |
| 返回整条素材，**不给 in/out** | 实测单条长达 28 分钟；镜头级 in/out 得人工定 |
| 视觉描述只在 3 个锚点 | `frame_time_sec` 约在 25%/50%/75%，只能粗定位 |
| 索引 `fps`/`width`/`height` **全为 0** | 真实帧率要用 `ffprobe` 探文件，别信索引 |

---

## 五、剪辑（DaVinci Resolve）

搭时间线、铺配音、出字幕、渲染。工具很多，b-roll + 配音链路只用到这几个：

| 工具 | 用途 |
|---|---|
| `add_items_to_media_pool_from_storage` | 导入素材与配音（**要绝对路径**） |
| `create_timeline` / `create_timeline_from_clips` | 建时间线 |
| `append_to_timeline` | 逐镜追加；**in/out 通过 `clip_infos` 传帧号** |
| `insert_audio_to_current_track` | 铺配音轨 |
| `timeline_create_subtitles_from_audio` | **从配音自动生成字幕**，省一大截 |
| `add_render_job` + 渲染类 | 出片，**人工通看之后才调** |

### 实测要点

| 事实 | 影响 |
|---|---|
| **默认服务只有 34 个聚合工具** | 上表这些名字要开 `--full` 才有 |
| `clip_infos` **必须带 `record_frame`** | 少了直接报错，不是可选项 |
| `record_frame` **从 0 起算**（相对时间线） | 空时间线 `start_frame` 显示 108000，**别照抄**，否则内容落到一小时后 |
| `clip_id` 是**媒体池 unique_id** | 导入后用 `get_folder_clip_list` 取，与素材库 ID 不通用 |
| `start/end_frame` 用素材帧率，`record_frame` 用时间线帧率 | 实测 29.97 vs 30，长片会累积漂移 |
| 剪辑软件会被脚本接口**自动拉起** | 不必让用户先手动打开 |

---

## 六、配音（TTS / 声音克隆）

三种模式，影响完全不同——见 `workflows/6b-autoedit.md` 第一节：

| 模式 | 说明 |
|---|---|
| 真人现录 | 默认 |
| **本人声音克隆** | 音色是你的，身份成立；缺的是语气气口 |
| 通用合成音 | 陌生人的声音，只用于搜索型 / 榜单 / 氛围向 |

### 克隆自己的声音

| 事项 | 说明 |
|---|---|
| 样本 | **至少 10 秒清晰人声**，1–2 分钟更稳；平时说话状态，别用播音腔 |
| 授权与费用 | 克隆**要花额度且需显式同意**——工具会先返回费用与授权声明，看清再确认 |
| 复用 | 建一次就够，声音名写进 `profile.styles.<风格>.fixed_elements.voice` |
| 找回 | 之后用 `list_voices(custom: true)` 找自己的声音 |

### 关键限制

**克隆音一般只支持文本转语音，不支持语音转语音。**
不能先随口录一条粗的再让克隆音「翻唱」并保留你的节奏——只能给文本。
这就是念稿感的来源。

### 生成规则

| 规则 | 说明 |
|---|---|
| 分段生成 | 按 `vo_segment` 逐段，天然对齐剪辑段 |
| 固定声音 | 同一账号固定一个，换声音等于换人设 |
| 混录 | 态度类 / 观点类的关键几句自己录，其余用克隆——**推荐做法** |
| 标注 | `edit-plan.vo.mode` 记清是哪种，方便复盘时区分 |

---

## 七、退化规则

| 场景               | 做法                                       |
| ------------------ | ------------------------------------------ |
| 工具不可用         | 直接进人工模式，一句话说明即可，不要反复提 |
| 工具报错           | 试一次，不行就转人工，不要卡在排错上       |
| 只有部分平台有工具 | 有的读，没的问，不要因为不齐就全都问       |
| 配额吃紧           | 优先保 `1d-scan`（一次性），少用搜索类     |

**判断标准：用户不应该为了用这个 skill 先去配一堆环境。**

---

## 八、能自动读的，就不要问

这是 MCP 接入的全部意义：

| 能读到         | 就不要问             |
| -------------- | -------------------- |
| 近 20 条标题   | 「你一般怎么起标题」 |
| 每条的互动数据 | 「你哪条数据好」     |
| 评论区内容     | 「观众怎么评价你」   |
| 字幕文本       | 「你说话什么风格」   |
| 发布时间分布   | 「你多久发一条」     |

**读完之后只问三件数据里没有的**：靠什么赚钱、什么不想做、哪条自己最满意但数据一般。
见 `workflows/1c-backfill.md`。
