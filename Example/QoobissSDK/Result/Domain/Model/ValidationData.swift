import Foundation

struct ValidationData: Codable {
    let idSnapshot: String?
    let idBackSnapshot: String?
    let faceSnapshot: String?
    let idCheckResult: String?
    let cardHolderImageFromRegister: String?
    let faceLiveness: String?
    let documentLiveness: String?
    let faceComparison: String?
    let registerFaceComparisonCheck: String?
    let collectedDataReport: String?
    let orderID: String?
    let status: String?
    let otpCode: String?
    let clientPhoneNumber: String?
    let clientIPAddress: String?
    let identityValidationStatus: String?
    let person: Person?
    let address: Address?
    let errors: String?
    
    enum CodingKeys: String, CodingKey {
        case idSnapshot = "IdSnapshot"
        case idBackSnapshot = "IdBackSnapshot"
        case faceSnapshot = "FaceSnapshot"
        case idCheckResult = "IDCheckResult"
        case cardHolderImageFromRegister = "CardHodelrImageFromRegister"
        case faceLiveness = "FaceLiveness"
        case documentLiveness = "DocumentLiveness"
        case faceComparison = "FaceComparison"
        case registerFaceComparisonCheck = "RegisterFaceComparisonCheck"
        case collectedDataReport = "CollectedDataReport"
        case orderID = "OrderID"
        case status = "Status"
        case otpCode = "OTPCode"
        case clientPhoneNumber = "ClientPhoneNumber"
        case clientIPAddress = "ClientIPAddress"
        case identityValidationStatus = "IdentityValidationStatus"
        case person = "Person"
        case address = "Address"
        case errors = "Errors"
    }
}
