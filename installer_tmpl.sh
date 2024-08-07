#!/usr/bin/bash

# helper function
function ensure_dir {
    if [[ ! -d "webui/$1" ]]
    then
        mv "source/$1" "webui/$1"
    fi
}

if [[ -z "$NO_PREPARE_DIR" ]]
then
    # create (might) needed directories that not in sdwebui repo
    for dir in .cache config_states GFPGAN log outputs repositories venv
    do
        mkdir -p "webui/$dir"
    done

    # create settings if needed
    touch webui/config.json webui/ui-config.json

    # clone the repo and move the needed directories
    git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui source
    for dir in configs embeddings extensions localizations models scripts textual_inversion_templates
    do
        ensure_dir "$dir"
    done
    rm -fr source
fi

echo 'IyBDb21tYW5kbGluZSBhcmd1bWVudHMgZm9yIHdlYnVpLnB5LCBmb3IgZXhhbXBsZTogZXhwb3J0IENPTU1BTkRMSU5FX0FSR1M9Ii0tbWVkdnJhbSAtLW9wdC1zcGxpdC1hdHRlbnRpb24iCiMgQ09NTUFORExJTkVfQVJHUz0iIgoKIyBpbnN0YWxsIGNvbW1hbmQgZm9yIHRvcmNoCiMgVE9SQ0hfQ09NTUFORD0icGlwIGluc3RhbGwgdG9yY2g9PTEuMTIuMStjdTExMyAtLWV4dHJhLWluZGV4LXVybCBodHRwczovL2Rvd25sb2FkLnB5dG9yY2gub3JnL3dobC9jdTExMyIKCiMgUmVxdWlyZW1lbnRzIGZpbGUgdG8gdXNlIGZvciBzdGFibGUtZGlmZnVzaW9uLXdlYnVpCiMgUkVRU19GSUxFPSJyZXF1aXJlbWVudHNfdmVyc2lvbnMudHh0IgoKIyBVbmNvbW1lbnQgdG8gZW5hYmxlIGFjY2VsZXJhdGVkIGxhdW5jaAojIEFDQ0VMRVJBVEU9IlRydWUiCiMgVW5jb21tZW50IHRvIGRpc2FibGUgVENNYWxsb2MKIyBOT19UQ01BTExPQz0iVHJ1ZSIKCiMgc29tZSBoYWNrcywgdXNlIG9ubHkgaWYgeW91IGtub3cgd2hhdCB5b3UgYXJlIGRvaW5nCiMgUFJPVE9DT0xfQlVGRkVSU19QWVRIT05fSU1QTEVNRU5UQVRJT049cHl0aG9uCiMgUFlUT1JDSF9DVURBX0FMTE9DX0NPTkY9Z2FyYmFnZV9jb2xsZWN0aW9uX3RocmVzaG9sZDowLjksbWF4X3NwbGl0X3NpemVfbWI6NTEyCgo=' | base64 -d > webui/.env
