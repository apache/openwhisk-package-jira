#!/bin/bash
#
# use the command line interface to install pushnotifications package.
# this script is in blue because it need blue whisk.properties.
#

: ${WHISK_SYSTEM_AUTH:?"WHISK_SYSTEM_AUTH must be set and non-empty"}
AUTH_KEY=$WHISK_SYSTEM_AUTH

SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
CATALOG_HOME=$SCRIPTDIR
source "$CATALOG_HOME/util.sh"

dir=jira
git clone git@github.com:openwhisk/wsk-pkg-jira.git "$dir"

if [ -f installJiraPackage.sh ] ; then
    rm installJiraPackage.sh
fi
cp $CATALOG_HOME/jira/installJiraPackage.sh $CATALOG_HOME

./installJiraPackage.sh

waitForAll

echo jira package ERRORS = $ERRORS
exit $ERRORS