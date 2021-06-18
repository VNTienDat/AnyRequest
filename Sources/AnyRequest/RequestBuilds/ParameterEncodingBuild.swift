import Alamofire
import Foundation

public typealias Encoding = ParameterEncodingBuild

public struct ParameterEncodingBuild: RequestBuildProtocol {
    let encoding: ParameterEncoding

    public init(encoding: ParameterEncoding) {
        self.encoding = encoding
    }

    public func build(request: inout URLRequest) {
        let parameter = request.httpBody?.toDictionary()
        if let newRequest = try? encoding.encode(request, with: parameter) {
            request = newRequest
        }
    }
}

extension Data {
    func toDictionary() -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self)
            return json as? [String: Any]
        } catch {
            return nil
        }
    }
}
