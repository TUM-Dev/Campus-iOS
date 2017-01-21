#!/bin/bash

set -e # Exit if a command returns a non-zero code

if [[ ${TRAVIS_BRANCH} == 'master' ]]; then
    FASTLANE_EXPLICIT_OPEN_SIMULATOR=2 travis_retry fastlane integration
elif [[ ${TRAVIS_PULL_REQUEST} != 'false' ]]; then
    FASTLANE_EXPLICIT_OPEN_SIMULATOR=2 travis_retry fastlane pull_request
else 
	echo 'Not running any tasks, since this request seems to be not for the master branch neither a pull request'
fi