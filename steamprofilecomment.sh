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






echo -e "\n##########################################"
echo "# NavidArtworks.com - 500+ Designs Ready #"
echo "# 50% OFF + Delivered in 1 Hour          #"
echo "# Custom Unique Artwork Available!       #"
echo "# Script Created by NavidArtworks.com    #"
echo "##########################################"

#!/bin/bash

# Configuration
savefolder="$(pwd)"  # Save folder is the current directory
url="https://steamcommunity.com/id/YOURPROFILE/allcomments"  # Replace with your desired Steam profile URL
tmpfile="/tmp/steam_comments"
comment_file="all_comments.html"

# Function to download comments page by page
download_comments() {
    local page=1
    local has_more=true

    # Create or clear the comment file
    echo "" > "$comment_file"

    while $has_more; do
        # Fetch the comments page with the correct page parameter
        if [[ $page -eq 1 ]]; then
            curl --silent "$url" > "$tmpfile"
        else
            curl --silent "${url}?ctp=${page}" > "$tmpfile"
        fi

        # Check if the file contains comments
        if grep -q 'commentthread_comment' "$tmpfile"; then
            echo "Downloading page $page..."
            
            # Append the content to the comment file
            cat "$tmpfile" >> "$comment_file"

            # Increment the page value
            ((page++))
        else
            has_more=false
            echo "No more comments to download. Finished at page $((page - 1))."
        fi
    done

    # Clean up the temporary file
    rm "$tmpfile"
}

# Run the function to download comments
download_comments
