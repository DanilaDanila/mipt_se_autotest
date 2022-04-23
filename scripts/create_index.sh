#!/bin/bash

HOME=$1
REPORTS_PATH=$2
TABLE_PATH=$3
cd $HOME

cat ../templates/index.first > ../server/index.html
./print_table.py $REPORTS_PATH $TABLE_PATH >> ../server/index.html
cat ../templates/index.second >> ../server/index.html
