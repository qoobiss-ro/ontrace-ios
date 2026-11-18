import Foundation

struct ValidationResponse: Decodable {
    let result: ValidationReport?
    let validationData: ValidationData
    let hash: String?

    private enum CodingKeys: String, CodingKey {
        case validationData = "ValidationData"
        case hash = "Hash"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.validationData) {
            result = nil
            validationData = try container.decode(ValidationData.self, forKey: .validationData)
            hash = try container.decodeIfPresent(String.self, forKey: .hash)
        } else {
            let report = try ValidationReport(from: decoder)
            result = report
            validationData = report.makeValidationData()
            hash = report.report.hash
        }
    }
}

struct ValidationReport: Decodable {
    let report: Report
    let order: Order
    let session: Session?
    let outcome: Outcome?
    let checks: [Check]?
    let subject: Subject?
    let document: Document?
    let risk: Risk?
    let artifacts: [Artifact]?

    struct Report: Decodable {
        let version: String?
        let generatedAt: String?
        let hash: String?
    }

    struct Order: Decodable {
        let id: String?
        let status: String?
        let client: String?
    }

    struct Session: Decodable {
        let phoneNumber: String?
        let startedAt: String?
        let endedAt: String?
        let otp: Otp?

        struct Otp: Decodable {
            let code: String?
        }
    }

    struct Outcome: Decodable {
        let overall: String?
        let document: String?
    }

    struct Check: Decodable {
        let checkName: String?
        let status: String?
        let pipelines: [Pipeline]?
        let score: Double?

        struct Pipeline: Decodable {
            let capture: String?
            let pipeline: String?
            let calibration: String?
            let status: String?
            let score: Double?
        }
    }

    struct Subject: Decodable {
        let name: Name?
        let dateOfBirth: String?
        let placeOfBirth: String?
        let age: Int?
        let sex: String?
        let nationality: Nationality?
        let nationalId: NationalId?
        let address: Address?

        struct Name: Decodable {
            let surname: String?
            let givenNames: String?
            let full: String?
            let surnameLocal: String?
            let givenNamesLocal: String?
            let fullLocal: String?
            let sources: Sources?

            struct Sources: Decodable {
                let mrz: Mrz?
                let visual: Visual?

                struct Mrz: Decodable {
                    let surname: String?
                    let givenNames: String?
                    let full: String?
                }

                struct Visual: Decodable {
                    let surname: String?
                    let givenNames: String?
                    let full: String?
                }
            }
        }

        struct Nationality: Decodable {
            let name: String?
            let alpha3: String?
            let numeric: String?
        }

        struct NationalId: Decodable {
            let value: String?
        }

        struct Address: Decodable {
            let cityName: String?
            let full: String?
        }
    }

    struct Document: Decodable {
        let category: String?
        let type: DocumentType?
        let classCode: String?
        let template: Template?
        let number: Number?
        let issuingState: IssuingState?
        let authority: String?
        let locale: Locale?
        let validity: Validity?
        let chip: Chip?
        let mrz: Mrz?
        let pages: [Page]?

        struct DocumentType: Decodable {
            let code: String?
            let raw: String?
        }

        struct Template: Decodable {
            let name: String?
        }

        struct Number: Decodable {
            let full: String?
            let series: String?
            let serial: String?
            let checkDigit: String?
        }

        struct IssuingState: Decodable {
            let name: String?
            let alpha3: String?
            let numeric: String?
        }

        struct Locale: Decodable {
            let name: String?
        }

        struct Validity: Decodable {
            let issueDate: String?
            let expiryDate: String?
            let monthsRemaining: Int?
            let yearsSinceIssue: Int?
            let subjectAgeAtIssue: Int?
        }

        struct Chip: Decodable {
        }

        struct Mrz: Decodable {
            let raw: String?
            let lines: [String]?
            let checkDigits: CheckDigits?

            struct CheckDigits: Decodable {
                let documentNumber: String?
                let dateOfBirth: String?
                let expiryDate: String?
                let personalNumber: String?
                let composite: String?
            }
        }

        struct Page: Decodable {
            let index: Int?
            let side: String?
            let rawName: String?
            let categoryRaw: String?
            let deprecated: Bool?
            let hasMrz: Bool?
            let liveness: Bool?
            let authenticityChecks: [AuthenticityCheck]?
            let imageQuality: [ImageQuality]?

            struct AuthenticityCheck: Decodable {
                let similarity: Int?
                let referenceArtifactId: String?
                let imageArtifactId: String?
            }

            struct ImageQuality: Decodable {
                let type: String?
                let value: String?
            }
        }
    }

    struct Risk: Decodable {
        let selfieEstimate: SelfieEstimate?
        let documentPortraitEstimate: DocumentPortraitEstimate?
        let flags: [Flag]?

        struct SelfieEstimate: Decodable {
            let ageRange: AgeRange?

            struct AgeRange: Decodable {
                let low: Int?
                let high: Int?
            }
        }

        struct DocumentPortraitEstimate: Decodable {
        }

        struct Flag: Decodable {
            let flagName: String?
            let status: String?
        }
    }

    struct Artifact: Decodable {
        let id: String?
        let name: String?
        let sha256: String?
        let mimeType: String?
        let bytes: Int?
        let inline: String?
    }
}

private extension ValidationReport {
    func makeValidationData() -> ValidationData {
        let person = subject.map { subject in
            Person(
                cnp: subject.nationalId?.value ?? "",
                idSeries: document?.number?.series ?? "",
                idNumber: document?.number?.serial ?? document?.number?.full ?? "",
                firstName: subject.name?.givenNames ?? "",
                lastName: subject.name?.surname ?? "",
                nationality: subject.nationality?.name ?? "",
                idExpirationDate: document?.validity?.expiryDate ?? "",
                idValidity: document?.validity?.issueDate ?? "",
                address: subject.address?.full ?? "",
                placeOfBirth: subject.placeOfBirth ?? ""
            )
        }
        return ValidationData(
            idSnapshot: artifact("idFront"),
            idBackSnapshot: artifact("idBack"),
            faceSnapshot: artifact("selfie"),
            idCheckResult: outcome?.document,
            cardHolderImageFromRegister: nil,
            faceLiveness: checkStatus("faceLiveness"),
            documentLiveness: checkStatus("documentLiveness"),
            faceComparison: checkStatus("faceComparison"),
            registerFaceComparisonCheck: nil,
            collectedDataReport: artifact("collectedDataReport"),
            orderID: order.id,
            status: order.status,
            otpCode: session?.otp?.code,
            clientPhoneNumber: session?.phoneNumber,
            clientIPAddress: nil,
            identityValidationStatus: outcome?.overall,
            person: person,
            address: nil,
            errors: nil
        )
    }

    func checkStatus(_ name: String) -> String? {
        checks?.first { $0.checkName == name }?.status
    }

    func artifact(_ name: String) -> String? {
        guard let artifact = artifacts?.first(where: { $0.name == name }),
              let inline = artifact.inline else { return nil }
        if inline.hasPrefix("data:") { return inline }
        return "data:\(artifact.mimeType ?? "application/octet-stream");base64,\(inline)"
    }
}
