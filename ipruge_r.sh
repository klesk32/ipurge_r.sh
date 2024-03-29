#!/bin/bash

version=0.1.1

showHelp=false

# functions
function dryRunOnMailbox () {
    reviewFile="/tmp/$userId.dryrun"
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    cyrus ipurge -d "$daysSince" -f -n -v "$userMailbox" | tee -a "$reviewFile"
    for i in $(du -h | awk -F'\t' '{ print $2 }' | awk -F. '{ print $2 }')
        do
            i=${i/^/.}
            cyrus ipurge -d "$daysSince" -f -n -v "$userMailbox""$i" | tee -a "$reviewFile"
        done
    IFS=$SAVEIFS
}

function liveRunOnMailbox () {
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    cyrus ipurge -d "$daysSince" -f -v "$userMailbox"

    for i in $(du -h | awk -F'\t' '{ print $2 }' | awk -F. '{ print $2 }')
        do
            i=${i/^/.}
            cyrus ipurge -d "$daysSince" -f -v "$userMailbox""$i"
        done
    IFS=$SAVEIFS
}
# functions end


while getopts ":hv" opt; do
  case ${opt} in
    h)
      showHelp=true
      ;;
    v)
      echo "$version"
      exit 0
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ "$showHelp" = true ]; then
    echo "Usage: ipurge_r.sh [OPTIONS]"
    echo "Options:"
    echo "  -h    Show this help message and exit"
    echo "  -v    Show the version of the script"
    echo ""
    echo "Description:"
    echo "This script is designed to clean up user mailboxes by removing old email messages based on the specified criteria."
    exit 0
fi

# Get User uid
echo "Enter the UID of the User:"
read -r userId

# Set the user Mailbox
userMailbox="user/$userId"

# Move to the user's mailbox location in the filesystem
cd "$(cyrus mbpath "$userMailbox")" || exit
currentLocation=$(pwd)
echo "User Mailbox is located in $currentLocation"

# Get date to purge up to from the user
todaysSeconds=$(date +%s)

validDate=false

while [ "$validDate" = false ]; do
    echo "Enter date to clean up to in YYYY-MM-DD format:"
    read -r startYear

    # Check if the entered date is valid
    if ! date -d "$startYear" >/dev/null 2>&1; then
        echo "Invalid date format. Please enter a valid date in YYYY-MM-DD format."
    else
        validDate=true
    fi
done

startDateSeconds=$(date -d "$startYear" +%s)
daysSince=$(((todaysSeconds - startDateSeconds) / (60*60*24)))

# Check that the number of days is greater than 3 Years
if [ $daysSince -lt 1095 ];
then
    echo "Days since date entered: $daysSince."
    echo "Date entered must be more than 3 years in the past! Exiting..."
    exit
fi

# Sanity check the user
yearsSince=$((daysSince / 365))
read -r -p "The date you entered is $yearsSince years ago, does this look corect? [Y/N] : " yearsSinceCheck
case $yearsSinceCheck in
        [yY])
                echo -e "Continuing";;
        [nN])
                echo -e "Skipped and exit script"
                exit 1;;
        *)
                echo "Invalid Option"
                ;;
esac

# Do the cleanup either in dry run mode or live mode
read -r -p "Would you like to do a dry run first? [Y/N] : " dryRunChoice
case $dryRunChoice in
        [yY])
                echo -e "Dry Run selected"
                dryRun=true
                sleep 5;;
        [nN])
                echo -e "Live Mode selected with no dry run prior; there are potential grave consequences, ctrl+c to bail out if you are not sure what you are doing."
                dryRun=false
                sleep 10;;
        *)
                echo "Invalid Option"
                ;;
esac

# Actual cleanup portion of the script

if [ "$dryRun" = true ];
    then
        dryRunOnMailbox
        read -r -p "Dry run complete, hit enter to review the results"
        less "/tmp/$userId.dryrun"
        read -r -p "Would you like to run the script live? [Y/N]: " liveRunChoice
        rm "/tmp/$userId.dryrun"
        case $liveRunChoice in
            [yY])
                echo -e "Doing it again but live"
                liveRunOnMailbox
                echo -e "Live run complete";;
            [nN])
                echo -e "Bailing out"
                exit 1;;
            *)
                echo "Please choose Y or N"
                ;;
        esac
    # For extra safety
    elif [ "$dryRun" = false ];
        then
            liveRunOnMailbox
            echo "Live run complete"
    else
        echo -e "Something went horribly wrong, bailing out"
        exit 1
fi
