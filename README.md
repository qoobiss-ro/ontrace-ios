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

iOS 13.0+
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

The SDK is made to build together with the client app for both physical devices and simulators but the user is able to complete the flow only on a real device due to hardware limitations for camera usage. 
### Results

The `onMessage` callback will be called every time there is a new state to transition to represented by a screen.

There are two scenarios for completing the flow and getting a callback from `onCompleteResult` :

Scenario 1: The user cancels the process on the landing page or the second page (Terms and Conditions).
Scenario 2: The user successfully completes the entire flow.

The response is of type OntraceCompletionResult. This response contains a requestId and using this API.

Example:
https://qoobiss.com/validation/identity/shortresult?orderId=`requestId`

This will return an encrypted result.

Please make sure you always use the latest version.
