#!/usr/bin/env bash

# VSCode 配置文件软链接卸载脚本
# 使用方法: ./uninstall.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检查并删除软链接
remove_symlink() {
    local file=$1
    local target="$VSCODE_USER_DIR/$file"

    if [[ -L "$target" ]]; then
        local link_target=$(readlink "$target")
        rm "$target"
        print_success "已删除软链接: $file -> $link_target"
        return 0
    elif [[ -e "$target" ]]; then
        print_warning "文件 $file 不是软链接，跳过"
        return 1
    else
        print_info "文件 $file 不存在，跳过"
        return 1
    fi
}

# 恢复备份文件
restore_backup() {
    local file=$1
    local target="$VSCODE_USER_DIR/$file"

    # 查找最新的备份文件
    local latest_backup=$(ls -t "$VSCODE_USER_DIR/${file}.backup."* 2>/dev/null | head -1)

    if [[ -n "$latest_backup" ]] && [[ ! -e "$target" ]]; then
        read -p "是否恢复备份文件 $(basename "$latest_backup")？(y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$latest_backup" "$target"
            print_success "已恢复备份: $file"
        fi
    fi
}

# 主函数
main() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}  VSCode 配置文件软链接卸载脚本${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo

    print_info "VSCode 配置目录: $VSCODE_USER_DIR"
    echo

    # 检查 VSCode 目录
    if [[ ! -d "$VSCODE_USER_DIR" ]]; then
        print_error "VSCode 配置目录不存在: $VSCODE_USER_DIR"
        exit 1
    fi

    # 列出要删除的软链接
    local files=("settings.json" "keybindings.json" "extensions.json")
    local found_links=()

    print_info "检查软链接..."
    for file in "${files[@]}"; do
        local target="$VSCODE_USER_DIR/$file"
        if [[ -L "$target" ]]; then
            local link_target=$(readlink "$target")
            echo "  • $file -> $link_target"
            found_links+=("$file")
        fi
    done

    if [[ ${#found_links[@]} -eq 0 ]]; then
        print_warning "未找到任何软链接"
        exit 0
    fi

    echo
    read -p "是否删除这些软链接？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "取消卸载"
        exit 1
    fi

    echo
    print_info "开始删除软链接..."

    # 删除软链接
    for file in "${found_links[@]}"; do
        remove_symlink "$file"
    done

    echo
    print_info "检查是否有备份文件需要恢复..."
    for file in "${found_links[@]}"; do
        restore_backup "$file"
    done

    echo
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✔ 卸载完成！${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
}

# 运行主函数
main
