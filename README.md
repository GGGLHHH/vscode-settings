<samp><b>Anthony's VS Code Settings</b></samp>

[`.vscode/settings.json`](./.vscode/settings.json)<br>
[`.vscode/extensions.json`](./.vscode/extensions.json)<br>
[`.vscode/keybindings.json`](./.vscode/keybindings.json)<br>
[`zed/settings.json`](./zed/settings.json)<br>
[`zed/keymap.json`](./zed/keymap.json)<br>
[`ccstatusline/settings.json`](./ccstatusline/settings.json)<br>
[`claude/CLAUDE.md`](./claude/CLAUDE.md)

## 📦 安装

使用自动化脚本创建软链接到 VSCode 全局配置目录：

```bash
# 克隆仓库
git clone <repository-url> ~/vscode-settings
cd ~/vscode-settings

# 运行安装脚本
./install.sh
```

安装脚本会：
- ✅ 自动检测操作系统（macOS/Linux）
- ✅ 备份现有配置文件
- ✅ 创建软链接到 VSCode User 目录
- ✅ 提供详细的操作反馈

### 卸载

如果需要删除软链接并恢复原始配置：

```bash
./uninstall.sh
```

### 手动安装（可选）

如果你更喜欢手动操作：

**macOS:**
```bash
ln -s ~/vscode-settings/.vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/vscode-settings/.vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/vscode-settings/.vscode/extensions.json ~/Library/Application\ Support/Code/User/extensions.json
```

**Linux:**
```bash
ln -s ~/vscode-settings/.vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/vscode-settings/.vscode/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/vscode-settings/.vscode/extensions.json ~/.config/Code/User/extensions.json
```

**Zed（macOS / Linux 相同）:**
```bash
ln -s ~/vscode-settings/zed/settings.json ~/.config/zed/settings.json
ln -s ~/vscode-settings/zed/keymap.json ~/.config/zed/keymap.json
```

**ccstatusline-zh（Claude Code 状态栏，macOS / Linux 相同）:**
```bash
npm install -g ccstatusline-zh
ln -s ~/vscode-settings/ccstatusline/settings.json ~/.config/ccstatusline/settings.json
```

并在 `~/.claude/settings.json` 中启用：
```json
"statusLine": {
  "type": "command",
  "command": "ccstatusline-zh",
  "padding": 0,
  "refreshInterval": 10
}
```

**Claude Code 全局记忆（macOS / Linux 相同）:**
```bash
ln -s ~/vscode-settings/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

<br>
<br>
<p align="center"><samp>Preview</samp></p>

<p align="center">
<img src="https://user-images.githubusercontent.com/11247099/110247185-ed26b380-7fa5-11eb-8fce-6c224bb6ef26.png">
<img src="https://user-images.githubusercontent.com/11247099/110247187-f1eb6780-7fa5-11eb-9258-620309e20961.png">
<sub><samp>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Theme | <a href="https://github.com/antfu/vscode-theme-vitesse">Vitesse Theme</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Font | <a href="http://input.fontbureau.com/">Input Mono</a><br>
&nbsp;File Icons | <a href="https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons">File Icons</a><br>
Product Icons | <a href="https://github.com/antfu/vscode-icons-carbon">Carbon</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</samp></sub>
</p>

<br>

## LICENSE

MIT
