#
# Be sure to run `pod lib lint DJBExtensionKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DJBExtensionKit'
  s.version          = '0.4.5'
  s.summary          = 'Collection of personal extension I like to use.'

  s.description      = <<-DESC
Just a collection of extensions I like to use. This is just so I no longer have to copy everything over from project to project. Please do not actually use me.
                       DESC

  s.homepage         = 'https://github.com/DouweBos/DJBExtensionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DouweBos' => 'douwe@douwebos.nl' }
  s.source           = { :git => 'https://github.com/DouweBos/DJBExtensionKit.git', :tag => s.version.to_s }

  s.platform     = :ios, :tvos
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.swift_version = '5.1'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'DJBExtensionKit/Classes/Core/**/*'
  end

  s.subspec 'RxSwift' do |ss|
    ss.source_files = 'DJBExtensionKit/Classes/RxSwift/**/*'

    ss.dependency 'RxSwift', '~> 5'
    ss.dependency 'RxSwift', '~> 5'
    ss.dependency 'RxSwiftExt', '~> 5'
    ss.dependency 'RxCocoa', '~> 5'
  end
  
  s.subspec 'Kingfisher' do |ss|
    ss.source_files = 'DJBExtensionKit/Classes/Kingfisher/**/*'
    
    ss.dependency 'Kingfisher'
  end
end
