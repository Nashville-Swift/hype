
import UIKit
import WebKit
import PlaygroundSupport
import Hype

/*:
 When designing interfaces, it's common to have a "component" that "wraps" or "decorates" another component. For example, imagine we have some styled text component being used to render content on a page. A different page may want to display the same text component in a small card off to the side.
 
        // Page 1
        body {
            textComponent(contentA)
        }

        // Page 2
        body {
            p("Some content...") +
            card {
                textComponent(contentA)
            }
        }
 
 Additionally, we may decide later that we want to place an image in the card:
 
        // Page 2
        body {
            p("Some content...") +
            card {
                img(url)
            }
        }
 
 Given some card styles, we could create the card like this:
 */

let cardStyle = attributeDecorator([.class(value: "card")])
let cardContentStyle = attributeDecorator([.class(value: "card-content")])

let card: Component<Node> = { node in
    cardStyle <| div {
        cardContentStyle <| div {
            node
        }
    }
}

/*:
 Now we can render our card:
 */

render(
    card(p("hello!"))
)

/*:
 Since card is taking a node, it would be nice to use curly braces `{ }` like we do for the other elements. We tend to use `{ }` for denoting structure and parenthesis `( )` for passing data. We can change the type signature to achieve this look:
 */

let card2: (@escaping () -> Node) -> Node = { node in
    cardStyle <| div {
        cardContentStyle <| div {
            node()
        }
    }
}

/*:
 This seems a bit more natural:
 */

render(
    card2 {
        p("hello!")
    }
)

/*:
 If we look closely enough at `card2` we will see that we already have some existing types to describe this!
 
       (@escaping () -> Node) -> Node == Component<NodeThunk>
 */

let card3: Component<NodeThunk> = { node in
    cardStyle <| div {
        cardContentStyle <| div {
            node()
        }
    }
}

render(
    card3 {
        p("hello!")
    }
)

/*:
 What we've discovered is our original "wrapper" or "container" type signature is equivalent to `Component<NodeThunk>`. This begs the question: is this a common enough pattern to deserve it's own special type? What would that look like?
 */

public typealias Container = Component<NodeThunk>

let card4: Container = { node in
    cardStyle <| div {
        cardContentStyle <| div {
            node()
        }
    }
}

/*:
 How else can we write this? What if we use a function?
 */

public func container(_ f: @escaping (Node) -> Node) -> Container {
    return { nodeThunk in
        f(nodeThunk())
    }
}

let card5 = container { node in
    cardStyle <| div {
        cardContentStyle <| div {
            node
        }
    }
}

render(
    card5 {
        p("hello!")
    }
)

/*:
 Thoughts:
    1. Is this a common enough pattern to justify a new type?
 
    "I think so. My first intuition was to use Component<Node> but as we saw in the first example, that led to parenthesis which looked out of place for something that was supposed to be wrapping another node. Having a typealias can guide people to write more natural looking components." - cconstable
 
    2. If so, do we introduce a typealias only or a function as well?
 
    "I'm less sure about this. The component function seems like it could be used for composition later but I don't have any concrete useful examples at the moment." - cconstable
 
    3. Is there a better way to represent this idea of a component "wrapping" another?
 */





