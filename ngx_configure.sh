#!/bin/bash

if [ "$#" -lt 1 ]
then
    echo "Note: search source directories of modules in the current directory!"
fi

SRC_MODULE_PATH=${1:-.}
NGX_CONFIGURE_URL="https://raw.githubusercontent.com/lyokha/"`
    `"nginx-configure/master/ngx_configure.dhall"

(
eval "$(SRC_MODULE_PATH="$SRC_MODULE_PATH" "`
    `"dhall-to-bash --declare NGXOPTS <<< "`
    `""let ngxConfigure = $NGX_CONFIGURE_URL in (ngxConfigure).all")";
CMD="${NGXOPTS[vars]} ./configure ${NGXOPTS[opts]}";
echo "$CMD";
sh -c "$CMD"
)
