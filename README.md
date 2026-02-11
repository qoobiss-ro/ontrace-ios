# Introduction 

Ontrace SDK provides a set of screens and functionalities that enable applications to implement a user identity verification flow for Romanian identity cards. It comes with a predefined set of steps to guide the user through validating his identity.

## Installation

### Initialize the Library: In order to be able to use the library our sales team will provide an API KEY. 

### CocoaPods

To integrate `OntraceSDK` into your project, add the following to your `Podfile`:

```ruby

platform :ios, '15.0'

target 'YourMainTarget' do
  
  use_frameworks!

  pod 'OntraceSDK', '0.0.16'
end

```
   
## Requirements

iOS 15.6+
Swift 5.10+
Xcode 16+

## Project setup

Here's a quick example to get started with `OntraceSDK`:

### Disable User Script Sandboxing

To disable **User Script Sandboxing** for your project, follow these steps:

1. Open your **Xcode project**.
2. Navigate to the **Build Settings** section for your target.
3. Search for `User Script Sandboxing` and from the dropdown select `NO` .

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
import QoobissCoreIdentificationSDK

struct ContentView: View {
    var body: some View {
        VStack {
            AnyView(IdentificationFlow.startFlowNative(
                apiKey: "API_KEY",
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

The response is of type OntraceCompletionResult. This response contains a requestId and using this API.

Example:
https://qoobiss.com/validation/identity/shortresult?orderId=`requestId`

###Decrypting the short result in Swift

The short result endpoint returns an encrypted payload.
The HTTP body is a Base64‑encoded AES‑CBC ciphertext, encrypted with:
Algorithm: AES‑CBC with PKCS#7 padding
IV: 16 zero bytes (0x00…00)
Key: raw bytes of the decryption key string provided to you together with your API key
You must decrypt this value on the client using the corresponding decryption key.

```swift
var request = URLRequest(url: URL(string: "https://apiontrace.id-kyc.com/validation/identity/resultlight?orderId="YOUR_SESSION_ORDER_ID"")!,timeoutInterval: Double.infinity)
request.addValue("YOUR_API_KEY", forHTTPHeaderField: "ApiKey")

request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}

task.resume()
```
