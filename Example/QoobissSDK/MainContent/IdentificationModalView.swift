import SwiftUI
import QoobissCoreIdentificationSDK

struct IdentificationModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var navigateToDetail: Bool
    @Binding var requestId: String
    
    var body: some View {
        VStack {
            AnyView(
                IdentificationFlow.startFlowNative(
                    apiKey: Secrets.apiKey,
                    onMessage: { message in
                        print("received message \(message)")
                    },
                    onCompleteResult: { result in
                        requestId = result.requestId
                        navigateToDetail = true
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .ignoresSafeArea()
        }
    }
}
