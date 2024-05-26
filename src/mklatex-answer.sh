#!/bin/bash

extracted_path="$1" # Should start with 'extracted'!
predoc_path="$(sed 's|extracted|predoc|' <<< "$predoc_path" | sed 's|.html|.txt|')"
author="$(cat "$extracted_path.author.txt")"

echo '\begin{zhihuanswer}'

echo -n '\answerAuthor{'"$author"'}'

node src/htmlcleanup.js "$1" | pandoc -f html -t plain | pandoc -f markdown+smart -t latex

echo '\end{zhihuanswer}'
