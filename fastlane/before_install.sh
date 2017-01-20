#!/bin/sh

# sudo gem install -n /usr/local/bin fastlane  -v 2.8.0
sudo gem install fastlane  -v 2.9.0
sudo gem install slather  -v 2.3.0

brew install swiftlint
brew install sonar-scanner

# hab auch xcov lokal installiert mit gem install xcov (ohne -n ...)