//
//  Github.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation

struct Github {
    static func fetchLatestRelease(repo: String) async throws -> (
        tagName: String,
        eifHash: String
    ) {
        throw TinfoilError.mocking
    }

    static func fetchAttestationBundle(repo: String, digest: String) async throws -> Data {
        throw TinfoilError.mocking
    }
}
