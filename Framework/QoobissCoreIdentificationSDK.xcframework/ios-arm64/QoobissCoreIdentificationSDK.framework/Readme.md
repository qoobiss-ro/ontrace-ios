

1. Code Cleanup https://github.com/peripheryapp/periphery
   Command periphery scan --setup --retain-public --retain-assign-only-properties
2. Unify Camera for both id and face scan

## Version source of truth (full SDK)

**Qoobiss eID Reader** (NFC light mini-app) is a **separate App Store product** from this CocoaPods library — different version line, TestFlight/Firebase distribute, not `pod trunk push`.

**Published CocoaPods** is the source of truth for the Ontrace SDK version:

- Remote: [CocoaPods Trunk `OntraceSDK`](https://trunk.cocoapods.org/api/v1/pods/OntraceSDK)
- Local mirrors (must match after publish): `Qoobiss_iOS_SDK/OntraceSDK.podspec` `spec.version` and `release/version.properties` → `sdkVersion`

Before cutting a release, bump from Trunk:

```bash
./release/00_bump_sdk_from_cocoapods.sh
```

Do not treat `internal_release/*` branch names as the published SDK version. See [`docs/release-versioning.md`](../docs/release-versioning.md) and [`release/README.md`](../release/README.md).

## How to publish a new version of the library

0. Bump version from CocoaPods Trunk (`./release/00_bump_sdk_from_cocoapods.sh`), fill `CHANGELOG.md` `[Unreleased]`, run release branch/tag/wiki scripts for `--product sdk` as in `release/README.md`.
1. After Podfile changes: `pod install` in this repo (enables `BUILD_LIBRARY_FOR_DISTRIBUTION` on OpenTelemetry + SwiftProtobuf).
2. Run `QoobissCoreIdentificationSDK/framework_script.sh` — builds and copies into `Qoobiss_iOS_SDK/Framework/`:
   - `QoobissCoreIdentificationSDK.xcframework`, `NFCSDK.xcframework`
   - `OpenTelemetryApi` / `OpenTelemetrySdk` / `OpenTelemetryProtocolExporterCommon` / `OpenTelemetryProtocolExporterHttp`
   - `SwiftProtobuf.xcframework`  
   (`Lottie` + `OpenSSL` stay as existing vendor binaries.)  
   Do **not** declare OpenTelemetry as CocoaPods `spec.dependency` — ship the matching binaries only (avoids dyld Symbol not found).
3. Ensure `OntraceSDK.podspec` `vendored_frameworks` lists all of the above and version matches the release (step 0).
4. In `Qoobiss_iOS_SDK/Example`: `pod install`, clean rebuild, smoke-test launch.
5. Validate: `pod lib lint --no-clean --verbose --allow-warnings`
6. `pod trunk push OntraceSDK.podspec --allow-warnings` — after this, Trunk remains the SoT
7. Validate Flutter plugin: `pod lib lint ontrace_flutter_plugin.podspec --allow-warnings --no-clean`  
   at `/Users/vladbuhaescu/Documents/Developement/ontrace_flutter_plugin/FlutterPlugin/ontrace_flutter_plugin`
