platform :ios, '7.0'
pod 'DTCoreText', '~> 1.6.11'
pod 'AFNetworking', "~> 2.0"
pod 'CocoaLumberjack', '~> 1.7.0'
pod 'VKFoundation', :git => "https://github.com/viki-org/VKFoundation.git"
pod 'CocoaHTTPServer'



# Remove 64-bit build architecture from Pods targets
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |configuration|
      target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_32_BIT)'
    end
  end
end

pod 'JSONKit',       '~> 1.4'
pod 'SDWebImage'
pod 'SVProgressHUD'
pod 'SVPullToRefresh'
pod 'Reachability'
pod 'TMTumblrSDK'
