#!/bin/bash

# Install GitForWindows, it comes with Git Bash - Bash Shell, the Linux Console:
# https://git-scm.com/download/win
# (or you can try to use your Windows 10 unix shell)
#
# Next step: Change the URL and save folder below
# Double click "steamprofilecomments.sh"
# Press Ctrl+C to close this script

# or Start from Terminal: Launch "Git Bash" in the folder where you saved this script
# and write "sh comment-watcher.sh", press Enter to start this script

# ~ is home folder. C:/Users/<USER>/ on Windows
# ~ DOESNT WORK ON WINDOWS! MINGW64 doesn't evaluate it correctly when used not on console!
# $(pwd) is the current folder (if you Double-Click: where the script is saved)
savefolder="$(pwd)"
tmpfile="/tmp/steam_allcomments"
# sleep time between downloads. 5 seconds is stalkerlevel 80
sleeptime=5

# Instructions:
# 1. Replace "YOURPROFILE" with your Steam profile URL.
#    For example, if your Steam profile URL is: https://steamcommunity.com/id/exampleprofile,
#    then replace "YOURPROFILE" with "exampleprofile".
#
# 2. If your profile URL looks like this: https://steamcommunity.com/profile/12345678901234567,
#    you need to use your Steam64 ID in the URL instead.
#    Replace "12345678901234567" with your Steam64 ID in the URL below.

# Example for SteamID profile:
# url="https://steamcommunity.com/profile/12345678901234567/allcomments"


# Example for Steam custom URL: (Change it)
url="https://steamcommunity.com/id/YOURPROFILE/allcomments"



echo -e "\n##########################################"
echo "# NavidArtworks.com - 500+ Designs Ready #"
echo "# 50% OFF + Delivered in 1 Hour          #"
echo "# Custom Unique Artwork Available!       #"
echo "# Script Created by NavidArtworks.com    #"
echo "##########################################"

# Function to download comments page by page
download_comments() {
    local page=1
    local has_more=true
    local olddate=""

    while $has_more; do
        if [[ $page -eq 1 ]]; then
            curl --silent $url > $tmpfile
        else
            curl --silent "${url}?ctp=${page}" > $tmpfile
        fi

        newdate=$(egrep -o -m 1 'data\-timestamp\=.([[:digit:]]+).' $tmpfile | egrep -o "[[:digit:]]+")

        if [[ ! -z $olddate && $olddate != $newdate ]]; then
            echo "New comment found from: "$(date --date="@$newdate" +%Y%M%d_%H-%M-%S)
            mv $tmpfile "$(echo $savefolder)/steamcomment_"$(date --date="@$newdate" +%Y%M%d_%H-%M-%S)".html"
            olddate=$newdate
            ((page++))
        elif [[ -z $newdate ]]; then
            echo -e "Couldn't extract NEWDATE! Maybe the download failed!"
            ((page++))
        elif [[ $olddate == $newdate ]]; then
            # do nothing to avoid console spam
            :
        else
            # set olddate, but don't download the page. May miss the first comment of the day
            if [[ -z $olddate ]]; then
                echo "Skipping first comment: "$(date --date="@$newdate" +%Y%M%d_%H-%M-%S)
            fi
            olddate=$newdate
            echo "Olddate updated to: "$(date --date="@$olddate" +%Y%M%d_%H-%M-%S)
        fi

        # Check for the end of comments
        if ! grep -q 'commentthread_comment' $tmpfile; then
            has_more=false
        fi

        sleep $sleeptime
    done

    echo -e "\nDownload complete. All comments have been saved."
}

# Run the function to download comments
download_comments
