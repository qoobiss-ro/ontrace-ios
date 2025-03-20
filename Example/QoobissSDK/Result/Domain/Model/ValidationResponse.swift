import Foundation

struct ValidationResponse: Codable {
    let validationData: ValidationData
    let hash: String?
    
    enum CodingKeys: String, CodingKey {
        case validationData = "ValidationData"
        case hash = "Hash"
    }
}
