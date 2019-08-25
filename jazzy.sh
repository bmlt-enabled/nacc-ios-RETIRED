#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
rm -drf docs
jazzy   --github_url https://github.com/LittleGreenViper/nacc-ios \
        --readme ./README.md \
        --theme fullwidth \
        --author Little\ Green\ Viper\ Software\ Development\ LLC \
        --author_url https://littlegreenviper.com \
        --module NACC \
        --min-acl private \
        --copyright [©2019\ Little\ Green\ Viper\ Software\ Development\ LLC]\(https://littlegreenviper.com\)
cp img/*.* docs/img/
cd "${CWD}"
