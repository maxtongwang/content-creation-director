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

**坑**：`append_to_timeline` 只给片段 ID 会把整段素材原样铺上。
edit-plan 里的 `in`/`out` 秒数要按**时间线帧率**换算成帧号，混帧率素材尤其容易错。

---

## 六、AI 配音（TTS）

有 TTS 工具时可以合成配音（如 Artlist 的 `generate_voiceover`、`list_voices`）。

| 规则 | 说明 |
|---|---|
| 分段生成 | 按 `vo_segment` 逐段，不要整篇一次生成——分段天然对齐剪辑段 |
| 固定音色 | 同一账号固定一个，换音色等于换人设；ID 写进 profile 复用 |
| 只用于特定内容 | 搜索型 / 攻略 / 榜单可以；**人设类、态度类、转化类不要** |
| 标记 | `edit-plan.vo.synthetic: true`，方便复盘时区分 |

**为什么有限制**：本 skill 有一条既有规则是「保留口误、停顿——人味儿即可信度」。
合成音把这个来源整个去掉了。判断表见 `workflows/6b-autoedit.md` 第一节。

---

## 七、抖音

**目前没有可用的 MCP。**不要假装有。

抖音相关的一切走人工：让用户贴主页截图、贴数据面板、导出 CSV。
`1c-backfill` 的人工路径就是为这种情况准备的。

---

## 八、退化规则

| 场景               | 做法                                       |
| ------------------ | ------------------------------------------ |
| 工具不可用         | 直接进人工模式，一句话说明即可，不要反复提 |
| 工具报错           | 试一次，不行就转人工，不要卡在排错上       |
| 只有部分平台有工具 | 有的读，没的问，不要因为不齐就全都问       |
| 配额吃紧           | 优先保 `1d-scan`（一次性），少用搜索类     |

**判断标准：用户不应该为了用这个 skill 先去配一堆环境。**

---

## 九、能自动读的，就不要问

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
