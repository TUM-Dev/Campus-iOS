**Everyone is able to contribute, we're happy to have you here!**

Beside code contributions, you can also test our app and use the GitHub issue tracker to report bugs.

### Workflow, DO's and DON'Ts:
- Master branch is protected, create PR's for your changes
- Branch naming convention: `max/42-some-description`, where 42 is the issue number this branch is refering to
- Create a separate PR for every feature/fix you're working on
- Don't do any changes unrelated to your feature/fix to keep PR's easy to review
- Close related issues automatically via the commit message of your first commit (eg. "Closes #42"). [Reference](https://help.github.com/articles/closing-issues-via-commit-messages/)
- If the changes are a bigger feature, add it to the [release notes](https://github.com/TCA-Team/iOS/blob/master/fastlane/metadata/de-DE/release_notes.txt), located in `fastlane/metadata`
- Use the **Squash & Merge** button, to combine all commits into a single one to keep the history clean
- Delete the branch after merging

If you are part of the official [GitHub iOS team](https://github.com/orgs/TCA-Team/teams/ios):
- **Don't create PR's from your fork**, but rather directly create branches in this repository. The reason is, that our CI can do more stuff, when the PR is coming from an "inhouse"-branch

### Continuous Integration
- We use Travis to perform builds on new PR's
- We have SonarQube to check the code quality at https://sonarqube.com/dashboard?id=de.tum.in.www.Tum-Campus-App
- If a PR is coming from a branch from this repository (and not a fork), our @TCA-Bot will review the changes automatically
- Use `[ci skip]` in the commit message if you know there is no need to run a build on Travis
