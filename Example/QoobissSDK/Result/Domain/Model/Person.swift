import Foundation

struct Person: Codable {
    let cnp: String
    let idSeries: String
    let idNumber: String
    let firstName: String
    let lastName: String
    let nationality: String
    let idExpirationDate: String
    let idValidity: String
    let address: String
    let placeOfBirth: String
    
    enum CodingKeys: String, CodingKey {
        case cnp = "CNP"
        case idSeries = "IDSeries"
        case idNumber = "IDNumber"
        case firstName = "FirstName"
        case lastName = "LastName"
        case nationality = "Nationality"
        case idExpirationDate = "IDExpirationDate"
        case idValidity = "IDValidity"
        case address = "Address"
        case placeOfBirth = "PlaceOfBirth"
    }
}
