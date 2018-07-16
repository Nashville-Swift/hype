/* ------------------------------------------------------
 Proposal: Adding attibutes using function composition
 Author: ccontable
 Date: July 2018
 
 How can we add the ability to specifiy HTML attributes
 on nodes in a way that is free from side-effects, easy
 to reason about, and allows us to compose many attributes
 together?
 ------------------------------------------------------ */

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

struct Link {
    let text: String
    let url: String
}

let links = [
    Link(text: "First Link", url: "https://blah1"),
    Link(text: "Second Link", url: "https://blah2")
]

struct App {
    let link: Link
    let name: String
    let desc: String
}

let etsy = App(
    link: Link(text: "Etsy", url: "https://etsy.com"),
    name: "Etsy",
    desc: "Handmade goods"
)

let instagram = App(
    link: Link(text: "Instagram", url: "https://instagr.am"),
    name: "Instagram",
    desc: "Photos"
)

let apps = [etsy, instagram]

let linkAD = { url in
    return attributeDecorator([
        .href(url: url)
    ])
}

let attr = attributeDecorator

let linkComponent2: Component<Link> = { link in
    a(link.text)
        |> attr([.href(url: link.url)])
        |> attr([.class(value: "link")])
}


let linkComponent: Component<Link> = { link in
    a(link.text)
        |> linkAD(link.url)
}

let appComponent: Component<App> = { app in
    div {
        h3(app.name) +
        p(app.desc) +
        linkComponent(app.link)
    }
}

let appsComponent = listComponent <| appComponent

render(
    linkAD("http://") <| a("test")
)

render(
    appsComponent(apps)
)

let webview = WKWebView.init(frame: CGRect(x: 0, y: 0, width: 480, height: 600))
webview.loadHTMLString(render(appsComponent(apps)), baseURL: nil)
PlaygroundPage.current.liveView = webview


















