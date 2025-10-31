import Foundation

public protocol RemoteCertificatesDelegate: AnyObject {
    func pinnedCertificates() -> [Data]
}
