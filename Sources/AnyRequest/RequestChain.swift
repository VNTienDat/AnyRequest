import Alamofire
import Combine
import Foundation

@resultBuilder
public enum RequestChainResultBuilder {
    public static func buildBlock(_ requests: Request...) -> [Request] {
        return requests
    }
}

public struct RequestChain {
    public private(set) var requests: [Request]
    
    public var combineIdentifier = CombineIdentifier()
    
    public init(@RequestChainResultBuilder builder: () -> [Request]) {
        self.requests = builder()
    }
    
    public func buildPublisher() -> AnyPublisher<Output, Failure> {
        if requests.isEmpty {
            return Combine.Empty().eraseToAnyPublisher()
        } else if requests.count == 1 {
            return requests.first!.collect().eraseToAnyPublisher()
        } else {
            var publisher = Publishers.Concatenate(prefix: requests[0], suffix: requests[1]).eraseToAnyPublisher()
            for index in 2 ... requests.count - 1 {
                publisher = Publishers.Concatenate(prefix: publisher, suffix: requests[index]).eraseToAnyPublisher()
            }
            return publisher.collect().eraseToAnyPublisher()
        }
    }
}

public extension RequestChain {
    typealias Output = [DataResponsePublisher<Data>.Output]
    
    typealias Input = [DataResponsePublisher<Data>.Output]
    
    typealias Failure = Never
}

extension RequestChain: Publisher {
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        buildPublisher().subscribe(self)
    }
}

extension RequestChain: Subscriber {
    public func receive(completion: Subscribers.Completion<Never>) {
        
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        return .none
    }
    
    public func receive(subscription: Subscription) {
        return subscription.request(.max(requests.count))
    }
}
