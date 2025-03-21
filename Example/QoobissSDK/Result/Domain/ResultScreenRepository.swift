import Combine
import Foundation

public struct ResultError: Error, Codable {
    let message: String
    
    init(message: String) {
        self.message = message
    }
}

protocol ResultRepositoryProtocol {
    func getResult(requestId: String ,completion: @escaping (Result<ValidationResponse, ResultError>) -> Void)
}

class ResultRepository: ResultRepositoryProtocol {
    
    private let decryptionUseCase = DecryptResponseUseCase()
    
    func getResult(requestId: String, completion: @escaping (Result<ValidationResponse, ResultError>) -> Void) {
        var request = URLRequest(url: URL(string: "https://apiro.id-kyc.com/dev_validation/identity/result?orderId=\(requestId)")!)
        request.addValue(Secrets.apiKey, forHTTPHeaderField: "ApiKey")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            self.parseResponse(data) {result in
                completion(result)
            }
        }
        task.resume()
    }
    
    private func parseResponse(_ data: Data, completion: @escaping (Result<ValidationResponse, ResultError>) -> Void) {
        let stringResponse = String(data: data, encoding: .utf8)
        let decrypted = self.decryptionUseCase.call(inputText: stringResponse ?? "")
        let decryptedRaw = decrypted?.extractJSONPart()
        guard let dataForJsonParsing = decryptedRaw?.data(using: .utf8) else {
            completion(.failure(ResultError(message: "Could not decrypt content")))
            return
        }
        guard let response = try? JSONDecoder().decode(ValidationResponse.self, from: dataForJsonParsing) else {
            completion(.failure(ResultError(message: "Could not do json parsing for content")))
            return
        }
        completion(.success(response))
    }
    
    private var cancellables = Set<AnyCancellable>()
}

