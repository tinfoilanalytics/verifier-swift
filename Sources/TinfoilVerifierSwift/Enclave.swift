//
//  Enclave.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation

struct Enclave {
    static func fetch(host: String) async throws -> (Document, Data) {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = URLScheme.https.rawValue
        urlComponents.path = "/.well-known/tinfoil-attestation"
        guard let url = urlComponents.url else {
            throw TinfoilError.urlConversion
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)

        let document = try JSONDecoder().decode(Document.self, from: data)

        // TODO: read and return the cert
        throw TinfoilError.mocking
    }
}

struct URLScheme {
    public static let https = URLScheme(rawValue: "https")

    public let rawValue: String
}

//TODO: export these types as needed from the golang library

struct Document: Decodable {
    let format: PredicateType
    let body: String

    func verify() throws -> (Measurement, Data) {
        throw TinfoilError.mocking
    }
}

enum PredicateType: String, Decodable {
    case awsNitroEnclaveV1 = "https://tinfoil.sh/predicate/aws-nitro-enclave/v1"
}
