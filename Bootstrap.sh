#!/usr/bin/env bash

dry=false

while [[ $# -gt 0 ]]; do
        case $1 in
	-d | --dry-run)
		dry=true ;;
        *)
		printf "Usage: %s [-d | --dry-run]\n" "$0" >&2
		exit 1 ;;
        esac
        shift
done

function create_symbolic_link {
	local source_dir="${3:-.}"
	local source_path=$(realpath "$source_dir/$1")
	local target_path="$2"

	if [ ! -e "$source_path" ]; then
		printf "Source '%s' does not exist. Skipping.\n" "$source_path" >&2
		return 1
	fi

	if [ -d "$source_path" ]; then
		if [ "$dry" = true ]; then
			printf "Will be linking contents of directory: '%s' => '%s'\n" "$target_path" "$source_path"
		else
			printf "Linking contents of directory: '%s' => '%s'\n" "$target_path" "$source_path"
			mkdir -p "$target_path"
			find "$source_path" -mindepth 1 -maxdepth 1 | while read -r item; do
				printf "\tLinking item: '%s/%s' => '%s'\n" "$target_path" "$(basename "$item")" "$item"
				ln -sf "$item" "$target_path/"
			done
		fi
	else
		if [ "$dry" = true ]; then
			printf "Will be linking file: '%s' => '%s'\n" "$target_path" "$source_path"
		else
			printf "Linking file: '%s' => '%s'\n" "$target_path" "$source_path"
			mkdir -p "$(dirname "$target_path")"
			ln -sf "$source_path" "$target_path"
		fi
	fi
}

function copy_ssh_keys {
	local source=$(realpath "$1")
	local target="$HOME/.ssh/$(basename "$source")"

	if [ "$dry" = true ]; then
		printf "Will be copying SSH key: %s -> %s\n" "$source" "$target"
	else
		printf "Copying SSH key: %s -> %s\n" "$source" "$target"
		cp -f "$source" "$target"
	fi
}

# Common Files
printf "Files for all platforms:\n"
create_symbolic_link	".config"	"$HOME/.config"
create_symbolic_link	".gitconfig"	"$HOME/.gitconfig"
create_symbolic_link	".ideavimrc"	"$HOME/.ideavimrc"
create_symbolic_link	".vimrc"	"$HOME/.vimrc"
create_symbolic_link	".zshrc"	"$HOME/.zshrc"
create_symbolic_link	"ssh_config"	"$HOME/.ssh/config"

if [[ "$OSTYPE" == "darwin"* ]]; then
	printf "\nFiles for Mac:\n"
	copy_ssh_keys	"$HOME/Documents/SSHKeys/homovetus"
	copy_ssh_keys	"$HOME/Documents/SSHKeys/homovetus.pub"
fi
