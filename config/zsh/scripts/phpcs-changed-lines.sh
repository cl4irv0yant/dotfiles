#!/bin/bash

files=$(mktemp)
diff=$(mktemp)

git diff --cached --name-only --diff-filter=ACMR -- "*.php" > ${files}
git diff --cached > ${diff}

phpcs=$(mktemp)
./vendor/bin/phpcs --file-list=${files} --parallel=2 --report=json > ${phpcs} || true

./vendor/bin/diffFilter --phpcs ${diff} ${phpcs}
