import Foundation

internal struct EmptyRequestBuild: RequestBuildProtocol {
    public func build(request: inout URLRequest) {}
}
