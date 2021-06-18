import Foundation

internal struct CombinedRequestBuild: RequestBuildProtocol {
    fileprivate let children: [RequestBuildProtocol]

    init(children: [RequestBuildProtocol]) {
        self.children = children
    }

    func build(request: inout URLRequest) {
        children
            .sorted { a, _ in a is UrlRequestBuild }
            .forEach {
                $0.build(request: &request)
            }
    }
}
