
/*:
 # Statically Typed HTML in Swift
 
 ## Part 2: Styling and workflow
 
 ### Rendering attributes
 
 Let's modify the work we did in the last section to allow for attributes to be rendered on an element. We will define an attribute a simple key value pair represented by a tuple of strings.
 */

import UIKit
import WebKit
import PlaygroundSupport

indirect enum Node {
    case element(name: String, attributes: [(String, String)], child: Node)
    case text(String)
    case comment(String)
    case empty
}

func render(_ node: Node) -> String {
    switch node {
    case let .element(name, attributes, child):
        let attributes = attributes.map { "\($0.0)=\"\($0.1)\"" }.joined(separator: " ")
        return "<\(name) \(attributes)>\(render(child))</\(name)>"
    case let .text(text):
        return text
    case let .comment(text):
        return "<!-- \(text) -->"
    case .empty:
        return ""
    }
}

let myFancyDiv = Node.element(
    name: "div",
    attributes: [("style", "background-color:#F37")],
    child: .text("fancy!")
)

/*:
 Looks good! Wouldn't it be nice to actually see the html visually? We can do this with a playground live view. To open the live view hit "opt + cmd + enter" and then select "live view" from the top bar.
 */

let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
webView.loadHTMLString(render(myFancyDiv), baseURL: nil)
PlaygroundPage.current.liveView = webView

/*:
 ### Who would have thunk it?
 
 Let's revisit an example from the first section:
 
         let dom =
             html(
                 body(
                     div(
                         p("hello, swift!")
                     )
                 )
             )
 
 When we see parentheses in programming languages we often think of invoking something. When we see curly braces `{ }` we often think of structure like a class, if statement, or struct. Since we are denoting structure here, it makes more sense to use curly braces rather than parentheses. How can we do this?
 
 Thunks and Swift's trailing closure syntax!
 
 Thunks are functions that take no arguments and return a value. It is something that has "already been thinked". Swift's trailing closure syntax means that when we have a function that takes another function as its last argument we can get rid of the parentheses and just use curly braces.
 
 This is better demonstrated than discussed:
 */

typealias NodeThunk = () -> Node
let html: (NodeThunk) -> Node = { node in
    .element(name: "html", attributes:[], child: node())
}

let body: (NodeThunk) -> Node = { node in
    .element(name: "body", attributes:[], child: node())
}

let div: (NodeThunk) -> Node = { node in
    .element(name: "div", attributes:[], child: node())
}

let p: (String) -> Node = { text in
    .element(name: "p", attributes:[], child: .text(text))
}

let dom =
    html {
        body {
            div {
                p("hello!")
            }
        }
    }

/*:
 That looks much more natural!
 
 ### Laziness
 
 We've done something quite subtle that has huge implications.
 
 If you want to perform some work later what do you do? You can wrap it in a function and then you can invoke that function whenever you want the work done. This is essentially what a *thunk* is. Thunks are one of the key mechanisms that languages and frameworks use to be "lazy" or "to defer computation till it is actually needed". We've taken our first step at building a "lazy" HTML templating engine. Ironically enough, this change was brought about by deciding to *not be lazy designers* and make the framework code appear prettier and more meaningful (we wanted curly braces instead of parentheses).
 */
