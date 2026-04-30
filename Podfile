platform :ios, '16.0'

target 'EQBoostAI' do
  use_frameworks!

  pod 'SnapKit', '~> 5.6'
  pod 'DGCharts', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end