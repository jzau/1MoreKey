# Uncomment the next line to define a global platform for your project
platform :osx, '10.10'

target '1MoreKey' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'MASPreferences', :git => 'https://github.com/shpakovski/MASPreferences.git'
  pod 'Sparkle'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'ReactiveCocoa'
  
  post_install do |installer|
	installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end
  
end
