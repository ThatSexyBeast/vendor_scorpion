#!/bin/bash

export Changelog="$ANDROID_PRODUCT_OUT/obj/CHANGELOG/Changelog.html"


if [ -f $Changelog ];
then
	rm -f $Changelog
fi

touch $Changelog

# Print something to build output
echo "Generating changelog..."

cat $ANDROID_BUILD_TOP/vendor/scorpion/tools/changelog_header.fhtml > $Changelog

for i in $(seq 10)
do
export After_Date=`date --date="$i days ago" +%m-%d-%Y`
k=$(expr $i - 1)
	export Until_Date=`date --date="$k days ago" +%m-%d-%Y`

	# Line with after --- until was too long for a small ListView
	echo '<br />' >> $Changelog
        echo "<h2>$Until_Date</h2>" >> $Changelog
	echo '<ul>' >> $Changelog

	# Cycle through every repo to find commits between 2 dates
	repo forall -pc 'git log --oneline --after=$After_Date --until=$Until_Date' > /tmp/changelog.tmp

        while read line; do
            first=$(echo $line | awk '{ print $1 }')
            if [[ $first == project* ]]; then
                echo '<br />' >> $Changelog
                echo "<h3>$(echo $line | sed 's/project //g')</h3>" >> $Changelog
                echo '<br />' >> $Changelog
            elif [[ $line == "" ]]; then
                echo > /dev/null # Quietly don't do anything, because the line is empty
            else
                sha=$(echo $line | awk '{ print $1 }')
                rest=$(echo $line | sed "s/$sha//g")
                echo "<li><span class='commit'>$sha</span>$rest</li>" >> $Changelog
            fi
        done < /tmp/changelog.tmp

        echo '</ul>' >> $Changelog
done

cat $ANDROID_BUILD_TOP/vendor/scorpion/tools/changelog_footer.fhtml >> $Changelog

rm /tmp/changelog.tmp
