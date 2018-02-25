## [1.3.1] - Unreleased
### Added
- Added User Profile Picture to "More" Button.

### Changed
- Current User Information and Profile Image is now being cached as well.
- Pinning Campus App API Root CA Certificate for improved security.
- TUM Online Token Name now includes device nickname for identification convenience.
- Updated User-Agent Header now displays the App Version and Build Number

### Fixed
- Fixed displaying no user information for the current user in case the name is shared by multiple people.


## [1.3.0] - 2018-01-24
### Added
- Added 💸 Ca$hing 💸 for better performance
- Added Headers to Search to mark the type of results
- Added support to search for TUM.sexy links

### Changed
- Seach bar is now in the Card View
- Links now open within the App to avoid annoying app switches
- If the app doesn't have permissions to access your location it will now assume you're at the campus.
- Pulling to refresh on the Card View will now skip all caches.
- Calendar now displays canceled events grayed out.

### Fixed
- Fixed memory leaks caused by memory cycles.
- Fixed Cafeteria Card. It only shows a Cafeteria that has something on the menu that day
- Fixed Calendar View not changing the day after a few swipes.
- Fixed More View displaying the wrong name.
- Fixed TU Film Links

### Removed
- Removed Tab Bar in favor of a Bar Button at the Top


## [1.2.0] - 2017-10-20
### Added
- Added a brand new sleek design to the Cards View
- Added possibility to refresh the Calendar
- Added a confirm button to the login screen to safeguard against typo's
- Added locations to the Calendar Events
- Added support for keeping track of your library account

### Fixed
- Fixed issues with losing login progress after killing the app
- Fixed bug with pickers in Details views not hiding when leaving them
- Credentials are now stored in the Keychain

## [1.1.0] - 2017-07-21
### Added
- Added Card Labels
- Added Study Room Support
- Added Not Implemented Alert for features not implemented

### Changed
- App can now also be used without an LRZ-ID

### Fixed
- Fixed Shadow errors in Cards
- Fixed TU Film not showing the picture
- Fixed errors in parsing Cafeteria Menu Titles
- Fixed issue with spinner in Card View without cards

## [1.0.0] - 2017-03-31
### Added
- Initial Release
