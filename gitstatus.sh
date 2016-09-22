#!/bin/bash

verbosity=2
git_fetch=false

if [ $# -eq 0 ]; then
	cd $(dirname $0)
	less README.md
fi

if [ $# -ge 1 ]; then
	git_root="$1"
fi

if [ $# -ge 2 ]; then
	verbosity=$2
fi

if [ $# -ge 3 ]; then
	git_fetch=true
fi

declare -A changes

sum_actions=0
verbose=""
IFS_BACKUP="$IFS"
for git_repo in $(find $git_root -name .git -type d); do
	IFS="$IFS_BACKUP"
	cd $git_repo/..
	if [ $git_fetch = true ]; then
		git fetch
	fi
	sum_repo_actions=$(git status -s | wc -l)
	sum_actions=$(expr $sum_actions + $sum_repo_actions)
	if [ $verbosity -eq 3 ] && [ $sum_repo_actions -ne 0 ]; then
		echo "$git_repo"
	fi
	if [ $verbosity -eq 3 ]; then
		git status -s
	fi
	if [ $verbosity -eq 4 ]; then
		echo "---"
		echo "$git_repo"
		git status
	fi
	if [ $verbosity -eq 2 ] || [ $verbosity -eq 5 ]; then
		IFS=$'\n'
		for action in $(git status -s 2>&1); do
			index="${action:1:1}"
			echo ${!changes[@]} | grep $index 1>/dev/null 2>/dev/null
			if [ $? -ne 0 ]; then
				changes[$index]=0
			else
				number=${changes[$index]}
				changes[$index]=$((${changes[$index]} + 1))
			fi
		done
	fi
done

if [ $verbosity -eq 1 ]; then
	echo "Git: $sum_actions"
fi
if [ $verbosity -eq 2 ]; then
	first=false
	for i in ${!changes[@]}; do
		if [ $first = true ]; then
			echo -n ", "
		else
			first=true
		fi
		echo -n "$i: ${changes[$i]}"
	done
	echo ""
fi

exit $sum_actions
