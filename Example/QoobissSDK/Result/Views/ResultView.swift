import SwiftUI

struct ResultView: View {
    
    let validationData: ValidationData
    
    var body: some View {
        VStack(spacing: 24) {
            makeInfoRow(boldText: "IDCheckResult:", infoText: validationData.idCheckResult ?? "")
            makeInfoRow(boldText: "Face Liveness:", infoText: validationData.faceLiveness ?? "")
            makeInfoRow(boldText: "DocumentLiveness:", infoText: validationData.documentLiveness ?? "")
        }
        .padding(.all, 24)
    }
    
    @ViewBuilder
    func makeInfoRow(boldText: String, infoText: String) -> some View {
        HStack {
            Text(boldText)
                .bold()
            Text(infoText)
        }
    }
}
