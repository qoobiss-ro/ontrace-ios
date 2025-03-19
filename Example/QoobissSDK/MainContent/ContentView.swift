import SwiftUI

struct ContentView: View {
    
    @State private var isModalPresented = false
    @State private var navigateToDetail = false
    @State private var requestId = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Start Identification Flow") {
                    isModalPresented = true
                }
                NavigationLink(destination: DemoResultView(resultViewModel: ResultViewModel(repository: ResultRepository(), requestId: requestId)),
                               isActive: $navigateToDetail) {
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $isModalPresented) {
            IdentificationModalView(navigateToDetail: $navigateToDetail, requestId: $requestId)
        }
        .onAppear {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}

