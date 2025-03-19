import Foundation

struct Address: Codable {
    let districtName: String
    let cityName: String
    let streetName: String?
    let streetNo: String?
    let flatNo: String?
    let stairNo: String?
    let floorNo: String?
    let apartmentNo: String?
    
    enum CodingKeys: String, CodingKey {
        case districtName = "DistrictName"
        case cityName = "CityName"
        case streetName = "StreetName"
        case streetNo = "StreetNo"
        case flatNo = "FlatNo"
        case stairNo = "StairNo"
        case floorNo = "FloorNo"
        case apartmentNo = "ApartmentNo"
    }
}
