// swift-tools-version: 5.9
import PackageDescription

// Local binary package for the frameworks in Framework/.
// CocoaPods Trunk stays the version source of truth; the git tag matches OntraceSDK.podspec.
// The binaries themselves require iOS 15.6. Swift tools 5.9 can only declare iOS 15.
let package = Package(
    name: "OntraceSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "OntraceSDK", targets: ["OntraceSDK"]),
    ],
    targets: [
        .target(
            name: "OntraceSDK",
            dependencies: [
                "QoobissCoreIdentificationSDK",
                "NFCSDK",
                "QoobissFaceCamera",
                "Lottie",
                "OpenSSL",
                "OpenTelemetryApi",
                "OpenTelemetrySdk",
                "OpenTelemetryProtocolExporterCommon",
                "OpenTelemetryProtocolExporterHttp",
                "SwiftProtobuf",
                "CaptureCommon",
                "DocSdkMobile",
                "IADCommon",
                "IDLiveDocCaptureIAD",
                "IDLiveFaceCamera",
                "IDLiveFaceDetection",
                "IDLiveFaceIAD",
            ],
            path: "Sources/OntraceSDK"
        ),
        .binaryTarget(name: "QoobissCoreIdentificationSDK", path: "Framework/QoobissCoreIdentificationSDK.xcframework"),
        .binaryTarget(name: "NFCSDK", path: "Framework/NFCSDK.xcframework"),
        .binaryTarget(name: "QoobissFaceCamera", path: "Framework/QoobissFaceCamera.xcframework"),
        .binaryTarget(name: "Lottie", path: "Framework/Lottie.xcframework"),
        .binaryTarget(name: "OpenSSL", path: "Framework/OpenSSL.xcframework"),
        .binaryTarget(name: "OpenTelemetryApi", path: "Framework/OpenTelemetryApi.xcframework"),
        .binaryTarget(name: "OpenTelemetrySdk", path: "Framework/OpenTelemetrySdk.xcframework"),
        .binaryTarget(name: "OpenTelemetryProtocolExporterCommon", path: "Framework/OpenTelemetryProtocolExporterCommon.xcframework"),
        .binaryTarget(name: "OpenTelemetryProtocolExporterHttp", path: "Framework/OpenTelemetryProtocolExporterHttp.xcframework"),
        .binaryTarget(name: "SwiftProtobuf", path: "Framework/SwiftProtobuf.xcframework"),
        .binaryTarget(name: "CaptureCommon", path: "Framework/CaptureCommon.xcframework"),
        .binaryTarget(name: "DocSdkMobile", path: "Framework/DocSdkMobile.xcframework"),
        .binaryTarget(name: "IADCommon", path: "Framework/IADCommon.xcframework"),
        .binaryTarget(name: "IDLiveDocCaptureIAD", path: "Framework/IDLiveDocCaptureIAD.xcframework"),
        .binaryTarget(name: "IDLiveFaceCamera", path: "Framework/IDLiveFaceCamera.xcframework"),
        .binaryTarget(name: "IDLiveFaceDetection", path: "Framework/IDLiveFaceDetection.xcframework"),
        .binaryTarget(name: "IDLiveFaceIAD", path: "Framework/IDLiveFaceIAD.xcframework"),
    ]
)
