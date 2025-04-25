#!/usr/bin/env bash

user_dir=$HOME
debug=false

while [[ $# -gt 0 ]]; do
        case $1 in
        -d | --debug) debug=true ;;
        *)
                echo "Usage: $0 [-d | --debug]"
                exit 1
                ;;
        esac
        shift
done

function create_symbolic_link {
        local path="$1"
        local target="$2"
        local config_dir="${3:-$(pwd)}"

        target=$(realpath "$config_dir/$target")

        if [ "$debug" = true ]; then
                echo "Will be linking: $path -> $target"
        else
                ln -sfv "$target" "$path"
        fi
}

function copy_ssh_keys {
        local target="$1"
        local path=""

        path="$user_dir/.ssh/$(basename "$target")"
        target=$(realpath "$target")

        if [ "$debug" = true ]; then
                echo "Will be copying: $target -> $path"
        else
                cp -fv "$target" "$path"
        fi
}

# Common Files
echo "Files for all platforms:"
create_symbolic_link "$user_dir/.config" ".config"
create_symbolic_link "$user_dir/.gitconfig" ".gitconfig"
create_symbolic_link "$user_dir/.ideavimrc" ".ideavimrc"
create_symbolic_link "$user_dir/.ssh/config" "ssh_config"
create_symbolic_link "$user_dir/.vimrc" ".vimrc"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Files for Mac:"
        copy_ssh_keys "$user_dir/Documents/SSHKeys/homovetus"
        copy_ssh_keys "$user_dir/Documents/SSHKeys/homovetus.pub"
        create_symbolic_link "$user_dir/.zshrc" ".zshrc"
fi
