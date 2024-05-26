#!/bin/bash
REPODIR="$PWD"

# Example: https://freezhihu.org/question/114514/answer/1919810
href="$1"
year="$2"
[[ -z "$year" ]] && year="$(TZ=UTC date +%Y)"

dir="raw/$year/$(cut -d/ -f5 <<< "$href")"
mkdir -p "$dir"

outfn="$dir/$(cut -d/ -f7 <<< "$href").html"
curl "$href" > "$outfn"

echo "outfn=$outfn"

