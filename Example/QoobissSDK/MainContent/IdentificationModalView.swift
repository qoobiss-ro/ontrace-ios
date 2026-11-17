import SwiftUI
import OntraceSDK

struct IdentificationModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var navigateToDetail: Bool
    @Binding var requestId: String
    
    var body: some View {
        VStack {
            AnyView(
                IdentificationFlow.startFlowNative(
                    clientId: Secrets.clientId,
                    clientSecret: Secrets.clientSecret,
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
