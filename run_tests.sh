#!/bin/bash

# プロジェクトルートへ移動
cd "$(dirname "$0")"

echo "=========================="
echo " Starting Lisp Test Runner"
echo "=========================="

# Lispファイルを実行
# -l オプションでファイルをロードし、その後終了
ros -l tests/runner.lisp

# Lisp側が (sb-ext:exit :code 1) していれば、ここでキャッチできる
if [ $? -eq 0 ]; then
    exit 0
else
    exit 1
fi
