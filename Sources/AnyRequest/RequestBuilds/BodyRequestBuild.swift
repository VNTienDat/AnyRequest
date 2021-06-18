import Foundation

public typealias HttpBody = BodyRequestBuild

public struct BodyRequestBuild: RequestBuildProtocol {
    var data: Data?

    public init(_ data: Data?) {
        self.data = data
    }

    public func build(request: inout URLRequest) {
        request.httpBody = data
    }
}
