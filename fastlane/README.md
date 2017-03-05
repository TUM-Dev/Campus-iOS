fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools/fastlane.zip">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>
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
### test
```
fastlane test
```

### sonar_github_pr_bot
```
fastlane sonar_github_pr_bot
```
Performs a sonar analysis in preview mode and comments on the PR on Github.
### sonar_update_dashboard
```
fastlane sonar_update_dashboard
```
Updates the SonarQube Server dashboard.
### static_analysis
```
fastlane static_analysis
```
Runs test coverage and swiftlint and provides data in a way sonar can use it afterwards.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
