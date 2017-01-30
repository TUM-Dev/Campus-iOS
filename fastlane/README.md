fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### integration
```
fastlane integration
```
Performs the integration into master. It Builds and tests, performs a static code analysis and updates the SonarQube dashboard.
### pull_request
```
fastlane pull_request
```
Performs tests and a static code analysis on the PR. Found issues are commented on the PR.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
