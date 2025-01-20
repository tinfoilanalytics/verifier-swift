# Tinfoil Verifier for Swift

## Example Implementation

https://github.com/tinfoilanalytics/verifier-swift-example

## Installation

### Using Swift Package Manager

1. In Xcode, select File > Add Package Dependencies
2. Enter the package repository URL:
   ```
   https://github.com/tinfoilanalytics/verifier-swift
   ```
3. Select the version you want to use
4. Click "Add Package"

Alternatively, you can add it directly to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/tinfoilanalytics/verifier-swift", exact: "0.0.2")
]
```

## Basic Usage

### Importing the Package

First, import the TinfoilVerifier package in your Swift file:

```swift
import TinfoilVerifier
```

### Creating a Verifier Client

To create a new verifier client:

```swift
let client = TinfoilVerifier.ClientNewSecureClient(
    "inference-enclave.tinfoil.sh",               // Enclave hostname
    "tinfoilanalytics/nitro-enclave-build-demo"   // Repository path
)
```

### Performing Verification

To verify an enclave:

```swift
do {
    let enclaveState = try client?.verify()

    // Access EIF hash and TLS certificate fingerprint
    let eifHash = enclaveState?.eifHash
    let certFingerprint = enclaveState?.certFingerprint
} catch {
    print("Verification failed: \(error)")
}
```

## API Reference

### ClientNewSecureClient

Creates a new secure client for verifying enclaves.

**Parameters:**
- `serverAddress`: String - The address of the enclave server
- `projectPath`: String - The path to the project repository

**Returns:** An optional TinfoilVerifier client instance

### verify()

Performs verification of the enclave.

**Returns:** An EnclaveState object containing:
- `eifHash`: String - The EIF hash of the enclave
- `certFingerprint`: [UInt8]? - The certificate fingerprint as a byte array

**Throws:** Verification error
