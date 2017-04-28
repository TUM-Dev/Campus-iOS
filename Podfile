workspace 'Campus App'
source 'https://github.com/CocoaPods/Specs.git'
project 'TUM Campus App.xcodeproj'
platform :ios, '10.2'
use_frameworks!

target 'Campus' do
    pod 'Sweeft'
	pod 'Alamofire', '~> 4.2'
	pod 'MCSwipeTableViewCell', '~> 2.1.4'
	pod 'SwiftyJSON', '~> 3.1.4'
	pod 'AYSlidingPickerView'
	pod 'PZPullToRefresh', :git => 'https://github.com/mathiasquintero/PZPullToRefresh.git'
	pod 'ASWeekSelectorView', '~> 1.0'
	pod 'CalendarLib', '~> 2.0'
	pod 'SWXMLHash', '~> 3.0.3'
	pod 'TKSubmitTransition', :git => 'https://github.com/jvitor/TKSubmitTransition.git'
    pod 'FoldingCell', '~> 2.0.3'
    pod 'Kanna', '~> 2.1.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0.2'
        end
    end
end
