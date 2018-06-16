#!/usr/bin/env bash

# TODO:
# - This is painfully slow. Ensure this is ran only when the file
#   .circleci/config.yml is modified.
[ 'true' = "${CI}" ] && exit 0
[ -z "$(which circleci)" ] && { echo "CircleCI CLI is not installed. Cannot validate your configuration file." >&2 ; exit 0 ; }

# The following line is needed by the CircleCI Local Build Tool (due to Docker interactivity)
exec < /dev/tty

# If validation fails, tell Git to stop and provide error message. Otherwise, continue.
if ! error_message=$(circleci config validate -c .circleci/config.yml); then
    echo "CircleCI Configuration Failed Validation."
    echo $error_message
    exit 1
fi

# vim: et:sw
