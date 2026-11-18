import Foundation

extension String {
    func toDictionary() -> [String: Any]? {
        guard let jsonData = data(using: .utf8) else {
            print("Failed to convert string to data.")
            return nil
        }
        
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Failed to convert string to dictionary: \(error)")
        }
        
        return nil
    }
    
    func extractJSONPart() -> String? {
        guard let start = firstIndex(of: "{"),
              let end = lastIndex(of: "}"),
              start < end else { return nil }
        return String(self[start...end])
    }
    
    func removeBase64Prefix() -> String? {
        if let commaRange = range(of: ",") {
            let trimmedString = String(self[commaRange.upperBound...])
            return trimmedString
        } else {
            return nil
        }
    }
    
}
