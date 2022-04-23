#!/bin/bash

function logbegin() {
    echo "<html>"
    echo "<head><title>log</title></head>"
    echo "<body>"
    echo "<pre>"
}

function logend() {
    echo "</pre>"
    echo "</body>"
    echo "</html>"
}

function log2html() {
    HOME=$(pwd)
    cd $1
    for file in $(ls -1)
    {
        newfile=$(basename $file .log).html
        logbegin > $newfile
        cat $file >> $newfile
        logend >> $newfile
    
        rm $file
    }
    cd $HOME
}

HOME="/home/danila/mipt_se_autotest"
REPORTS="$HOME/output/reports"
WORKDIR="$HOME/output/workdir"
REPOS_LIST="$HOME/repos.list"
TABLE_CSV="$HOME/table.csv"
PATH_TO_CMAKE="$HOME/scripts/CMakeLists.txt"

cd $HOME

./scripts/do_report.sh $WORKDIR $REPORTS $PATH_TO_CMAKE $REPOS_LIST $TABLE_CSV

log2html $REPORTS/build
log2html $REPORTS/rational
log2html $REPORTS/m3i

./scripts/create_index.sh $HOME/scripts $REPORTS $HOME/table.csv
