#!/bin/bash
#==============================================
# pull all the git repository under 'myCodes'
# 
# Kent (kent.yuan at gmail.com)
# 2014-05-12 22:50:42 
#==============================================

CODE_BASE=(/home/kent/MyStuff/myCodes 
/home/kent/lib
)
EXCLUDE_PATT="gitTest"

for base in ${CODE_BASE[@]};do
	echo "##########################"
	echo "   scanning $base"
	echo "##########################"
	for line in $(find "$base" -name ".git"|grep -v "$EXCLUDE_PATT"); do
		line=$(sed 's#/\.git##'<<<"$line")
		repo=$(awk -F'/' '$0=$NF' <<<"$line")
		echo "====> Pulling Repository: $repo <===="
		git -C "$line" pull
	done
done
