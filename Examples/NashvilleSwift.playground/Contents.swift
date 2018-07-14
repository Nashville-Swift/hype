
import UIKit
import WebKit
import PlaygroundSupport
import Hype

/*:
 The actual https://nashvilleswift.org website.
 */

let dom = html {
    body {
        pre("""
        Nashville Swift Language Group
        https://www.meetup.com/Nashville-Swift-Language-Meetup/

        6pm - 8pm
        2nd Thursday of every month

        HCA Building 4
        2555 Park Plaza, Nashville TN. 37203
        """)
    }
}

let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 700, height: 1000))
webView.loadHTMLString(render(dom), baseURL: nil)
PlaygroundPage.current.liveView = webView
