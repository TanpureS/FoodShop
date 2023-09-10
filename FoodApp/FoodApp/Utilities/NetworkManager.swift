//
//  NetworkManager.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import CommonCrypto
import Foundation
import UIKit

final class NetworkManager: NSObject {
    // MARK: Properties

    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "https://seanallen-course-backend.herokuapp.com/"
    let appetizerURL = baseURL + "swiftui-fundamentals/appetizers"
    
    var session: URLSession?
    
    // SSLPinning-related variables
    private let localPublicKey = "M5EB0Bx+dzIi9ZpZIbj6lJe/N1fxvJM3YMEKEhS7EOg="
    
    private let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    // MARK: Initialiser

    private override init() {
        super.init()
        session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }
    
    // MARK: API
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    // lazy load images from resouce
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}

// MARK: SSL Pinning Code

extension NetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        //Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            return
        }
        
        // MARK: Certificate Pinning
        
        //SSL Policy for domain check
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        
        //Evaluate the certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        
        //Local and Remote Certificate Data
        let remoteCertificateData: NSData = SecCertificateCopyData(certificate)
        
        let pathToCertificate = Bundle.main.path(forResource: "herokuapp", ofType: "cer")
        let localCertificateData: NSData = NSData.init(contentsOfFile: pathToCertificate!)!
        
        //Compare Data of both certificates
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)) {
            let credential: URLCredential = URLCredential(trust: serverTrust)
            debugPrint("Certification pinning is successfull")
            completionHandler(.useCredential, credential)
        } else {
            //failure happened
            debugPrint("Certification pinning is failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
        // MARK: PublicKey Pinning
        /*
        if let serverPublicKey = SecCertificateCopyKey(certificate), let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) {
            
            let data: Data = serverPublicKeyData as Data
            let serverHashKey = sha256(data: data)
            
            //comparing server and local hash keys
            if serverHashKey == localPublicKey {
                let credential: URLCredential = URLCredential(trust: serverTrust)
                debugPrint("Public Key pinning is successfull")
                completionHandler(.useCredential, credential)
            } else {
                debugPrint("Public Key pinning is failed")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } */
        
    }
}
