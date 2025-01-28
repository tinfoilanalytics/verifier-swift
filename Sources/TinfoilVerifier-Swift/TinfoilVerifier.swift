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

extension ClientSecureClient {
    public func verify(
        enclaveState: ClientEnclaveState,
        sigStoreTrustRoot: Data  //cached by the application
    ) async throws {
        let (_, eifHash) = try await Github.fetchLatestRelease(repo: repo)

        let sigStoreBundle = try await Github.fetchAttestationBundle(
            repo: repo,
            digest: eifHash
        )

        let codeMeasurements = try SigStore.verifyMeasurementAttestation(
            trustedRootJSON: sigStoreTrustRoot,
            bundleJSON: sigStoreBundle,
            hexDigest: eifHash,
            repo: repo
        )

        //since this doesn't rely on the above, seems like we can cache
        //the validation result
        let (enclaveAttestation, enclaveCertFP) = try await Enclave.fetch(host: enclave)

        let (enclaveMeasurements, attestedCertFP) = try await enclaveAttestation.verify()

        guard enclaveCertFP == attestedCertFP else {
            throw TinfoilError.mismatchedCertificates
        }

        guard enclaveMeasurements == codeMeasurements else {
            throw TinfoilError.mismatchedMeasurements
        }

        //mutate and return verified state

        //        return verifiedState
    }
}

enum TinfoilError: Error {
    case mocking
    case mismatchedCertificates
    case mismatchedMeasurements
}

//TODO: for Tinfoil
//stubbing interface from the golang function interface that may be missing
extension ClientSecureClient {
    var repo: String { "inference-enclave.tinfoil.sh" }
    var enclave: String { "tinfoilanalytics/nitro-enclave-build-demo" }

    //
}

struct SigStore {
    static func verifyMeasurementAttestation(
        trustedRootJSON: Data,
        bundleJSON: Data,
        hexDigest: String,
        repo: String
    ) throws -> Measurement? {
        return nil
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
