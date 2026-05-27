#!/bin/bash
set -e

if [ $# -lt 1 ] ; then
    echo "NOTE: search source directories of modules "`
        `"in the current directory!" 1>&2
fi

if [ ! -x ./configure ] ; then
    echo "ERROR: there is no configure script "`
        `"in the current directory!" 1>&2
    exit 1
fi

if ! ./configure --help | grep -qi nginx ; then
    echo "ERROR: it looks like the current directory "`
        `"is not a directory with Nginx sources!" 1>&2
    exit 1
fi

SRC_MODULE_PATH=$(realpath -e "${1:-.}")
NGX_CONFIGURE_URL='https://raw.githubusercontent.com/lyokha/'`
    `'nginx-configure/master/ngx_configure.dhall'
NGX_CONFIGURE_HASH='sha256:'`
    `'c9577a462b0794dd0002ebd4e95d433d1afc64e98955354b5bd0c88ed60e422c'

(
cmd=$(dhall-to-bash --declare NGXOPTS <<< "`
    `""let ngxConfigure = $NGX_CONFIGURE_URL $NGX_CONFIGURE_HASH "`
    `" in (ngxConfigure).all \"$SRC_MODULE_PATH\"")
eval "$cmd"
cmd="${NGXOPTS[vars]} ./configure ${NGXOPTS[opts]}";
echo "$cmd";
sh -c "$cmd"
)
