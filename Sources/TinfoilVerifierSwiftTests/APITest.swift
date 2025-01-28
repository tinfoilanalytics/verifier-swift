//
//  APITest.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Testing
import TinfoilVerifierSwift

//Example of APIUsage
struct APITest {
    static let trustedApplication = "inference-enclave.tinfoil.sh"
    static let repo = "tinfoilanalytics/nitro-enclave-build-demo"

    @Test func testTinfoilAPI() async throws {
        //fetch the SigStore trust root and cache it
        let trustRoot = try await TinfoilVerifier.fetchTrustRoot()

        let tinfoilClient = TinfoilClient(
            enclave: Self.trustedApplication,
            repo: Self.repo
        )

        //cache the verification
        let enclaveState = try await tinfoilClient.verify(
            sigStoreTrustRoot: trustRoot
        )

    }

}
