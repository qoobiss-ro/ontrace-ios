Pod::Spec.new do |spec|
    spec.name         = 'OntraceSDK'
    spec.version      = '0.0.30'
    spec.summary      = 'An SDK to identify a user based on their ID and face scan'
    spec.description  = 'An SDK to identify a user based on their ID and face scan using Qoobiss'
    spec.homepage     = 'https://github.com/qoobiss-ro/ontrace-ios.git'
    spec.license      = { :type => 'MIT', :file => 'LICENSE' }
    spec.author       = { 'Qoobiss' => 'vlad.buhaescu@qoobiss.com' }
    spec.platform     = :ios, '15.6'
    spec.source       = { :git => 'https://github.com/qoobiss-ro/ontrace-ios.git', :tag => spec.version }
    # All dynamic deps of QoobissCoreIdentificationSDK must be the binaries produced
    # by framework_script.sh in the same build — do not use OpenTelemetry pod deps
    # (Swift ABI mismatch / dyld Symbol not found).
    spec.vendored_frameworks = [
      '**/Framework/QoobissCoreIdentificationSDK.xcframework',
      '**/Framework/NFCSDK.xcframework',
      '**/Framework/Lottie.xcframework',
      '**/Framework/OpenSSL.xcframework',
      '**/Framework/OpenTelemetryApi.xcframework',
      '**/Framework/OpenTelemetrySdk.xcframework',
      '**/Framework/OpenTelemetryProtocolExporterCommon.xcframework',
      '**/Framework/OpenTelemetryProtocolExporterHttp.xcframework',
      '**/Framework/SwiftProtobuf.xcframework',
    ]
    spec.swift_versions = '6.0.3'
    spec.resources = ['**/Framework/QoobissCoreIdentificationSDK.xcframework/ios-arm64/QoobissCoreIdentificationSDK.framework/*.{json, car, ttf, md, mlmodelc}' ]
    spec.frameworks = 'UIKit'
    spec.pod_target_xcconfig = {
        'SWIFT_OPTIMIZATION_LEVEL' => '-Owholemodule',
    }
end
