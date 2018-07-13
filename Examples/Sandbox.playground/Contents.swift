
import UIKit
import WebKit
import PlaygroundSupport
import Hype

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}
infix operator |> : ForwardApplication
func |> <A, B> (lhs: A, rhs: (A) -> (B)) -> B { return rhs(lhs) }

precedencegroup BackwardApplication {
    associativity: right
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}
infix operator <| : BackwardApplication
func <| <A, B> (lhs: (A) -> (B), rhs: A) -> B { return lhs(rhs) }

precedencegroup ForwardComposition {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}
infix operator >>> : ForwardComposition
func >>> <A, B, C>(_ lhs: @escaping (A) -> B, _ rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

typealias S = SemanticUI
let cssPath = Bundle.main.path(forResource: "semantic.min", ofType: ".css") ?? ""
let styles = style(try! String(contentsOfFile: cssPath))

/*:
 ## Models
 */

struct Post {
    let title: String
    let content: String
}

let posts = [
    Post(title: "Hello world", content: "My first post."),
    Post(title: "Server Side Swift", content: "Swift is pretty neat!")
]

