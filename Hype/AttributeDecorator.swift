//
//  AttributeDecorator.swift
//  Hype
//
//  Created by Christopher Constable on 7/14/18.
//  Copyright © 2018 Chris Constable. All rights reserved.
//

import Foundation

// TODO: Come up with a better name for this.
public func attributeDecorator(_ attributes: [Attribute]) -> (Node) -> Node {
    return { node in
        switch node {
        case let .element(name, prevAttributes, child):
            return Node.element(
                name: name,
                attributes: prevAttributes + attributes,
                child: child
            )
        default:
            return node
        }
    }
}
