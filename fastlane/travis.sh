#!/bin/sh

# The wished fastlane version is also speicified in the Fastfile
sudo gem install -n /usr/local/bin fastlane  -v 2.8.0

fastlane test --verbose
exit $?
