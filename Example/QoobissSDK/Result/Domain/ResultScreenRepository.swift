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
    /// Must match the XCFramework bake (`framework_script.sh --env staging` → eu-apistg).
    private let baseURL = "https://eu-apistg-ontrace.qoobiss.com/api/v2/"
    
    func getResult(requestId: String, completion: @escaping (Result<ValidationResponse, ResultError>) -> Void) {
        requestAccessToken(orderId: requestId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let accessToken):
                self.fetchResult(orderId: requestId, accessToken: accessToken, completion: completion)
            }
        }
    }
    
    private func requestAccessToken(orderId: String, completion: @escaping (Result<String, ResultError>) -> Void) {
        guard let url = URL(string: baseURL + "token/client") else {
            completion(.failure(ResultError(message: "Invalid token URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = [
            "clientId": Secrets.clientId,
            "clientSecret": Secrets.clientSecret,
            "orderId": orderId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                completion(.failure(ResultError(message: error.localizedDescription)))
                return
            }
            guard let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let accessToken = json["access_token"] as? String,
                  !accessToken.isEmpty else {
                completion(.failure(ResultError(message: "Could not read access token")))
                return
            }
            completion(.success(accessToken))
        }.resume()
    }
    
    private func fetchResult(orderId: String, accessToken: String, completion: @escaping (Result<ValidationResponse, ResultError>) -> Void) {
        var components = URLComponents(string: baseURL + "validation/identity/result")
        components?.queryItems = [URLQueryItem(name: "orderId", value: orderId)]
        guard let url = components?.url else {
            completion(.failure(ResultError(message: "Invalid result URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(ResultError(message: error.localizedDescription)))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            print("Result response status: \(status.map(String.init) ?? "none")")
            print("Result response body:\n\(body.prefix(100))")
            guard let data else {
                completion(.failure(ResultError(message: "Empty result response")))
                return
            }
            self.parseResponse(data, completion: completion)
        }.resume()
    }
    
    private func parseResponse(_ data: Data, completion: @escaping (Result<ValidationResponse, ResultError>) -> Void) {
        let stringResponse = String(data: data, encoding: .utf8)
        let decrypted = self.decryptionUseCase.call(inputText: stringResponse ?? "")

        if let decrypted {
            print("Decrypted result preview (first 100 characters):\n\(decrypted.prefix(100))")
        }

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
}

