import Foundation

public typealias Url = UrlRequestBuild

public struct UrlRequestBuild: RequestBuildProtocol {
    let urlString: String

    public init(urlString: String) {
        self.urlString = urlString
    }

    public func build(request: inout URLRequest) {
        request.url = URL(string: urlString)
    }
}

public extension UrlRequestBuild {
    func append(_ string: String) -> UrlRequestBuild {
        return .init(urlString: "\(urlString)\(string)")
    }
}
