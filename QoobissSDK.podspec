#
# Be sure to run `pod lib lint ApplesSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QoobissSDK'
  s.version          = '0.0.1'
  s.summary          = 'QoobissSDK is a framework that helps you KYC customers'
  s.description      = 'QoobissSDK is a framework that helps you KYC customers using hid level APIs'
  s.swift_versions          = '5.10'
  s.ios.deployment_target   = '13.0'
  s.homepage         = 'https://github.com/vlad-buhaescu-qoob/apples'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '144892271' => 'vlad.buhaescu@qoobiss.com' }
  s.source           = { :git => 'https://github.com/vlad-buhaescu-qoob/apples.git', :tag => s.version.to_s }
  s.source_files = '**/Classes/**'
  s.exclude_files = 'Qoobiss_iOS_SDK/**/*.DS_Store', 'Qoobiss_iOS_SDK/**/.git', 'Qoobiss_iOS_SDK/**/hidden/*.swift'
  s.vendored_frameworks = 'Framework/QoobissCoreIdentificationSDK.xcframework'
end
