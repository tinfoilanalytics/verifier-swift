//
//  Enclave.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import CryptoKit
import Foundation

struct Enclave {
    static func fetch(host: String) async throws -> (Document, SHA256.Digest) {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = URLScheme.https.rawValue
        urlComponents.path = "/.well-known/tinfoil-attestation"
        guard let url = urlComponents.url else {
            throw TinfoilError.urlConversion
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        let captureDelegate = CertCaptureDelegate()
        let session = URLSession(
            configuration: .ephemeral,
            delegate: captureDelegate,
            delegateQueue: nil
        )

        let (data, response) = try await session.data(for: request)

        let document = try JSONDecoder().decode(Document.self, from: data)

        guard let leafCertDigest = captureDelegate.certHash else {
            throw CertPinError.missingCertificate
        }

        return (document, leafCertDigest)
    }
}

struct URLScheme {
    public static let https = URLScheme(rawValue: "https")

    public let rawValue: String
}
