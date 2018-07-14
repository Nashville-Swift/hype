//
//  Node.swift
//  Hype
//
//  Created by Christopher Constable on 6/30/18.
//  Copyright © 2018 Chris Constable. All rights reserved.
//

import Foundation

public typealias NodeThunk = () -> Node

public indirect enum Node {
    case comment(text: String)
    case text(text: String)
    case element(name: String, attributes: [Attribute], child: Node)
    case siblings(nodes: [Node])
    case empty
}

// MARK: Monoid

public func empty() -> Node {
    return .empty
}

public func +(lhs: Node, rhs: Node) -> Node {
    return .siblings(nodes: [lhs, rhs])
}




