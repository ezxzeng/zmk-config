#!/bin/bash
# from https://gist.github.com/icheko/9ff2a0a90ef2b676a5fc8d76f69db1d3
SOURCE_BRANCH="bgkeeb-source"
STAGING_BRANCH="bgkeeb-staging"

echo
echo "Fetch new changes from bgkeeb"
echo -----------------------------------------
git fetch bgkeeb main

BGKEEB_LATEST_COMMIT=`git ls-remote bgkeeb | grep "refs/heads/main" | awk '{ print $1}'`
echo
echo "bgkeeb latest commit: ${HELMCHARTS_LATEST_COMMIT}"
echo

# checkout source repo
git checkout -b ${SOURCE_BRANCH} bgkeeb/main
# echo Hi. >> config/boards/shields/bgkeeb/test.txt
# git add config/boards/shields/bgkeeb/test.txt
# git commit -am "test"

# create new staging branch from all the commits impacting "/my-chart" from source repo
git subtree split -P config/boards/shields/bgkeeb -b ${STAGING_BRANCH} --onto main

# checkout master
git checkout main

# clean up
echo
echo
git branch -D ${STAGING_BRANCH}
git branch -D ${SOURCE_BRANCH}