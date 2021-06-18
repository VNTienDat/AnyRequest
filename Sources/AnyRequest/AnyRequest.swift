import Alamofire
import Combine
import Foundation

public typealias Request = AnyRequest

public struct AnyRequest {
    public let combineIdentifier = CombineIdentifier()
    
    private var onData: ((Data) -> Void)?
    
    private var onError: ((AFError) -> Void)?
    
    private var parameter: RequestBuildProtocol
    
    public init(@RequestResultBuilder builder: () -> RequestBuildProtocol) {
        self.parameter = builder()
    }
    
    public func buildPublisher() -> AnyPublisher<DataResponsePublisher<Data>.Output, DataResponsePublisher<Data>.Failure> {
        AF.request(urlRequest).publishData().eraseToAnyPublisher()
    }
    
    private var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://")!)
        parameter.build(request: &request)
        return request
    }
    
    private var urlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        return configuration
    }
    
    public func clone(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    public func onData(_ response: @escaping (Data) -> Void) -> Self {
        clone {
            $0.onData = response
        }
    }
    
    public func onError(_ response: @escaping (Error) -> Void) -> Self {
        clone {
            $0.onError = response
        }
    }
    
    public func call() {
        buildPublisher().subscribe(self)
    }
}

// MARK: - Combine

public extension AnyRequest {
    typealias Input = DataResponsePublisher<Data>.Output
    
    typealias Output = DataResponsePublisher<Data>.Output
    
    typealias Failure = Never
}

extension AnyRequest: Subscriber {
    public func receive(completion: Subscribers.Completion<Never>) {
        
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        if let onData = self.onData, let data = input.data {
            onData(data)
        }
        
        if let onError = self.onError, let error = input.error {
            onError(error)
        }
        
        return .none
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }
}

extension AnyRequest: Publisher {
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        buildPublisher()
            .subscribe(subscriber)
    }
}
