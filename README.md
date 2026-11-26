# Introduction 

Ontrace SDK provides a set of screens and functionalities that enable applications to implement a user identity verification flow for Romanian identity cards. It comes with a predefined set of steps to guide the user through validating his identity.

## Installation

### Initialize the Library: In order to be able to use the library our sales team will provide an API KEY. 

### Swift Package Manager

The published version is the git tag `0.1.1`. The release branch `releases/release-0.1.1` is not the package version.

In Xcode, choose File → Add Package Dependencies and enter:

`https://github.com/qoobiss-ro/ontrace-ios.git`

Select the `OntraceSDK` product. Or add this to your `Package.swift`:

```swift
.package(url: "https://github.com/qoobiss-ro/ontrace-ios.git", from: "0.1.1")
```

Then depend on the `OntraceSDK` product and `import OntraceSDK`.
   
## Requirements

iOS 15.6+
Swift 5.10+
Xcode 16+

## Project setup

Here's a quick example to get started with `OntraceSDK`:

### Add Camera Permission key in the plist file

Here’s a step-by-step breakdown:
1.	In Xcode, open the Info.plist file of your app.
2.	Right-click and choose Add Row.
3.	From the dropdown menu, select NSCameraUsageDescription.
4.	In the Value column, type a description of why you need camera access (e.g., “This app requires access to the camera to take photos and scan documents.”).

<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera for scanning documents.</string> 

### NFC setup (optional, for identity document chip reading)

To support reading identity document chips via NFC (e.g. Romanian eID), configure the following.

**1. NFC usage description (Info.plist)**

Add a usage description so the system can show a prompt when starting an NFC session:

```xml
<key>NFCReaderUsageDescription</key>
<string>We need to scan your ID document chip to verify your identity.</string>
```

**2. NFC capability in Xcode**

1. Open your project in Xcode and select your app target.
2. Go to **Signing & Capabilities**.
3. Click **+ Capability** and add **Near Field Communication Tag Reading**.
4. Xcode will add the required entries to your entitlements file.

**3. ISO7816 select identifiers (for eID / passport reading)**

Reading identity document chips requires the ISO7816 entitlement with the application identifiers (AIDs) used by the chip. Add this to your **entitlements file** (e.g. `YourApp.entitlements`), **only if your App ID has this capability enabled** by Apple:

```xml
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
    <string>A0000002472001</string>
    <string>00000000000000</string>
    <string>A000000077030C60000000FE00000500</string>
</array>
```

- If you see *"com.apple.developer.nfc.readersession.iso7816.select-identifiers not found and could not be included in profile"*, your current App ID does not have this entitlement. Remove the key and array above from the entitlements file to fix signing. NFC chip reading will not work until Apple enables the ISO7816 / identity document capability for your App ID (contact your Apple account representative or follow your partner program instructions).
- NFC chip reading works only on **physical devices** with NFC; it is not available in the simulator.

### Code Example 

```swift
import SwiftUI
import OntraceSDK

struct ContentView: View {
    var body: some View {
        VStack {
            AnyView(IdentificationFlow.startFlowNative(
                clientId: "CLIENT_ID",
                clientSecret: "CLIENT_SECRET",
                onMessage: { message in
                    print("message is \(message)") },
                onCompleteResult: { result in
                    print("result is \(result)")
                    print("requestId is \(result.requestId)")
                })
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
}
```

### Running on devices and simulators

The SDK is made to build together with the client app for both physical devices and simulators but the user is able to complete the flow only on a real device due to hardware limitations for camera usage. NFC chip reading (when configured) also requires a physical device with NFC; it is not available in the simulator. 
### Results

The `onMessage` callback will be called every time there is a new state to transition to represented by a screen.

There are two scenarios for completing the flow and getting a callback from `onCompleteResult` :

Scenario 1: The user cancels the process on the landing page or the second page (Terms and Conditions).
Scenario 2: The user successfully completes the entire flow.

The order ID is visible to the integrating app. `onCompleteResult` receives an `OntraceCompletionResult`, and its public `requestId` is that order ID. Use `requestId` as `orderId` on the token and result calls below.

Fetching the result takes two calls. Replace `YOUR_ORDER_ID`, `YOUR_CLIENT_ID`, and `YOUR_CLIENT_SECRET` with the values for the session. The first response includes `access_token`. Send that value as `YOUR_ACCESS_TOKEN` on the second call.

The example app does this in `ResultRepository`, using `Secrets.clientId` and `Secrets.clientSecret`.

**1. Request an access token**

```bash
curl --location 'https://eu-apistg-ontrace.qoobiss.com/api/v2/token/client' \
--header 'Content-Type: application/json' \
--data '{
    "clientId": "YOUR_CLIENT_ID",
    "clientSecret": "YOUR_CLIENT_SECRET",
    "orderId": "YOUR_ORDER_ID"
}'
```

**2. Fetch the result**

```bash
curl --location 'https://eu-apistg-ontrace.qoobiss.com/api/v2/validation/identity/result?orderId=YOUR_ORDER_ID' \
--header 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### Decrypting the result

The `identity/result` body is Base64 text. Read it as text, then:

1. Base64-decode the body.
2. The first 16 bytes are the IV. The rest is the ciphertext.
3. The key is the decryption key string as UTF-8 bytes. It must be exactly 32 bytes (AES-256). There is no hash or key derivation.
4. Decrypt with AES-256-CBC and remove the PKCS#7 padding.
5. The plaintext is UTF-8 JSON (`ValidationResponse`). It may start with a byte-order mark; take the object from the first `{`.

Decrypt it with `DecryptResponseUseCase`, then take the JSON object out of the plaintext:

```swift
let decrypted = DecryptResponseUseCase().call(inputText: responseBody)
let json = decrypted?.extractJSONPart()
```
