//
//  Github.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation

struct Github {
    static let eifHashRegex = #/EIF hash: ([a-fA-F0-9]{64})/#

    static func fetchLatestRelease(repo: String) async throws -> (
        tagName: String,
        eifHash: String
    ) {
        let urlString = "https://api.github.com/repos/" + repo + "/releases/latest"

        guard let url = URL(string: urlString) else {
            throw TinfoilError.urlConversion
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw TinfoilError.getFailed
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let decoded = try decoder.decode(ReleaseResponse.self, from: data)
        guard let result = try Self.eifHashRegex.firstMatch(in: decoded.body) else {
            throw TinfoilError.regexMiss
        }

        return (decoded.tagName, .init(result.1))
    }

    private struct ReleaseResponse: Decodable {
        let tagName: String
        let body: String
    }

    static func fetchAttestationBundle(repo: String, digest: String) async throws -> Data {
        let urlString = "https://api.github.com/repos/" + repo + "/attestations/sha256:" + digest

        guard let url = URL(string: urlString) else {
            throw TinfoilError.urlConversion
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw TinfoilError.getFailed
        }

        let attestation = try Attestation(from: data)

        return attestation.bundle
    }

    struct Attestation: Decodable {
        let bundle: Data  //JsonMessage

        init(from input: Data) throws {
            let decoded = try JSONSerialization.jsonObject(with: input)
            guard let root = decoded as? [String: [Any]],
                let attestation = root["attestations"]?.first as? [String: Any],
                let bundle = attestation["bundle"]
            else {
                throw TinfoilError.decodeFailure
            }
            self.bundle = try JSONSerialization.data(
                withJSONObject: bundle
            )
        }

    }
}

public struct HTTPMethod: Hashable {
    public static let get = HTTPMethod(rawValue: "GET")

    public let rawValue: String
}
