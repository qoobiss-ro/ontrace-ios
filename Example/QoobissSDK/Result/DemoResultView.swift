import SwiftUI
import Combine

struct DemoResultView<VM: ResultViewModelType>: View {
    
    @StateObject var resultViewModel: VM
    
    // MARK: Init
    
    init(resultViewModel: VM) {
        _resultViewModel = StateObject(wrappedValue: resultViewModel)
    }
    
    var body: some View {
        VStack (spacing: .zero) {
            if resultViewModel.validationResponse == nil {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            }
            if resultViewModel.validationResponse != nil,
               let status = resultViewModel.validationResponse?.validationData.status,
               status == "Incomplete" {
                makeIncompleteSection()
            }
            if resultViewModel.validationResponse != nil,
               let status = resultViewModel.validationResponse?.validationData.status,
               status == "Running" || status.lowercased() == "NotStarted".lowercased() {
                Spacer()
                Text("Running....")
                Spacer()
            }
            if let resp = resultViewModel.validationResponse {
                Text("Identity Validation Status is \(resp.validationData.identityValidationStatus ?? "Processing")")
                ResultView(validationData: resp.validationData)
            }
            if let validationResponse = resultViewModel.validationResponse,
               let person = validationResponse.validationData.person {
                makeIDSnapshotSection(person, validationResponse)
            }
        }
        .onAppear() {
            resultViewModel.startTimer()
        }
        .padding(.top, 24)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    fileprivate func formatImage(image: UIImage?) -> some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(7)
            .padding(5)
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
            .padding(.bottom, 24)
    }
    
    @ViewBuilder
    fileprivate func makeIDSnapshotSection(_ person: Person,
                                           _ validationResponse: ValidationResponse) -> some View {
         ScrollView {
            PersonDetailView(person: person).padding(.bottom, 24)
            if let idSnapshot = validationResponse.validationData.idSnapshot {
                if let sanitizedBase64 = idSnapshot.removeBase64Prefix(),
                   let data = Data(base64Encoded: sanitizedBase64) {
                    let image = UIImage(data: data)
                    formatImage(image: image)
                } else {
                    Text("There is no ID Front Snapshot")
                }
            }
            if let faceSnapshot = validationResponse.validationData.faceSnapshot,
               let sanitizedBase64 = faceSnapshot.removeBase64Prefix(),
               let data = Data(base64Encoded: sanitizedBase64) {
                let image = UIImage(data: data)
                formatImage(image: image)
            } else {
                Text("There is no Face Snapshot")
            }
            if let idBackSnapshot = validationResponse.validationData.idBackSnapshot,
               let sanitizedBase64 = idBackSnapshot.removeBase64Prefix(),
               let data = Data(base64Encoded: sanitizedBase64) {
                let image = UIImage(data: data)
                formatImage(image: image)
            } else {
                Text("There is no ID Back Snapshot")
            }
        }
    }
    
    @ViewBuilder
    fileprivate func makeIncompleteSection() -> some View {
        VStack(spacing: 8) {
            Text("Status for current identity is: Incomplete")
            
            Text("OrderID: ")
            Text(resultViewModel.validationResponse?.validationData.orderID ?? "missing")
                .padding()
            
            Button(action: {
                UIPasteboard.general.string = resultViewModel.validationResponse?.validationData.orderID ?? "missing"
            }) {
                Image(systemName: "doc.on.clipboard")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .padding()
            
            if let errors = resultViewModel.validationResponse?.validationData.errors,
               !errors.isEmpty {
                Text("\(String(describing: resultViewModel.validationResponse?.validationData.errors))")
            }
        }
        .padding(.all, 24)
    }
}
