//
//  TinfoilVerifier.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation
import TinfoilVerifier

///Main App interface

public struct TinfoilVerifier {
    ///client should store this and have policy for refetch
    //since this reaches into sigstore/tuf, maybe live with this being
    //a blocking sync method
    public static func fetchTrustRoot() async throws -> [Data] {
        throw TinfoilError.mocking
    }

    //synchronous variant of the above
    public static func fetchTrustRoot(
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        DispatchQueue.global().async {
            completionHandler(.failure(TinfoilError.mocking))
        }

    }
}

public struct TinfoilClient: Codable, Sendable {
    public let enclave: String
    public let repo: String

    public init(enclave: String, repo: String, verifiedState: EnclaveState? = nil) {
        self.enclave = enclave
        self.repo = repo
    }

    public struct EnclaveState: Codable, Sendable {
        let certFingerPrint: Data
        let eifHash: String
    }

    public func verify(
        enclaveState: ClientEnclaveState,
        sigStoreTrustRoot: Data  //cached by the application
    ) async throws -> EnclaveState {
        let (_, eifHash) = try await Github.fetchLatestRelease(repo: repo)

        //start these concurrently
        async let sigStoreBundle = try await Github.fetchAttestationBundle(
            repo: repo,
            digest: eifHash
        )
        async let (enclaveAttestation, enclaveCertFP) = try await Enclave.fetch(host: enclave)

        let codeMeasurements = try await SigStore.verifyMeasurementAttestation(
            trustedRootJSON: sigStoreTrustRoot,
            bundleJSON: sigStoreBundle,
            hexDigest: eifHash,
            repo: repo
        )

        let (enclaveMeasurements, attestedCertFP) = try await enclaveAttestation.verify()

        guard try await enclaveCertFP == attestedCertFP else {
            throw TinfoilError.mismatchedCertificates
        }

        guard enclaveMeasurements == codeMeasurements else {
            throw TinfoilError.mismatchedMeasurements
        }

        return .init(
            certFingerPrint: attestedCertFP,
            eifHash: eifHash
        )

    }
}

enum TinfoilError: Error {
    case mocking
    case mismatchedCertificates
    case mismatchedMeasurements
    case urlConversion
    case getFailed
    case regexMiss
}

//TODO: for Tinfoil
//stubbing interface from the golang function interface that may be missing
struct SigStore {
    static func verifyMeasurementAttestation(
        trustedRootJSON: Data,
        bundleJSON: Data,
        hexDigest: String,
        repo: String
    ) throws -> Measurement {
        throw TinfoilError.mocking
    }
}

struct Measurement: Equatable {

}

struct Enclave {
    static func fetch(host: String) async throws -> (Document, Data) {
        throw TinfoilError.mocking
    }
}

struct Document {
    func verify() throws -> (Measurement, Data) {
        throw TinfoilError.mocking
    }
}
