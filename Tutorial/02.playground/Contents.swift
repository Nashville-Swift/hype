import UIKit
import WebKit
import PlaygroundSupport

/*:
 # Statically Typed HTML in Swift
 
 ## Part 2: Styling and workflow
 
 ### Rendering attributes
 
 Let's modify the work we did in the last section to allow for attributes to be rendered on an element. We will define an attribute a simple key value pair represented by a tuple of strings.
 */

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
