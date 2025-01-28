Pod::Spec.new do |spec|
    spec.name         = 'OntraceSDK'
    spec.version      = '0.0.10'
    spec.summary      = 'An SDK to identify a user basedon their ID and face scan'
    spec.description  = 'An SDK to identify a user basedon their ID and face scan using Qoobiss'
    spec.homepage     = 'https://github.com/qoobiss-ro/ontrace-ios.git'

    spec.license      = { :type => 'MIT', :file => 'LICENSE' }
    spec.author       = { 'Qoobiss' => 'vlad.buhaescu@qoobiss.com' }
    spec.platform     = :ios, '13.0'
    spec.source       = { :git => 'https://github.com/qoobiss-ro/ontrace-ios.git', :tag => spec.version }
    spec.vendored_frameworks = '**/Framework/QoobissCoreIdentificationSDK.xcframework'
    spec.resources = ['**/Framework/QoobissCoreIdentificationSDK.xcframework/ios-arm64/QoobissCoreIdentificationSDK.framework/*.{json, car, ttf, md, mlmodelc}' ]
    spec.dependency 'lottie-ios', '~> 4.5.0'
    
    spec.frameworks = 'UIKit'
    
    spec.pod_target_xcconfig = {
        'SWIFT_OPTIMIZATION_LEVEL' => '-Onone',
    }
end

