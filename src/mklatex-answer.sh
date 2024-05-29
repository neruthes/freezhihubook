#!/bin/bash

extracted_path="$1" # Should start with 'extracted'!
predoc_path="$(sed 's|extracted|predoc|' <<< "$predoc_path" | sed 's|.html|.txt|')"
author="$(cat "$extracted_path.author.txt")"

q_id="$(cut -d/ -f3 <<< "$extracted_path")"
a_id="$(cut -d/ -f4 <<< "$extracted_path" | cut -d. -f1)"

raw_url="https://freezhihu.org/question/$q_id/answer/$a_id"

echo '\begin{zhihuanswer}'

echo -n '\answerAuthor{'"$author"'}'
echo -n '\answerUrl{'"$raw_url"'}'

node src/htmlcleanup.js "$1" | pandoc -f html -t plain | pandoc -f markdown+smart -t latex

echo '\end{zhihuanswer}'
