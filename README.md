# Tinfoil Verifier for Swift

## Installation

### Using Swift Package Manager

1. In Xcode, select File > Add Package Dependencies
2. Enter the package repository URL:
   ```
   https://github.com/tinfoilsh/verifier-swift
   ```
3. Select the version you want to use
4. Click "Add Package"

Alternatively, you can add it directly to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/tinfoilsh/verifier-swift", exact: "0.0.21")
]
```


### Example usage:
```swift
private func VerifyEnclave() {
     errorMessage = nil
     
     let client = TinfoilVerifier.ClientNewSecureClient(
         ENCLAVE_HOST_ADDR, // e.g., inference-enclave.tinfoil.sh
         GITHUB_REPO_NAME // e.g., tinfoilsh/nitro-enclave-build-demo
     )

     do {
         let enclaveState = try client?.verify()
         
         eifHash = enclaveState?.eifHash ?? "Unknown"
         certFingerprint = enclaveState?.certFingerprint?.map { String(format: "%02x", $0) }.joined() ?? "none"
     } catch {
         print("Error: \(error)")
         errorMessage = error.localizedDescription
         eifHash = "Verification failed"
         certFingerprint = "Verification failed"
     }
}
```
