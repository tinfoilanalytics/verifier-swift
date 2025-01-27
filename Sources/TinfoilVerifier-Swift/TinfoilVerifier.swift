//
//  TinfoilVerifier.swift
//  TinfoilVerifier
//
//  Created by Mark @ Germ on 1/27/25.
//

import Foundation
import TinfoilVerifier

///Main App interface

struct TinfoilVerifier {
  ///client should store this and have policy for refetch
  //since this reaches into sigstore/tuf, maybe live with this being
  //a blocking synch method
  static func fetchTrustRootStore() async throws -> [Data] {
    throw TinfoilError.mocking
  }
}

enum TinfoilError: Error {
  case mocking
}
