
import UIKit
import WebKit
import PlaygroundSupport
import Hype

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}
infix operator |> : ForwardApplication
func |><A, B> (lhs: A, rhs: (A) -> (B)) -> B { return rhs(lhs) }

precedencegroup ReverseApplication {
    associativity: right
    higherThan: AssignmentPrecedence
}
infix operator <| : ReverseApplication
func <|<A, B> (lhs: (A) -> (B), rhs: A) -> B { return lhs(rhs) }

typealias S = SemanticUI
let cssPath = Bundle.main.path(forResource: "semantic.min", ofType: ".css") ?? ""
let styles = style(try! String(contentsOfFile: cssPath))

/*:
 ## Models
 */

struct Link {
    let text: String
    let url: String
}

let menuLinks = [
    Link(text: "About", url: "#about"),
    Link(text: "Calendar", url: "#calendar"),
    Link(text: "Resources", url: "#resources")
]

/*:
 ## Components
 */

let staticMenu: Component<[Link]> = { links in
    div([S.ui, S.secondary, S.inverted, S.pointing, S.menu]) {
        links.map {
            a([S.item], $0.text)
        } |> Node.siblings
    }
}

let hero: Component<Node> = { menu in
    div([S.pusher]) {
        div([S.ui, S.inverted, S.vertical, S.center, S.aligned, S.segment]) {
            div([S.ui, S.container]) {
                menu +
                div([S.ui, S.text, S.container]) {
                    h1([S.ui, S.inverted, S.header], "Nashville Swift Language Group")
                }
            }
        }
    }
}

let contentWrapper =
    container
    <| div
    <| [S.ui, S.vertical, S.striped, S.segment]

let mainGrid =
    container
    <| div
    <| [S.ui, S.middle, S.aligned, S.stackable, S.grid, S.container]

let about =
    div([S.row]) {
        div([S.sixteen, S.wide, S.column]) {
            h3("About") +
                p("Join us each month to share, learn, and discuss the Swift programming language, a modern, general-purpose, multi-paradigm language introduced by Apple at their 2014 developer conference (WWDC).")
        }
    } +
    div([S.row]) {
        div([S.four, S.wide, S.column, S.center, S.aligned]) {
            h4("When?")
            } +
            div([S.four, S.wide, S.column]) {
                p("The 2nd Thursday of each month from 6pm - 8pm")
            } +
            div([S.four, S.wide, S.column, S.center, S.aligned]) {
                h4("Where?")
            } +
            div([S.four, S.wide, S.column]) {
                p("HCA Building 4") +
                    p("2555 Park Plaza Nashville TN")
        
        }
    }

let calendar =
    div([S.row]) {
        div([S.sixteen, S.wide, S.column]) {
            h3("Calendar") +
                p("http://api.meetup.com/Nashville-Swift-Language-Meetup/upcoming.ical")
        }
    }


let resources =
    div([S.row]) {
        div([S.sixteen, S.wide, S.column]) {
            h3("Resources")
        }
    } +
    div([S.row]) {
        div([S.four, S.wide, S.column, S.center, S.aligned]) {
            h4("Talks / Presentations")
            } +
            div([S.four, S.wide, S.column]) {
                p("https://github.com/Nashville-Swift/monthly-meetups")
            } +
            div([S.four, S.wide, S.column, S.center, S.aligned]) {
                h4("Where?")
            } +
            div([S.four, S.wide, S.column]) {
                p("HCA Building 4") +
                    p("2555 Park Plaza Nashville TN")    
        }
    }

/*:
 ## The dom
 */

let dom =
    html {
        head { styles } +
        body {
            hero(staticMenu(menuLinks)) +
            contentWrapper(
                mainGrid(
                    about +
                    calendar +
                    resources
                )
            )
        }
    }

/*:
 ## Rendering
 */

let renderedHtml = render(dom)

let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 700, height: 1000))
webView.loadHTMLString(renderedHtml, baseURL: nil)
PlaygroundPage.current.liveView = webView
