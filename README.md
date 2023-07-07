# ipurge_r.sh

A way to recursively use ipurge on a user mailbox

## Script flags

-v, --version
    Displays the version of the script

-h, --help
    Displays the help message

## Usage

The ipurge_r.sh script prompts for the UID of the user and the date up to whicthe mailbox should be cleaned. It then performs the cleanup operation, either idry run mode or live mode, based on user selection.

Once executed, the script performs the following steps:

* Prompts the user to enter the UID of the user.
* Sets the user's mailbox path based on the provided UID.
* Moves to the user's mailbox location in the filesystem.
* Prompts the user to enter the date to clean up to in the format YYYY-MM-DD.
* Checks that the number of days is greater than 3 years (1095 days). If not, it displays an error message and exits.
* Performs a sanity check with the user to confirm the entered date.
* Asks the user if a dry run should be performed before the actual cleanup.
* Depending on the user's choice, performs the cleanup either in dry run mode or live mode.
* Prints the progress as it operates on each user mailbox.
* Ends the script when the cleanup is complete.

## Copyright

This script is licensed under the GNU AGPLv3 license.

## See also

The "cyrus" command documentation for more information on the "ipurge" subcommand.
