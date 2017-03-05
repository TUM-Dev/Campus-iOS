#!/bin/sh

sudo gem install fastlane  -v 2.19.1
sudo gem install slather  -v 2.3.0
gem cleanup

brew install swiftlint
brew install sonar-scanner