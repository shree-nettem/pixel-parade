# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def common_pods
  pod 'Moya'
  pod 'R.swift'
  pod 'Sync'
  pod 'DownloadButton'
end

target 'Pixel-parade' do
    use_frameworks!
    inhibit_all_warnings!
    
    common_pods
    pod 'Firebase/Analytics'
    pod 'MBProgressHUD'
    pod 'SwiftyStoreKit'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SDWebImage'
    pod 'SDWebImage/GIF'
    pod 'SnapKit'
    
    target 'iMessageExtension' do
        use_frameworks!
        
        common_pods
    end
    
end

target 'Pixel ParadeUITests' do
  pod 'SwiftMonkey', '~> 2.1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete('IPHONEOS_DEPLOYMENT_TARGET')
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end

