//
//  CertPinning.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import CryptoKit
import Foundation
import os

///Utilities to read the leaf certificate and pin it after verification

//Apple Developer Support convo:
//https://forums.developer.apple.com/forums/thread/749633

enum CertPinning {  // just for the namespace
    static func readLeafCert(challenge: URLAuthenticationChallenge) throws -> SHA256.Digest {
        guard let trust = challenge.protectionSpace.serverTrust,
            let trustCertificateChain = SecTrustCopyCertificateChain(trust)
                as? [SecCertificate],
            let leaf = trustCertificateChain.last
        else {
            throw CertPinError.missingCertificate
        }
        return SHA256.hash(data: SecCertificateCopyData(leaf) as Data)
    }
}

//class that captures the leaf cert for analysis
class CertCaptureDelegate: NSObject, URLSessionTaskDelegate {
    private static let logger = Logger(subsystem: "CertPinning", category: "CertCaptureDelegate")

    var certHash: SHA256.Digest? = nil

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async
        -> (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        )
    {
        do {
            certHash = try CertPinning.readLeafCert(challenge: challenge)
        } catch {
            Self.logger.error("Error capturing cert: \(error)")
        }
        //not an error to not capture
        return (.performDefaultHandling, nil)
    }

}

class CertPinDelegate: NSObject, URLSessionTaskDelegate {
    private static let logger = Logger(subsystem: "CertPinning", category: "CertPinDelegate")

    let pinnedCertDigest: Data

    init(pinnedCertDigest: Data) {
        self.pinnedCertDigest = pinnedCertDigest
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async
        -> (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        )
    {
        do {
            let sessionCert = try CertPinning.readLeafCert(challenge: challenge)
            guard sessionCert.data == pinnedCertDigest else {
                Self.logger.error("Pinned cert mismatch")
                return (.cancelAuthenticationChallenge, nil)
            }
            return (.performDefaultHandling, nil)
        } catch {
            Self.logger.error("Error capturing cert: \(error)")
            return (.cancelAuthenticationChallenge, nil)
        }
    }

}

enum CertPinError: Error {
    case missingCertificate
}
