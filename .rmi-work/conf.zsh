# download single file from huggingface, with directory structure (with wget)
#
# usage: dl_with_dir URL1 URL2 ...
#
# for example, https://huggingface.co/org/repo/resolve/main/dir/file.safetensors?download=true
# will be downloaded to ./org/repo/file.safetensors and links to ./file.safetensors
function dl_with_dir {
    while [[ "$1" != "" ]]
    do
        url="$1"
        fn="$(basename "$1" | cut -d '?' -f 1)"
        org="$(echo "$1" | cut -d '/' -f 4)"
        repo="$(echo "$1" | cut -d '/' -f 5)"
        dir="${org}/${repo}"
        mkdir -p "$dir"
        pushd "$dir"
        dl "$1"
        popd
        ln -sf "${dir}/${fn}" "${fn}"
        shift
    done
}

# download single file from huggingface, with directory structure (with wget)
#
# usage: dl_with_dir URL1 URL2 ...
#
# for example, https://huggingface.co/org/repo/resolve/main/dir/file.safetensors?download=true
# will be downloaded to ./org/repo/file.safetensors, but does not link to ./file.safetensors
function dl_no_link {
    while [[ "$1" != "" ]]
    do
        url="$1"
        fn="$(basename "$1" | cut -d '?' -f 1)"
        org="$(echo "$1" | cut -d '/' -f 4)"
        repo="$(echo "$1" | cut -d '/' -f 5)"
        dir="${org}/${repo}"
        mkdir -p "$dir"
        pushd "$dir"
        dl "$1"
        popd
        shift
    done
}

# download single file from huggingface without directory structure (with wget)
#
# usage: dl_with_dir URL1 URL2 ...
#
# for example, https://huggingface.co/org/repo/resolve/main/dir/file.safetensors?download=true
# will be downloaded to ./file.safetensors
function dl {
    while [[ "$1" != "" ]]
    do
        url="$1"
        fn="$(basename "$1" | cut -d '?' -f 1)"
        wget -O "${fn}" "$url"
        shift
    done
}

# download all files from huggingface page, with directory structure (with wget)
#
# this requires htmlq, a tool written in rust, to parse html
# download at https://github.com/mgdm/htmlq or install with cargo install htmlq
#
# usage: dl_hf_page URL [FILTER1 FILTER2 ...]
#
# for example, https://huggingface.co/org/repo/tree/main will download all files in the page.
# README.md and .gitattributes will be excluded.
#
# to download only files with .safetensors extension, use
# dl_hf_page https://huggingface.co/org/repo/tree/main .safetensors
#
# to list files without downloading, use
# NOP=1 dl_hf_page https://huggingface.co/org/repo/tree/main .safetensors
function dl_hf_page {
    host="https://huggingface.co"
    page="$1"
    cmd="wget -q -O - '${page}' | htmlq -a href -- 'li.grid > a:nth-child(2)'"
    filter=" | grep -v .gitattributes | grep -v README.md"
    shift
    while [[ "$1" != "" ]]
    do
        filter="${filter} | grep -F '${1}'"
        shift
    done

    for i in $(eval "${cmd} ${filter}")
    do
        if [[ "$NOP" == "1" ]]; then
            echo "${host}${i}"
            continue
        fi
        dl_no_link "${host}${i}"
    done
}

# download all files from huggingface page, with directory structure (with wget)
#
# this requires htmlq, a tool written in rust, to parse html
# download at https://github.com/mgdm/htmlq or install with cargo install htmlq
#
# usage: dl_hf_page URL [FILTER1 FILTER2 ...]
#
# for example, https://huggingface.co/org/repo/tree/main will download all files in the page.
# README.md and .gitattributes will be excluded.
#
# to download only files with .safetensors extension, use
# dl_hf_page https://huggingface.co/org/repo/tree/main .safetensors
#
# to list files without downloading, use
# NOP=1 dl_hf_page https://huggingface.co/org/repo/tree/main .safetensors
#
# this function will create link to the downloaded files
function dl_hf_page_link {
    host="https://huggingface.co"
    page="$1"
    cmd="wget -q -O - '${page}' | htmlq -a href -- 'li.grid > a:nth-child(2)'"
    filter=" | grep -v .gitattributes | grep -v README.md"
    shift
    while [[ "$1" != "" ]]
    do
        filter="${filter} | grep -F '${1}'"
        shift
    done

    for i in $(eval "${cmd} ${filter}")
    do
        if [[ "$NOP" == "1" ]]; then
            echo "${host}${i}"
            continue
        fi
        dl_with_dir "${host}${i}"
    done
}
