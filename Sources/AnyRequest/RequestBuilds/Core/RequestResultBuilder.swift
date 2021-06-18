import Foundation

@resultBuilder
public enum RequestResultBuilder {
    public static func buildBlock(_ components: RequestBuildProtocol...) -> RequestBuildProtocol {
        CombinedRequestBuild(children: components)
    }
    
    public static func buildArray(_ components: [RequestBuildProtocol]) -> RequestBuildProtocol {
        CombinedRequestBuild(children: components)
    }
    
    public static func buildBlock() -> RequestBuildProtocol {
        EmptyRequestBuild()
    }
    
    public static func buildEither(first component: RequestBuildProtocol) -> RequestBuildProtocol {
        component
    }
    
    public static func buildEither(second component: RequestBuildProtocol) -> RequestBuildProtocol {
        component
    }
    
    public static func buildOptional(_ component: RequestBuildProtocol?) -> RequestBuildProtocol {
        guard let component = component else {
            return EmptyRequestBuild()
        }
        return component
    }
}
