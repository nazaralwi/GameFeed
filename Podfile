# Uncomment the next line to define a global platform for your project
# or platform :osx, '10.10' if your target is OS X.
platform :ios, '15.0' 
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end

pod 'Alamofire'
pod 'Swinject'
pod 'SwinjectStoryboard', :git => 'https://github.com/Swinject/SwinjectStoryboard.git', :branch => 'master'

target 'GameFeed' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GameFeed

  target 'GameFeedTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
