#!/bin/bash

set -e

# https://help.github.com/articles/configuring-a-remote-for-a-fork/
# git remote -v
if ! git remote -v | grep ^upstream >/dev/null ; then
	cat <EOM >&2
Configure upstream repo first
See: https://help.github.com/articles/configuring-a-remote-for-a-fork/
    git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
    git remote -v
EOM
	exit 1
fi

SYNCBRANCHES=`git branch -a | grep upstream | awk -F/ '{print $3}'`

# https://help.github.com/articles/syncing-a-fork/

git fetch -p
git fetch upstream
for branch in ${SYNCBRANCHES} ; do
	git checkout ${branch}
	git merge upstream/${branch}
	git push origin
done
