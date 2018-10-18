#!/bin/sh
sudo gem install slather

brew update # can be removed if travis updated their machine image to include brew list with new sonar-scanner binaries
brew install swiftlint
brew install sonar-scanner
