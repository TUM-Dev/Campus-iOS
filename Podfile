workspace 'Campus App'
source 'https://github.com/CocoaPods/Specs.git'
project 'TUM Campus App.xcodeproj'
platform :ios, '10.2'
use_frameworks!

target 'Campus' do
    pod 'Sweeft', :git => 'https://github.com/TG908/Sweeft.git', :tag => '0.15.3'
    pod 'Fuzzi', '~> 0.1.1'
    pod 'AYSlidingPickerView'
    pod 'PZPullToRefresh', :git => 'https://github.com/mathiasquintero/PZPullToRefresh.git'
    pod 'ASWeekSelectorView', '~> 1.0'
    pod 'CalendarLib', '~> 2.0'
    pod 'SWXMLHash', '~> 4.6.0'
    pod 'TKSubmitTransition', :git => 'https://github.com/entotsu/TKSubmitTransition.git', :branch => 'swift4'
    pod 'Kanna', '~> 4.0.0'
    
    target 'TUM Campus AppUITests' do
        inherit! :search_paths
    end
    
    target 'TUM Campus AppUnitTests' do
        inherit! :search_paths
    end
    
end

post_install do |installer|
    
    targets_swift_4 = ['Kanna','TKSubmitTransition','SWXMLHash','CalendarLib','ASWeekSelectorView','PZPullToRefresh','AYSlidingPickerView','Fuzzi']
    
    installer.pods_project.targets.each do |target|
        if targets_swift_4.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
            else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.3'
            end
            target.build_configurations.each do |config|
                if config.name == 'Release'
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
                    else
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
                end
            end
        end
    end
end
