//
//  Stack.swift
//  SwiftUICalculator
//
//  Created by 杨志远 on 2020/3/23.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

protocol Stackable {
    associatedtype Element
    
    var isEmpty : Bool { get }
    var size : Int { get }
    var peek : Element? { get }
    var elements : [Element] { get }
    
    mutating func push(_ el : Element)
    mutating func pop() -> Element?
}


struct Stack<T> : Stackable {
    typealias Element = T
    
    var isEmpty: Bool {
        return stacks.isEmpty
    }
    
    var size: Int {
        return stacks.count
    }
    
    var peek: Element? {
        return stacks.last
    }
    
    var elements: [T] {
        return stacks
    }
    
    private var stacks : [Element] = []
    
    mutating func push(_ el: Element) {
        stacks.append(el)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        return stacks.popLast()
    }
    
    mutating func removeAll() {
        stacks.removeAll()
    }
}
