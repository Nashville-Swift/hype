import Foundation
import Hype

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}
infix operator |> : ForwardApplication
public func |> <A, B> (lhs: A, rhs: (A) -> (B)) -> B { return rhs(lhs) }

precedencegroup BackwardApplication {
    associativity: right
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}
infix operator <| : BackwardApplication
public func <| <A, B> (lhs: (A) -> (B), rhs: A) -> B { return lhs(rhs) }

precedencegroup ForwardComposition {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}
infix operator >>> : ForwardComposition
public func >>> <A, B, C>(_ lhs: @escaping (A) -> B, _ rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

public typealias S = SemanticUI
public let cssPath = Bundle.main.path(forResource: "semantic.min", ofType: ".css") ?? ""
public let styles = style(try! String(contentsOfFile: cssPath))
