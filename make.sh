#!/bin/bash

case $1 in
    wgetall)
        year="$2"
        while read -r line; do
            ./make.sh "$line" "$year"
            sleep 2
        done <<< "$URL_LIST"
        ;;
    https://*)
        bash src/wget.sh "$@"
        ;;
    raw | raw/)
        find raw -type f | grep -v '.html$' | while read -r line; do
            mv "$line" "$line.html"
        done
        ;;
    predoc | predoc/)
        find predoc -name index.TEX -delete
        find predoc -mindepth 2 -maxdepth 2 -type d | grep -v index.TEX | sort | while read -r line; do
            spec="$(cut -d/ -f2- <<< "$line")"
            echo "spec=$spec"
            cat "extracted/$spec.question.txt" | sed 's|^|\\zhihuquestion{|' | sed 's|$|}|' > "$line/index.TEX"
        done
        ### Generate 'predoc/2023/624165442/index.TEX'
        find predoc -mindepth 2 -maxdepth 2 -type d | while read -r line; do
            find "$line" -mindepth 1 -maxdepth 1 -type f -name '*.TEX' | sort | grep -v index.TEX | sed 's|^|\\input{|' | sed 's|$|}|' >> "$line/index.TEX"
        done
        ### Generate 'predoc/2023/index.TEX'
        find predoc -mindepth 1 -maxdepth 1 -type d | while read -r line; do
            find "$line" -mindepth 2 -maxdepth 2 -name 'index.TEX' | sort | sed 's|^|\\input{|' | sed 's|$|}|' > "$line/index.TEX"
        done
        ;;
    extracted/*/*/*.html)
        ### Extracted answer
        dest_path="predoc/$(cut -d/ -f2- <<< "$1" | cut -d. -f1)"
        dirname "$dest_path" | xargs mkdir -p
        bash src/mklatex-answer.sh "$1" > "$dest_path.TEX"
        ;;
    raw/*/*/*.html)
        ### Raw answer
        dest_path="extracted/$(cut -d/ -f2- <<< "$1")"
        dirname "$dest_path" | xargs mkdir -p
        bash src/xpath.sh "$1" > "$dest_path"
        pup -p 'section#answer-body.item-border.block.w-full.h-auto.overflow-hidden.divide-y.divide-gray-200.bg-white div.w-full.block.px-4.py-6 div.flex-1.flex.justify-between.items-center div.flex.items-center span text{}' < "$1" > "$dest_path.author.txt"
        pup -p 'main.w-screen.overflow-x-hidden.mt-16.mb-20 div.shadow.overflow-x-hidden section#answer-header.w-full.h-auto.mb-4.p-4.bg-white h1.mb-2.text-lg.tracking-wider.font-medium a text{}' < "$1" > "$(dirname "$dest_path").question.txt"
        ./make.sh "$dest_path"
        ;;
    raw/*)
        ### If input path is a directory, make all children recursively!
        if [[ -d "$1" ]]; then
            list="$(find "$1" -mindepth 1 -maxdepth 1)"
            while read -r line; do
                ./make.sh "$line" &
            done <<< "$list"
        fi
        wait
        ;;
    yearbooks/*.)
        if [[ -e "$1"tex ]]; then
            ./make.sh "$1"tex
        fi
        ;;
    yearbooks/*.tex)
        dir="$(dirname "$1")"
        xelatex -interaction=batchmode -output-directory="$dir" "$1"
        xelatex -interaction=batchmode -output-directory="$dir" "$1"
        pdf_path="${1/tex/pdf}"
        du -h "$(realpath "$pdf_path")"
        ;;
esac
