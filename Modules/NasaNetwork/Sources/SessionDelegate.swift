import Foundation
import Security
import NasaNetworkInterface

public final class SessionDelegate: NSObject {
    private weak var delegate: RemoteCertificatesDelegate?

    public init(delegate: RemoteCertificatesDelegate) {
        self.delegate = delegate
    }
}

extension SessionDelegate: URLSessionDelegate {
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let trust = challenge.protectionSpace.serverTrust,
              let delegate = delegate else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        var certificates: [SecCertificate] = []
        if #available(iOS 15.0, *) {
            if let certChain = SecTrustCopyCertificateChain(trust) as? [SecCertificate] {
                certificates = certChain
            }
        } else {
            let count = SecTrustGetCertificateCount(trust)
            for index in 0..<count {
                if let cert = SecTrustGetCertificateAtIndex(trust, index) {
                    certificates.append(cert)
                }
            }
        }

        if let serverCertificate = certificates.first {
            let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
            _ = SecCertificateCopySubjectSummary(serverCertificate)

            if delegate.pinnedCertificates().contains(serverCertificateData) {
                completionHandler(.useCredential, URLCredential(trust: trust))
                return
            }
        }

        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
