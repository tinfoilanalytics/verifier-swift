//
//  EnclaveTests.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Testing

@testable import TinfoilVerifierSwift

struct EnclaveTests {
    static let trustedApplication = "inference-enclave.tinfoil.sh"

    @Test func testEnclaves() async throws {
        let (document, cert) = try await Enclave.fetch(host: Self.trustedApplication)
    }

}
