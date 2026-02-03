#!/bin/bash
# from https://gist.github.com/icheko/9ff2a0a90ef2b676a5fc8d76f69db1d3
# before running this script, run 
# shield_name="bgkeeb"
# remote_repo="ezxzeng/zmk-bgkeeb"
# remote_branch="main"
shield_name="sweepsq"
remote_repo="ezxzeng/sweepsq-zmk"
remote_branch="main"

PREFIX="boards/shields/${shield_name}"

git remote -v | grep -w ${shield_name} || git remote add ${shield_name} git@github.com:${remote_repo}.git
SOURCE_BRANCH="${shield_name}-source"
STAGING_BRANCH="${shield_name}-staging"

echo
echo "Fetch new changes from ${shield_name}"
echo -----------------------------------------
git fetch ${shield_name} ${remote_branch}

LATEST_COMMIT=`git ls-remote ${shield_name} | grep "refs/heads/${remote_branch}" | awk '{ print $1}'`
echo
echo "${shield_name} latest commit: ${LATEST_COMMIT}"
echo

# checkout source repo
git checkout -B ${SOURCE_BRANCH} ${shield_name}/${remote_branch}

# create new staging branch from all the commits impacting "/my-chart" from source repo
git subtree split -P boards/shields/${shield_name} -b ${STAGING_BRANCH}

# echo Hi. >> config/boards/shields/${shield_name}/test.txt
# git add config/boards/shields/${shield_name}/test.txt
# git commit -am "test"
# echo Hi. >> test.txt
# git add test.txt
# git commit -am "test_root"

git checkout main

# create new staging branch from all the commits impacting "/my-chart" from source repo
echo
echo "Add in changes"
echo -----------------------------------------
MSG="Update ${shield_name} from https://github.com/${remote_repo}/commit/${LATEST_COMMIT}"
if [ -d "${PREFIX}" ]; then
  # Prefix already exists → update existing subtree
  git subtree merge -P "${PREFIX}" "${STAGING_BRANCH}" --message "${MSG}" 
else
  # Prefix does not exist yet → initial add
  git subtree add -P "${PREFIX}" "${STAGING_BRANCH}" --message "${MSG}" 
fi

# clean up
echo
echo
git branch -D ${STAGING_BRANCH}
git branch -D ${SOURCE_BRANCH}
