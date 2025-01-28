# Introduction 

Ontrace SDK provides a set of screens and functionalities that enable applications to implement user identity verification flow for the romanian identity cards. It comes with a predefined set of steps that will guide the user to validate his id.

## Installation

### Initialize the Library: In order to be able to use the library our sales team will provide an API KEY 

### CocoaPods

To integrate `OntraceSDK` into your project, add the following to your `Podfile`:

```ruby

pod 'OntraceSDK', '~> 0.0.10'

## Requirements

iOS 13.0+
Swift 6.0+
Xcode 16+ (because of Swift minimum version)

## Quick Start
Here's a quick example to get started with `OntraceSDK`:

```swift
import OntraceSDK

IdentificationFlow.startFlowNative(
    apiKey: "API_KEY",
    onMessage: { message in
        print("message is \(message)")
    }, onCompleteResult: { result in
        print("result is \(result)")
    })

The `onMessage` callback will be called every time there is a new state to transition to.


There are two scenarios for completing the flow and getting a callback from `onCompleteResult` :

1. User cancels on the landing page or the second page, Terms and Conditions
2. User gets through the flow

The response is of type OntraceCompletionResult. This response contains a requestId and using this API

Example:
https://qoobiss.com/validation/identity/shortresult?orderId=`requestId`

This will return an ecrypted result.

