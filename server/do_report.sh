#!/bin/bash

HOME=$(pwd)
REPORTS=$HOME/reports
STATUS=$HOME/table.csv

rm -rf workdir/*

echo "name,build,rational,m3i" > table.csv

for repo in $(cat repos.list)
{
    cd $HOME/workdir
    DIRNAME=$(basename $repo)

    echo -n "$DIRNAME," >> $STATUS
    echo NAME: $DIRNAME

    svn co $repo > /dev/null
    if [ $? -ne 0 ]; then
        echo "svn co error" > $REPORTS/$DIRNAME.log
        echo "skipped," >> $STATUS
        continue
    fi

    cd $DIRNAME && mkdir build && cd build
    if [ $? -ne 0 ]; then
        echo "cd error" > $REPORTS/$DIRNAME.log
        echo "skipped,," >> $STATUS
        continue
    fi

    cmake .. 1>$REPORTS/$DIRNAME.log 2>$REPORTS/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo "cmake failed,," >> $STATUS
        continue
    fi

    make 1>$REPORTS/$DIRNAME.log 2>$REPORTS/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo "make failed,," >> $STATUS
        continue
    fi

    echo -n "build OK," >> $STATUS

    ./prj.lab/rational/test 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -n "smth wrong with you test," >> $STATUS
    else
        echo -n "may be ok...," >> $STATUS
    fi

    ./prj.lab/m3i/test 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -n "smth wrong with you test," >> $STATUS
    else
        echo -n "may be ok...," >> $STATUS
    fi
}

cd $HOME
rm -rf workdir/*
