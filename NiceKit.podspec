Pod::Spec.new do |s|
  s.name             = "NiceKit"
  s.version          = "0.1.0"
  s.summary          = "UI library to allow building iOS & OSX apps with one codebase"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "description here"

  s.homepage         = "https://github.com/vojto/NiceKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Vojtech Rinik" => "vojto@rinik.net" }
  s.source           = { :git => "https://github.com/vojto/NiceKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_vojto'

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "2.0"

  # s.requires_arc = true

  s.watchos.source_files = ['Pod/Classes/Shared+Watch/**/*']
  s.ios.source_files = ['Pod/Classes/Shared+Watch/**/*', 'Pod/Classes/Shared/**/*', 'Pod/Classes/iOS/**/*']
  s.osx.source_files = ['Pod/Classes/Shared+Watch/**/*', 'Pod/Classes/Shared/**/*', 'Pod/Classes/Mac/**/*']

  # s.resource_bundles = {
  #   'NiceKit' => ['Pod/Assets/*.png']
  # }


  s.osx.dependency 'Cartography'
  s.osx.dependency 'SwiftColors'
  s.osx.dependency 'ITSwitch'
  s.osx.dependency 'Changeset'

  s.ios.dependency 'Cartography'
  s.ios.dependency 'SwiftColors'
  s.ios.dependency 'EZAlertController'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
