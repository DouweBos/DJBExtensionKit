#
# Be sure to run `pod lib lint DJBExtensionKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DJBExtensionKit'
  s.version          = '0.2.1'
  s.summary          = 'Collection of personal extension I like to use.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Just a collection of extensions I like to use. This is just so I no longer have to copy everything over from project to project. Please do not actually use me.
                       DESC

  s.homepage         = 'https://github.com/DouweBos/DJBExtensionKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DouweBos' => 'douwe@douwebos.nl' }
  s.source           = { :git => 'https://github.com/DouweBos/DJBExtensionKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'DJBExtensionKit/Classes/**/*'
  s.swift_version = '5.1'
  
  # s.resource_bundles = {
  #   'DJBExtensionKit' => ['DJBExtensionKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.subspec 'RxSwift' do |rxswift|
    rxswift.xcconfig =
    { 'OTHER_SWIFT_FLAGS' => '$(inherited) -DDJB_EXT_OFFER_RXSWIFT' }
    rxswift.dependency 'RxSwift', '~> 5'
  end
  
  s.subspec 'Kingfisher' do |kingfisher|
    kingfisher.xcconfig  =
    { 'OTHER_SWIFT_FLAGS' => '$(inherited) -DDJB_EXT_OFFER_KINGFISHER' }
    kingfisher.dependency 'Kingfisher'
  end
end
