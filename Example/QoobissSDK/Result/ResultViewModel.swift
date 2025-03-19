import SwiftUI
import Combine

protocol ResultViewModelType: NSObject, ObservableObject {
    var validationResponse: ValidationResponse? { get set }
    var requestId: String { get set }
    func startTimer()
    func getResult()
}

final class ResultViewModel: NSObject, ResultViewModelType {
    
    // MARK: Public
    
    var requestId: String
    @Published var validationResponse: ValidationResponse?
    
    // MARK: Init
    
    init(repository: ResultRepositoryProtocol, requestId: String) {
        self.repository = repository
        self.requestId = requestId
    }
    
    // MARK: Private
    
    private let repository: ResultRepositoryProtocol
    private var timer: Timer?
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.getResult()
        }
    }
    
    // MARK: Private methods
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    func getResult() {
        repository.getResult(requestId: requestId) { [weak self] result in
            switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.validationResponse = model
                    }
                    if model.validationData.status == "Processed" || model.validationData.status == "Incomplete" {
                        self?.stopTimer()
                    }
                case.failure(let error):
                    print("ResultViewModel error to view is \(error)")
            }
        }
    }
    
}
