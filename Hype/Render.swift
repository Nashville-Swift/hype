//
//  Render.swift
//  Hype
//
//  Copyright © 2018 Nashville Swift Language Group. All rights reserved.
//

import Foundation

public func render(_ node: Node) -> String {
    switch node {
    case let .comment(text):
        return "<!-- \(text) -->"
        
    case let .text(text):
        return text
        
    case let .element(name, attributes, child):
        let attributesString = attributes
            .map { $0.asPair }
            .map { "\($0.0)=\"\($0.1)\"" }
            .joined(separator: " ")
        
        let openingTagContent =
            [name, attributesString]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .joined(separator: " ")
        
        let openingTag = "<\(openingTagContent)>"
        let childContent = render(child)
        let closingTag = "</\(name)>"
 
        return [openingTag, childContent, closingTag]
            .compactMap { $0 }
            .joined()
        
    case let .siblings(nodes):
        return nodes
            .map(render)
            .joined()
        
    case .empty:
        return ""
    }
}
