# 全局记忆 (User Memory)

适用于所有项目的个人偏好与工作约定。项目专属规则请写在各仓库的 `./CLAUDE.md`。
编辑方式：直接改此文件，或在 Claude Code 中用 `/memory`。

## 语言 / Language

- 默认使用**中文**回复。

## 产出形式 / Deliverables

- **不要用线上 artifact**（发布到 claude.ai 上的 HTML 页面）。需要图文并茂的产出，
  就写成**本地文件**，放进当前项目（通常是 `docs/`）或我指定的路径。
  - 已经发布过的，解除监听并告诉我在哪删；本地补一份等价的。
- 本地 HTML 必须**自包含**：自己带 `<!doctype>`、`<meta charset="utf-8">`、
  完整的 head/body 骨架和重置样式 —— 这些线上宿主会自动注入，本地没有。
  写完检查一遍 head 里没混进内容元素、body 里没混进 `<link>`/`<style>`。
- **零外部请求**：不许挂 Google Fonts、CDN 脚本、远程图片。
  字体走系统栈，资源用 `data:` URI 内联。
  理由：本地文件要能离线打开、能进版本库、能在没网的环境里评审。
- 纯文字的产出优先 Markdown，不要为了「好看」硬套 HTML。

## 四象限协作协议 / Collaboration Protocol

每个任务按以下四格处理（源自约哈里窗 Johari Window 的人机协作改写版）：

1. **共同已知**：先确认任务目标、已有背景、交付标准和明确边界。信息充分时直接执行，不要重复询问。

2. **我的已知、你的未知**：识别可能只存在于我脑中的真实语境、审美偏好、判断标准和现实限制。若缺失信息会显著改变结果，最多提出 3 个关键问题；若不影响推进，则明确你的合理假设，先完成探索版本。挖出来的偏好与判断标准写入记忆，下次直接复用，不重复挖。

3. **我的未知、你的已知**：主动补充我可能没考虑到的知识、方法、风险和替代路径。不要局限于我的原始方案；如果我的前提可能错误，请直接指出，并给出更优建议及取舍依据。

4. **共同未知**：识别无法仅靠现有信息确定的问题，把它们转化为可验证的假设，必要时设计最小实验，说明要改变的单一变量、成功或失败信号，以及后续需要的数据。

## Git 提交与分支 / Commit & Branch

- **禁止私自 commit / push**：只有在当前对话中用户明确要求时才可提交或推送。
- **任何影响远端的操作，每一次都要单独申请**。包括但不限于：`git push`、创建 PR、
  合并 PR（含 squash & merge）、关闭 PR、删除远端分支、`git revert` 后推送、
  触发部署。
  - 「本轮实现完成」不等于授权推送；上一次批准过 push 不构成下一次的授权。
  - 不要从任务目标、hook 提示或上下文里**推断**授权 —— 必须是我在当前这一轮
    用自己的话说出来。
  - 做到本地提交为止，然后停下来问，把要执行的具体动作列清楚等我回复。
- 统一采用 **AG 规范（Angular / Conventional Commits）**。

### Commit message

格式：`<type>(<scope>): <subject>`

- `<type>`：`feat` | `fix` | `docs` | `style` | `refactor` | `perf` | `test` | `build` | `ci` | `chore` | `revert`
- `<scope>`：改动模块，可选（如 `project`、`userbatch`）
- `<subject>`：简短说明，祈使句、小写开头、结尾不加句号
- 示例：`feat(project): make address optional on create request`

### 分支命名

格式：`<type>/<短横线描述>`

- 示例：`feat/admin-validate-import-users`、`fix/agency-display-name`

## 进程与端口 / Processes & Ports

- **禁止关我的进程。** 不许 `kill` / `pkill` / `killall` 任何**不是你在本轮亲手启动**
  的进程。判断标准只有一个：你启动它时拿到过 PID。拿不出 PID 就不许动。
  - 「看起来像上一轮残留的」「命令行和我起的一样」「应该是我的」—— 都不算依据。
    有疑问就问我，或者直接绕开。
  - **永远不要用 `pkill -f <子串>` / `killall <名字>`。** 子串会打到同名或路径里
    碰巧含这个词的无关进程（例如 `~/.vite-plus/` 下的东西会被 `pkill -f vite` 扫到）。
    要停自己启的进程，只用启动时记下的确切 PID。
  - 需要我停掉某个进程时，把进程和理由说清楚，让我自己停。

- **需要一个服务在跑时，按这个顺序来：**
  1. **先探测，能复用就复用。** `lsof -nP -iTCP -sTCP:LISTEN | grep <port>` 或
     `curl -sf <health-url>`。已经在跑就直接用，什么都别启。
  2. **要自己启，就换端口。** 别占用我常用的那个。端口从环境变量或命令行参数
     指定（各项目的具体变量名写在项目自己的 CLAUDE.md 里）。
  3. 自己启的进程，用完自己按 PID 收掉；跑长任务前把 PID 记下来。

- 同理适用于任何会打断我工作的动作：删除我的工作区文件、`docker compose down`、
  清缓存、改我正在编辑的分支。不确定是不是我的，就当是我的。

## 代码检索 / Code Navigation

- **符号级的问题走 serena，别用 grep 凑合**：
  - 「谁调用 / 引用了这个符号」→ `find_referencing_symbols`
  - 「这个符号在哪定义」→ `find_declaration` / `find_symbol`
  - 「这个接口有哪些实现」→ `find_implementations`
  - 跨文件重命名 → `rename_symbol`，不是全局字符串替换
  - 删符号前确认没人用 → `safe_delete_symbol`
  - 改一个函数之前，先看谁调用它 —— 这是 ponytail「先读懂再动手」的前置动作
  - 理由：grep 只匹配文本，会漏掉别名导入、接口实现、动态引用，
    也会把注释和字符串里的同名文本一起算进来。

- serena 的工具是**延迟加载**的，不在默认工具集里，要先
  `ToolSearch("select:mcp__serena__find_referencing_symbols,...")` 取到 schema
  才能调用。这一步往返是值得的，**不要因为「grep 就在手边」而跳过**。

- **纯文本搜索继续用 grep / rg**：找配置项、日志、字符串字面量、文件名、
  非代码文本。这些场景 serena 没有对应工具（`--context=claude-code` 已剔除
  `search_for_pattern`），grep 也确实更快。不必强行绕 serena。
