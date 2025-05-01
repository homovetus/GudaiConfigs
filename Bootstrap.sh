#!/usr/bin/env bash

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

        path="$HOME/.ssh/$(basename "$target")"
        target=$(realpath "$target")

        if [ "$debug" = true ]; then
                echo "Will be copying: $target -> $path"
        else
                cp -fv "$target" "$path"
        fi
}

# Common Files
echo "Files for all platforms:"
create_symbolic_link "$HOME/.config" ".config"
create_symbolic_link "$HOME/.gitconfig" ".gitconfig"
create_symbolic_link "$HOME/.ideavimrc" ".ideavimrc"
create_symbolic_link "$HOME/.ssh/config" "ssh_config"
create_symbolic_link "$HOME/.vimrc" ".vimrc"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Files for Mac:"
        copy_ssh_keys "$HOME/Documents/SSHKeys/homovetus"
        copy_ssh_keys "$HOME/Documents/SSHKeys/homovetus.pub"
        create_symbolic_link "$HOME/.zshrc" ".zshrc"
fi
