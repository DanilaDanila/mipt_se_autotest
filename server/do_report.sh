#!/bin/bash

HOME="/home/pi/mipt_se_autotest/server"
REPORTS=$HOME/reports
STATUS=$HOME/table.csv

cd $HOME
echo -n "RUN " >> $HOME/log.log
date >> $HOME/log.log

rm -rf workdir/*

echo "name,build,rational,m3i" > table.csv

for repo in $(cat repos.list)
{
    cd $HOME/workdir
    DIRNAME=$(basename $repo)

    echo -n "$DIRNAME," >> $STATUS

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

	# ##### RATIONAL #####
	r_test=$(find prj.lab/rational -executable -type f | head -1)

	if [ ! -z "$r_test" ]; then
    	$r_test 1>$REPORTS/rational/$DIRNAME.log 2>$REPORTS/rational/$DIRNAME.log
    	if [ $? -ne 0 ]; then
        	echo -n "smth wrong with you test," >> $STATUS
    	else
        	echo -n "may be ok...," >> $STATUS
    	fi
	else
		echo -n "no test(s)(.exe)," >> $STATUS
	fi

	# ##### M3I #####
	m_test=$(find prj.lab/m3i -executable -type f | head -1)

	if [ ! -z "$r_test" ]; then
    	$m_test 1>$REPORTS/m3i/$DIRNAME.log 2>$REPORTS/m3i/$DIRNAME.log
    	if [ $? -ne 0 ]; then
        	echo -n "smth wrong with you test," >> $STATUS
    	else
        	echo -n "may be ok...," >> $STATUS
    	fi
	else
		echo -n "no test(s)(.exe)," >> $STATUS
	fi

	echo "" >> $STATUS
}

cd $HOME
rm -rf workdir/*
