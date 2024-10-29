import SwiftUI
import QoobissCoreIdentificationSDK

public class ReplaceMe {
    
    public init() {
        
    }
    
    public func aaaa() -> any View {
        IdentificationFlow.startFlow(apiKey: "1FCBAD86-98AD-4C75-9D36-DE0C383EB9C4")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
    }
}
