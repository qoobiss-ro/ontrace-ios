import Foundation
import CommonCrypto

struct DecryptResponseUseCase {

    func call(inputText: String) -> String? {
        let keyData = Data(Secrets.decryptionKey.utf8)
        let ivData = Data(repeating: 0, count: 16)
        
        let encryptedBase64 = inputText
        if let encryptedData = Data(base64Encoded: encryptedBase64),
           let decryptedData = aesCBCDecrypt(encryptedData: encryptedData, keyData: keyData, ivData: ivData)
        {
            let decryptedText = String(decoding: decryptedData, as: Unicode.UTF8.self)
            return decryptedText
        } else {
            print("Decryption failed!")
            return nil
        }
    }
    
    private func aesCBCDecrypt(encryptedData: Data, keyData: Data, ivData: Data) -> Data? {
        let keyLength = keyData.count
        let dataLength = encryptedData.count
        var numBytesDecrypted: size_t = 0
        
        let decryptedBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength + kCCBlockSizeAES128)
        defer { decryptedBuffer.deallocate() }
        
        var decryptedData = Data(count: dataLength + kCCBlockSizeAES128)
        
        let result = encryptedData.withUnsafeBytes { encryptedBytes in
            let encryptedPointer = encryptedBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
            
            return ivData.withUnsafeBytes { ivBytes in
                let ivPointer = ivBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
                
                return keyData.withUnsafeBytes { keyBytes in
                    let keyPointer = keyBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
                    
                    return CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyPointer, keyLength,
                        ivPointer,
                        encryptedPointer, dataLength,
                        decryptedBuffer, dataLength + kCCBlockSizeAES128,
                        &numBytesDecrypted
                    )
                }
            }
        }
        
        guard result == kCCSuccess else {
            print("Error decrypting")
            return nil
        }
        
        decryptedData.removeAll()
        decryptedData.append(decryptedBuffer, count: numBytesDecrypted)
        return decryptedData
    }
}
