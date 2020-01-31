#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
rm -drf docs
jazzy   --github_url https://github.com/bmlt-enabled/nacc-ios \
        --readme ./README.md \
        --theme fullwidth \
        --author Little\ Green\ Viper\ Software\ Development\ LLC \
        --author_url https://bmlt.app \
        --module NACC \
        --min-acl private \
        --copyright [©2020\ BMLT-Enabled]\(https://bmlt.app\)
cp img/*.* docs/img/
cd "${CWD}"
