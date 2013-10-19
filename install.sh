#!/bin/env bash

name=${0##*/}
CFG_DIR="$HOME/.local/share/Steam/SteamApps/common/Team Fortress 2/tf/cfg"

function print_help() {
    echo "usage: $name [options]

optional args:

    -p|--pretend  print what install will do without doing it.
    -c|--cfgdir   use an alternate cfg dir. Default is $CFG_DIR
    -h|--help     print this help."
}

pretend=0
OPTS=$(getopt -o phc: --long pretend,help,cfgdir: -n "$name" -- "$@")

if [ $? != 0 ]; then echo "option error" >&2; exit 1; fi

eval set -- "$OPTS"

while true; do
    case "$1" in
        -p|--pretend)
            pretend=1
            shift;;
        -c|--cfgdir)
            CFG_DIR="$2"
            shift 2;;
        -h|--help)
            print_help
            exit 0
            ;;
        --)
            shift; break;;
        *)
            echo "Internal error!"; exit 1;;
    esac
done

pushd $(dirname $0) &> /dev/null

for cfg in $(ls); do
    if [ ! $cfg == "README.rst" -a ! $cfg == "install.sh"  -a ! $cfg == "LICENSE" ]; then
        target="$CFG_DIR/$cfg"

        if [[ $pretend -eq 1 ]]; then
            echo "Would set $cfg to $target"
        else
            # Make a .bak of a file or dir
            if [ ! -h "$target" ]; then
                if [ -d "$target" -o -f "$target" ]; then
                    mv "$target" "${target}.bak"
                fi
            fi

            echo "Setting $cfg to $target"
            ln -sf "$PWD/$cfg" "$target"
        fi
    fi
done

popd &> /dev/null
