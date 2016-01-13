#!/usr/bin/env sh

if test -n "$(git status --porcelain)"; then
	echo 'Unclean working tree. Commit or stash changes first.' >&2;
	exit 128;
fi

if ! git fetch --quiet 2> /dev/null; then
	echo 'There was a problem fetching your branch.' >&2;
	exit 128;
fi

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
BRANCH=${1:-$CURRENT_BRANCH}
git branch --set-upstream-to=origin/$BRANCH $BRANCH > /dev/null

if test "0" != "$(git rev-list --count --left-only @'{u}'...HEAD)"; then
	echo 'Remote history differ. Please pull changes.' >&2;
	exit 128;
fi

git branch --unset-upstream