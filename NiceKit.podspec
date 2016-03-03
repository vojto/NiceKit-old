#
# Be sure to run `pod lib lint NiceKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NiceKit"
  s.version          = "0.1.0"
  s.summary          = "A short description of NiceKit."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/NiceKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Vojtech Rinik" => "vojto@rinik.net" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/NiceKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.11"

  s.requires_arc = true

  s.ios.source_files = ['Pod/Classes/Shared/**/*', 'Pod/Classes/iOS/**/*']
  s.osx.source_files = ['Pod/Classes/Shared/**/*', 'Pod/Classes/Mac/**/*']

  # s.resource_bundles = {
  #   'NiceKit' => ['Pod/Assets/*.png']
  # }

  s.dependency 'Cartography'
  s.dependency 'SwiftColors'

  s.osx.dependency 'ITSwitch'
  s.osx.dependency 'Changeset'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
