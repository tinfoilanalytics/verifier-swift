//
//  ABI.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation

//TODO: for Tinfoil ABI
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
