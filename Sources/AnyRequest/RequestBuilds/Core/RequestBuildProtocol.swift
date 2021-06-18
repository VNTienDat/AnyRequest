import Foundation

public protocol RequestBuildProtocol {
    func build(request: inout URLRequest)
}
