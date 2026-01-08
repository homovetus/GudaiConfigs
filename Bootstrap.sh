#!/usr/bin/env bash

set -e
set -o pipefail
set -u

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[1;33m'

DRY_RUN=false
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

log_error() { printf "${RED}[ERR]${NC}  %s\n" "$1" >&2; }
log_info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
log_success() { printf "${GREEN}[OK]${NC}   %s\n" "$1"; }
log_warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }

for arg in "$@"; do
    case $arg in
        -d|--dry-run) DRY_RUN=true ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    log_warn "DRY-RUN MODE: No changes will be made."
fi

link_item() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        log_warn "Source not found, skipping: $src"
        return
    fi

    local dest_dir=$(dirname "$dest")
    if [ "$DRY_RUN" = true ]; then
        if [ ! -d "$dest_dir" ]; then
            log_info "(Dry) mkdir -p $dest_dir"
        fi
    else
        mkdir -p "$dest_dir"
    fi

    # 2. 检查目标状态
    if [ -L "$dest" ]; then
        # === 场景 A: 目标已经是软链接 ===
        local current_link
        # readlink 在 Mac 和 Linux 上行为略有不同，但对于读取链接路径是通用的
        current_link=$(readlink "$dest")

        if [ "$current_link" == "$src" ]; then
            log_success "Already linked: $dest"
            return
        else
            # 软链接存在，但指向了别处 (比如旧的配置)
            # 策略: 软链接不包含数据，直接替换，不询问
            if [ "$DRY_RUN" = false ]; then
                rm "$dest"
                log_info "Auto-fixing symlink: $dest (was -> $current_link)"
            else
                log_info "(Dry) rm old symlink $dest"
            fi
        fi

    elif [ -e "$dest" ]; then
        # === 场景 B: 目标是真实文件/目录 ===

        # 物理同一性检查 (防止源文件和目标文件通过父目录链接指向了同一个 Inode)
        if [ "$src" -ef "$dest" ]; then
            log_warn "Skipping: '$dest' is physically the same file as source."
            return
        fi

        # 真正的文件冲突 -> 必须询问用户
        log_warn "Conflict found at: $dest (Real file)"
        printf "${YELLOW}Replace existing file? [y/N]${NC} "
        read -r response < /dev/tty
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Skipped: $dest"
            return
        fi

        if [ "$DRY_RUN" = false ]; then
            rm -rf "$dest"
        else
            log_info "(Dry) rm -rf $dest"
        fi
    fi

    # 3. 创建链接
    if [ "$DRY_RUN" = false ]; then
        ln -s "$src" "$dest"
        log_success "Linked: $src -> $dest"
    else
        log_info "(Dry) ln -s $src $dest"
    fi
}

install_config() {
    local rel_src="$1"
    local abs_dest="$2"
    local abs_src="$SCRIPT_DIR/$rel_src"

    if [ -z "$abs_dest" ]; then
        log_error "Target path is empty for $rel_src"
        exit 1
    fi

    # 优化：如果目标目录已经是整个链接到源目录的，就不再递归了
    if [ -L "$abs_dest" ] && [ "$abs_src" -ef "$abs_dest" ]; then
        log_success "Directory already linked as a whole: $abs_dest"
        return
    fi

    if [ -d "$abs_src" ]; then
        log_info "Processing directory: $rel_src"
        # 递归遍历所有文件
        while IFS= read -r -d '' file; do
            local file_rel_path="${file#$abs_src/}"
            local target_file="$abs_dest/$file_rel_path"
            link_item "$file" "$target_file"
        done < <(find "$abs_src" -type f -print0)
    else
        link_item "$abs_src" "$abs_dest"
    fi
}

copy_ssh_key() {
    local src="$1"
    local dest_name=$(basename "$src")
    local dest="$HOME/.ssh/$dest_name"

    if [ ! -e "$src" ]; then
        log_info "SSH Key not found: $src"
        return
    fi

    if [ -e "$dest" ]; then
        log_success "SSH Key already exists: $dest"
        return
    fi

    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        cp "$src" "$dest"
        chmod 600 "$dest"
        log_success "Copied SSH Key: $dest"
    else
        log_info "(Dry) cp $src $dest"
    fi
}

log_info "Starting Bootstrap..."
log_info "Source Dir: $SCRIPT_DIR"
echo "---------------------------------------------------"

# 1. Common Configs
install_config ".config"     "$HOME/.config"
install_config ".gitconfig"  "$HOME/.gitconfig"
install_config ".ideavimrc"  "$HOME/.ideavimrc"
install_config ".vimrc"      "$HOME/.vimrc"
install_config ".zshrc"      "$HOME/.zshrc"
install_config "ssh_config"  "$HOME/.ssh/config"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "---------------------------------------------------"
    log_info "Detected macOS..."
    install_config "lazygit.yml" "$HOME/Library/Application Support/lazygit/config.yml"
    install_config "Surge.conf" "$HOME/Library/Application Support/Surge/Profiles/Default.conf"

    copy_ssh_key "$HOME/Documents/SSHKeys/homovetus"
    copy_ssh_key "$HOME/Documents/SSHKeys/homovetus.pub"
fi

log_info "Bootstrap complete!"
