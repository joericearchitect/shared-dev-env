# *********************************************************************************
# Description: Builds a docker image for this node app
# Author:      Joe Rice
# Created:     10/14/2016
#
# Notes:
#    Uses the Dockerfile in this same git repo
# *********************************************************************************

MACHINE_IP=$1
LOCAL_FILE=$2
REMOTE_FILE=$3
SCP_USER=ubuntu

scp -i $AWS_KEY_FILE_PATH -r $LOCAL_FILE $SCP_USER@$MACHINE_IP:$REMOTE_FILE