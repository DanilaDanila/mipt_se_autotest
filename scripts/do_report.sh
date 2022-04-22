#!/bin/bash

WORKDIR=$1
REPORTS=$2
CMAKE=$3
INFILE=$4
OUTFILE=$5

cd $WORKDIR
echo -n "RUN " >> log.log
date >> log.log

rm -rf $REPORTS/build $REPORTS/rational $REPORTS/m3i
mkdir $REPORTS/build
mkdir $REPORTS/rational
mkdir $REPORTS/m3i

rm -rf tmpdir
mkdir tmpdir

echo "name,build,rational,m3i" > $OUTFILE

for repo in $(cat $INFILE)
{
    cd $WORKDIR/tmpdir
    DIRNAME=$(basename $repo)

    echo -e "\t$DIRNAME" >> $WORKDIR/log.log

    echo -n "$DIRNAME," >> $OUTFILE

    svn co $repo > /dev/null
    if [ $? -ne 0 ]; then
        echo "svn co error" > $REPORTS/build/$DIRNAME.log
        echo "skipped,," >> $OUTFILE
        continue
    fi

    cp $CMAKE $WORKDIR/tmpdir/.

    export PROJECT_DIRECTORY=$WORKDIR/tmpdir/$DIRNAME
    rm -rf build
    mkdir build && cd build
    if [ $? -ne 0 ]; then
        echo "cd error" > $REPORTS/build/$DIRNAME.log
        echo "skipped,," >> $OUTFILE
        continue
    fi

    cmake .. 1>$REPORTS/build/$DIRNAME.log 2>$REPORTS/build/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo "cmake failed,," >> $OUTFILE
        continue
    fi

    make 1>$REPORTS/build/$DIRNAME.log 2>$REPORTS/build/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo "make failed,," >> $OUTFILE
        continue
    fi

    echo -n "build OK," >> $OUTFILE

    #####  RATIONAL #####
    ctest -R RationalTest --quiet --output-log $REPORTS/rational/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo -n "test failed," >> $OUTFILE
    else
        echo -n "test ok," >> $OUTFILE
    fi

    #####    M3i    #####
    ctest -R M3iTest --quiet --output-log $REPORTS/m3i/$DIRNAME.log
    if [ $? -ne 0 ]; then
        echo -n "test failed" >> $OUTFILE
    else
        echo -n "test ok" >> $OUTFILE
    fi

	echo "" >> $OUTFILE

    rm -rf $WORKDIR/tmpdir/$DIRNAME
}

cd $WORKDIR
rm -rf tmpdir

echo "DONE" >> log.log
