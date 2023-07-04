# ipurge_r.sh

NAME

       ipurge_r.sh - A script to clean up user mailboxes based on specified criteria.

SYNOPSIS

        ipurge_r.sh [-v,-h]

DESCRIPTION

        The ipurge_r.sh script is designed to help clean up user mailboxes by removing old email messages based on the specified age. It prompts the user for input and performs the cleanup operation accordingly.

OPTIONS

        -v, --version
              Display the version of the script and exit.

        -h, --help
              Display the help message and exit.

USAGE

       The ipurge_r.sh script prompts for the UID of the user and the date up to which the mailbox should be cleaned. It then performs the cleanup operation, either in dry run mode or live mode, based on user selection.

       Once executed, the script performs the following steps:

       1. Prompts the user to enter the UID of the user.
       2. Sets the user's mailbox path based on the provided UID.
       3. Moves to the user's mailbox location in the filesystem.
       4. Prompts the user to enter the date to clean up to in the format YYYY-MM-DD.
       5. Checks that the number of days is greater than 3 years (1095 days). If not, it displays an error message and exits.
       6. Performs a sanity check with the user to confirm the entered date.
       7. Asks the user if a dry run should be performed before the actual cleanup.
       8. Depending on the user's choice, performs the cleanup either in dry run mode or live mode.
       9. Prints the progress as it operates on each user mailbox.
       10. Ends the script when the cleanup is complete.

EXAMPLES

       To display the version of the script:
              ipurge_r.sh -v

       To run the ipurge_r.sh script:
              ipurge_r.sh

AUTHOR

       Written by klesk32

REPORTING BUGS

       Report any bugs to klesk32@live.com.

COPYRIGHT

       This script is licensed under the GNU AGPLv3 license.

SEE ALSO

       The `cyrus` command documentation for more information on the `ipurge` subcommand.
