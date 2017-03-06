if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then 
	if [ "$TRAVIS_SECURE_ENV_VARS" == "true" ]; then
		FASTLANE_EXPLICIT_OPEN_SIMULATOR=2 fastlane pull_request_from_upstream;
	else
		FASTLANE_EXPLICIT_OPEN_SIMULATOR=2 fastlane pull_request_from_fork;
	fi
else
	FASTLANE_EXPLICIT_OPEN_SIMULATOR=2 fastlane integration; 
fi