#!/usr/bin/env bash

# Setup env vars and folders for the ctl script
# This helps keep the ctl script as readable
# as possible

# Usage options:
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh JOB_NAME OUTPUT_LABEL
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar nginx

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

JOB_NAME=$1
OUTPUT_LABEL=${2:-${JOB_NAME}}

export JOB_DIR=/var/vcap/jobs/$JOB_NAME
chmod 755 $JOB_DIR # to access file via symlink

# Setup job home folder
export HOME=/var/vcap
export JOB_DIR=$HOME/jobs/$JOB_NAME

# Setup log, run, store and tmp folders
export LOG_DIR=$HOME/sys/log/$JOB_NAME
export RUN_DIR=$HOME/sys/run/$JOB_NAME
export STORE_DIR=$HOME/store/$JOB_NAME
export TMP_DIR=$HOME/sys/tmp/$JOB_NAME
export TMPDIR=$TMP_DIR
for dir in $LOG_DIR $RUN_DIR $STORE_DIR $TMP_DIR
do
  mkdir -p ${dir}
  chown vcap:vcap ${dir}
  chmod 775 ${dir}
done

# Add all packages /bin & /sbin into $PATH
for package_bin_dir in $(ls -d $HOME/packages/*/*bin)
do
  export PATH=${package_bin_dir}:$PATH
done

PID_FILE=$RUN_DIR/$OUTPUT_LABEL.pid

# Load job properties
if [ -f $JOB_DIR/bin/job_properties.sh ]; then
  source $JOB_DIR/bin/job_properties.sh
fi

source $JOB_DIR/helpers/ctl_utils.sh
redirect_output ${OUTPUT_LABEL}
