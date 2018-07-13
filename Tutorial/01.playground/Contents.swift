
/*:
 # Statically Typed HTML in Swift
 
 This talk was given on 07/12/2018 at the Nashville Swift Language Group by Chris Constable (github: cconstable). For more info see https://nashvilleswift.org.
 */


/*:
 ## Part 1: Modeling HTML with union types
 
 ### What is HTML?
 
 - Tags / elements
 - text
 - comments
 
 Let's say that a "node" can be any one of these things. Whenever we have type that can only be represented by a finite set of things we have something called a union type or a sum type. In Swift this is called an "enum with associated values". In set theory this is called a disjoint union.
 
 Let's make a union type that represents HTML nodes:
 */

indirect enum Node {
    case element(name: String, children: Node)
    case text(String)
    case comment(String)
    case empty
}

/*:
 The `empty` case represents nothing. It's kind of like the `nil` of our nodes except it is a node. This allows us to get rid of this concept of things being "nil" and just talk about everything as a "node". It will be useful later!

 Here is a node that represents an <hr> tag:
 */

let hr = Node.element(name: "hr", children: .empty)

/*:
 A <p> element:
 */

let p: (String) -> Node = { text in
    return Node.element(name: "p", children: .text(text))
}

p("hello")
p("world!")

/*:
 A <div> element that contains other nodes
 */

let div: (Node) -> Node = { node in
    return Node.element(name: "div", children: node)
}

div(
    div(
        p("hi")
    )
)

/*:
 ### Rendering
 
 Let's start simple and render just text nodes. We can use pattern matching to handle deciding what to do with the node we want to render.
 */

func renderOnlyText(_ node: Node) -> String {
    switch node {
    case let .text(text):
        return text
    default:
        return ""
    }
}

let textContent = Node.text("this is some text content")
renderOnlyText(textContent)

/*:
 Let's make this more useful by adding the ability to render elements and comments:
 */

func render(_ node: Node) -> String {
    switch node {
    case let .element(name, child):
        return "<\(name)>\(render(child))</\(name)>"
    case let .text(text):
        return text
    case let .comment(text):
        return "<!-- \(text) -->"
    case .empty:
        return ""
    }
}

render(p("hey there!"))

/*:
 Does it work for really complex elements?
 */

let html: (Node) -> Node = { node in
    return Node.element(name: "html", children: node)
}

let body: (Node) -> Node = { node in
    return Node.element(name: "body", children: node)
}

let dom =
    html(
        body(
            div(
                p("hello, swift!")
            )
        )
    )

/*:
 One neat artifact is that what we've written above has the same kind of structure as actual HTML.
 */

render(dom)

/*:
 In 15 LOC we've created a way to model and render very simple HTML nodes. In the next section we'll add some styling and workflow enhancements.
 */
