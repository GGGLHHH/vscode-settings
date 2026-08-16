#!/usr/bin/env bash

# VSCode 配置文件软链接安装脚本
# 使用方法: ./install.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取脚本所在目录（配置文件源目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE_DIR="${SCRIPT_DIR}/.vscode"

# 检测操作系统并设置 VSCode 配置目录
detect_vscode_config_dir() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "$HOME/Library/Application Support/Code/User"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "$HOME/.config/Code/User"
    else
        echo -e "${RED}错误：不支持的操作系统 $OSTYPE${NC}"
        exit 1
    fi
}

VSCODE_USER_DIR=$(detect_vscode_config_dir)

# Zed 配置目录（macOS 与 Linux 相同）
# 注意：源目录用 zed/ 而非 .zed/ —— .zed/settings.json 会被 Zed 当作项目级设置校验，用户级键会报 warning
ZED_SOURCE_DIR="${SCRIPT_DIR}/zed"
ZED_USER_DIR="$HOME/.config/zed"

# 打印信息
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✔${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✖${NC} $1"
}

# 检查源配置文件是否存在
check_source_files() {
    print_info "检查源配置文件..."

    if [[ ! -d "$CONFIG_SOURCE_DIR" ]]; then
        print_error "配置文件目录不存在: $CONFIG_SOURCE_DIR"
        exit 1
    fi

    local files=("settings.json" "keybindings.json" "extensions.json")
    local missing_files=()

    for file in "${files[@]}"; do
        if [[ ! -f "$CONFIG_SOURCE_DIR/$file" ]]; then
            missing_files+=("$file")
        fi
    done

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_warning "以下配置文件不存在: ${missing_files[*]}"
    else
        print_success "所有配置文件都存在"
    fi
}

# 检查 VSCode 配置目录是否存在
check_vscode_dir() {
    print_info "检查 VSCode 配置目录..."

    if [[ ! -d "$VSCODE_USER_DIR" ]]; then
        print_warning "VSCode 配置目录不存在: $VSCODE_USER_DIR"
        read -p "是否创建该目录？(y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$VSCODE_USER_DIR"
            print_success "已创建目录: $VSCODE_USER_DIR"
        else
            print_error "取消安装"
            exit 1
        fi
    else
        print_success "VSCode 配置目录存在: $VSCODE_USER_DIR"
    fi
}

# 备份现有配置文件（参数：目标文件完整路径）
backup_existing_file() {
    local target=$1
    local file=$(basename "$target")

    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup"
        print_warning "已备份现有文件: $file -> $(basename "$backup")"
    elif [[ -L "$target" ]]; then
        local link_target=$(readlink "$target")
        print_info "检测到现有软链接: $file -> $link_target"
        rm "$target"
        print_warning "已删除现有软链接: $file"
    fi
}

# 创建软链接（参数：源文件完整路径、目标文件完整路径）
create_symlink() {
    local source=$1
    local target=$2

    if [[ ! -f "$source" ]]; then
        print_warning "跳过不存在的文件: $source"
        return
    fi

    # 备份现有文件
    backup_existing_file "$target"

    # 创建软链接
    ln -s "$source" "$target"
    print_success "已创建软链接: $target -> $source"
}

# 主函数
main() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}  VSCode 配置文件软链接安装脚本${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo

    print_info "配置源目录: $CONFIG_SOURCE_DIR"
    print_info "VSCode 配置目录: $VSCODE_USER_DIR"
    echo

    # 检查源文件
    check_source_files
    echo

    # 检查 VSCode 目录
    check_vscode_dir
    echo

    # 确认安装
    print_warning "即将创建以下软链接："
    local files=("settings.json" "keybindings.json" "extensions.json")
    for file in "${files[@]}"; do
        if [[ -f "$CONFIG_SOURCE_DIR/$file" ]]; then
            echo "  • VSCode: $file"
        fi
    done
    for file in settings.json keymap.json; do
        if [[ -f "$ZED_SOURCE_DIR/$file" ]]; then
            echo "  • Zed: $file"
        fi
    done
    echo

    read -p "是否继续？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "取消安装"
        exit 1
    fi

    echo
    print_info "开始创建软链接..."

    # 创建软链接
    for file in "${files[@]}"; do
        create_symlink "$CONFIG_SOURCE_DIR/$file" "$VSCODE_USER_DIR/$file"
    done

    # Zed
    mkdir -p "$ZED_USER_DIR"
    for file in settings.json keymap.json; do
        create_symlink "$ZED_SOURCE_DIR/$file" "$ZED_USER_DIR/$file"
    done

    echo
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✔ 安装完成！${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo
    print_info "提示: 重启 VSCode 以使配置生效"
}

# 运行主函数
main
