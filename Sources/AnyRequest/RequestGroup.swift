import Alamofire
import Combine
import Foundation

@resultBuilder
public enum RequestGroupResultBuilder {
    public static func buildBlock(_ requests: Request...) -> [Request] {
        return requests
    }
}

public struct RequestGroup {
    public private(set) var requests: [Request]
    
    public var combineIdentifier = CombineIdentifier()
    
    public init(@RequestGroupResultBuilder builder: () -> [Request]) {
        self.requests = builder()
    }
    
    public func buildPublisher() -> AnyPublisher<Input, Failure> {
        let publisher = Publishers.Sequence(sequence: requests).flatMap {$0}.collect().eraseToAnyPublisher()
        return publisher
    }
}

public extension RequestGroup {
    typealias Output = [DataResponsePublisher<Data>.Output]
    
    typealias Input = [DataResponsePublisher<Data>.Output]
    
    typealias Failure = Never
}

extension RequestGroup: Publisher {
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        buildPublisher().subscribe(self)
    }
}

extension RequestGroup: Subscriber {
    public func receive(completion: Subscribers.Completion<Never>) {}
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        return .unlimited
    }
    
    public func receive(subscription: Subscription) {
        return subscription.request(.unlimited)
    }
}
