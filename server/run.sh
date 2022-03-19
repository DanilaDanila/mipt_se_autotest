#!/bin/bash

PWD="/home/pi/mipt_se_autotest/server"
cd $PWD

./do_report.sh
./scripts/create_index.sh
