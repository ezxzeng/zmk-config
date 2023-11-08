#!/bin/bash
# from https://gist.github.com/icheko/9ff2a0a90ef2b676a5fc8d76f69db1d3
# before running this script, run 
shield_name="bgkeeb"
remote_repo="ezxzeng/zmk-bgkeeb"
remote_branch="main"

git remote -v | grep -w ${shield_name} || git remote add ${shield_name} git@github.com:${remote_repo}.git
SOURCE_BRANCH="${shield_name}-source"
STAGING_BRANCH="${shield_name}-staging"

echo
echo "Fetch new changes from ${shield_name}"
echo -----------------------------------------
git fetch ${shield_name} ${remote_branch}

LATEST_COMMIT=`git ls-remote ${shield_name} | grep "refs/heads/${remote_branch}" | awk '{ print $1}'`
echo
echo "${shield_name} latest commit: ${HELMCHARTS_LATEST_COMMIT}"
echo

# checkout source repo
git checkout -b ${SOURCE_BRANCH} ${shield_name}/${remote_branch}
# echo Hi. >> config/boards/shields/${shield_name}/test.txt
# git add config/boards/shields/${shield_name}/test.txt
# git commit -am "test"

# create new staging branch from all the commits impacting "/my-chart" from source repo
git subtree split -P config/boards/shields/${shield_name} -b ${STAGING_BRANCH} --onto main

# checkout master
git checkout main

# clean up
echo
echo
git branch -D ${STAGING_BRANCH}
git branch -D ${SOURCE_BRANCH}