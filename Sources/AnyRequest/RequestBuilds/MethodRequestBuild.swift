import Alamofire
import Foundation

public typealias MethodRequest = MethodRequestBuild

public struct MethodRequestBuild: RequestBuildProtocol {
    let httpMethod: HTTPMethod?
    
    public init(_ httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod
    }
    
    public func build(request: inout URLRequest) {
        request.method = self.httpMethod
    }
}
