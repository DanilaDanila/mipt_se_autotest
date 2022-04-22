#!/bin/bash

HOME="/home/danila/mipt_se_autotest/scripts"
REPORTS_PATH=$1
TABLE_PATH=$2
cd $HOME

cat ../templates/index.first > ../server/index.html
./print_table.py $REPORTS_PATH $TABLE_PATH >> ../server/index.html
cat ../templates/index.second >> ../server/index.html
