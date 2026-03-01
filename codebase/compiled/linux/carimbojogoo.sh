#!/bin/sh
printf '\033c\033]0;%s\a' carimbojogoo
base_path="$(dirname "$(realpath "$0")")"
"$base_path/carimbojogoo.x86_64" "$@"
