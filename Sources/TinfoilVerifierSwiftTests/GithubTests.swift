//
//  TinfoilVerifierSwiftTests.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Testing

@testable import TinfoilVerifierSwift

struct GithubTests {
    @Test func testLatestResponse() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let (tagName, eifHash) = try await Github.fetchLatestRelease(
            repo: "tinfoilanalytics/nitro-enclave-build-demo")
    }

}
