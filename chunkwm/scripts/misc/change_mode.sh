#!/usr/bin/env bash

function search_index
{
    local count="0"
    local match="false"
    local mode

    while read -r mode && [[ "${match}" != "true" ]]; do
        if [[ "${mode}" == "$1" ]]; then
            printf "%s" "${count}"
            match="true"
        fi
        ((++count))
    done < <(printf "%s\\n" "${modes[@]}")
}

function get_new_index
{
    local index="$1"
    if ((index == 2)); then
        index="0"
    else
        ((++index))
    fi
    printf "%s" "${index}"
}

function main
{
    ! { source "${BASH_SOURCE[0]//${0##*/}/}../display/notify.sh" \
        && source "${BASH_SOURCE[0]//${0##*/}/}../display/format.sh"; } \
            && exit 1

    modes=( "bsp" "monocle" "float" )
    current="$(chunkc tiling::query --desktop mode)"

    index="$(search_index "${current}")"
    index="$(get_new_index "${index}")"

    title_parts=("chunkwm")
    subtitle_parts=()
    message_parts=("Changing to" "${modes[$index]}")

    title="$(format "${title_parts[@]}")"
    subtitle="$(format "${subtitle_parts[@]}")"
    message="$(format "${message_parts[@]}")"

    notify "${title:-}" "${subtitle:-}" "${message:-}"

    chunkc tiling::desktop --layout "${modes[$index]}"
}

main
