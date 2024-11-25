import SwiftUI
import QoobissCoreIdentificationSDK

struct ContentView: View {
    var body: some View {
        AnyView(IdentificationFlow.startFlowNative(apiKey: "API_KEY",
                                                   onMessage: { message in
            print("message is \(message)")
        }, onCompleteResult: { result in
            print("result is \(result)")
        }))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .foregroundColor(.white)
        .ignoresSafeArea()
        .onAppear {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}
