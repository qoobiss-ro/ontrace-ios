import Foundation
import CommonCrypto

struct DecryptResponseUseCase {

    func call(inputText: String) -> String? {
        let keyData = Data(Secrets.decryptionKey.utf8)
        let blockSize = kCCBlockSizeAES128

        guard keyData.count == kCCKeySizeAES256,
              let payload = Data(base64Encoded: inputText),
              payload.count >= 2 * blockSize,
              payload.count.isMultiple(of: blockSize),
              let decryptedData = aesCBCDecrypt(
                  encryptedData: payload.dropFirst(blockSize),
                  keyData: keyData,
                  ivData: payload.prefix(blockSize)
              ) else {
            print("Decryption failed!")
            return nil
        }

        return String(decoding: decryptedData, as: Unicode.UTF8.self)
    }

    private func aesCBCDecrypt(encryptedData: Data, keyData: Data, ivData: Data) -> Data? {
        let keyLength = keyData.count
        let dataLength = encryptedData.count
        var numBytesDecrypted: size_t = 0
        
        let decryptedBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength + kCCBlockSizeAES128)
        defer { decryptedBuffer.deallocate() }
        
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
        
        return Data(bytes: decryptedBuffer, count: numBytesDecrypted)
    }
}
