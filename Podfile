# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FirebasePrep' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FirebasePrep
  # pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'

  target 'FirebasePrepTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FirebasePrepUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings[‘PROVISIONING_PROFILE_SPECIFIER’] = ''
      end
  end

end
