import Alamofire
import Foundation

public typealias Headers = HeaderRequestBuild

public struct HeaderRequestBuild: RequestBuildProtocol {
    let headers: HTTPHeaders
    
    public init(headers: HTTPHeaders) {
        self.headers = headers
    }
    
    public func build(request: inout URLRequest) {
        request.allHTTPHeaderFields = headers.dictionary
    }
}
