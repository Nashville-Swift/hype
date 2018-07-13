//
//  Render.swift
//  Hype
//
//  Created by Christopher Constable on 7/3/18.
//  Copyright © 2018 Chris Constable. All rights reserved.
//

import Foundation

public func render(_ node: Node) -> String {
    switch node {
    case let .comment(text):
        return "<!-- \(text) -->"
        
    case let .text(text):
        return text
        
    case let .element(name, styles, attributes, children):
        var classAtrString: String? = nil
        var attributesString: String? = nil
        
        if let styles = styles, styles.count > 0 {
            let attributePairs = attributes.map { a in a.map { b in b.asPair } } ?? []
            let classesFromAttributes = attributePairs.filter { $0.0 == "class" }.map { $0.0 }
            let classes = styles.map{ $0.className } + classesFromAttributes
            
            if classes.count > 0 {
                classAtrString = "class=\"" + classes.joined(separator: " ") + "\""
            }
        }
        
        if let attributes = attributes, attributes.count > 0 {
            let attributePairs = attributes.map { $0.asPair }
            attributesString = attributePairs.filter { $0.0 != "class" }
                .map { "\($0.0)=\"\($0.1)\""}
                .joined(separator: " ")
        }
        
        let openingTagContent = [name, classAtrString, attributesString]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .joined(separator: " ")
        let openingTag = "<\(openingTagContent)>"
        let childContent = children.map(render)
        let closingTag = "</\(name)>"
 
        return [
            openingTag,
            childContent,
            closingTag
            ]
            .compactMap { $0 }
            .joined()
        
    case .empty:
        return ""
        
    case let .siblings(nodes):
        return nodes
            .map(render)
            .joined()
    }
}
