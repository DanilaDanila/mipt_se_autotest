#!/bin/bash

PWD="/home/danila/mipt_se_autotest/server/scripts"
cd $PWD

cat ../templates/index.first > ../index.html
./print_table.py >> ../index.html
cat ../templates/index.second >> ../index.html
