//
//  Calculator.swift
//  SwiftUICalculator
//
//  Created by 杨 on 2020/3/23.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI

//var outputItems : [String] = []


/// Calculator
/// Input will always be
/// the form of 5 or 5 +
public enum Calculator {
    case input(String)
    case inputOp(left : String,op : KeyboardItem.MathOperation)
    
    var innerValue : String {
        switch self {
        case .input(let value):
            return value
        case .inputOp(let value,_):
            return value
        }
    }
    
    public enum Error : Swift.Error {
        case input
        case output
    }
    
    static var outputItems : [String] = []
    
    var history : String {
        let result = Calculator.outputItems.joined()
        switch self {
        case .input(let value):
            return result + value
        case .inputOp(_,_):
            return result
        }
    }
    
    var output : String {
        let value = obtainResult()
        if value == "0" {
            return innerValue
        }
        return value
    }
    
    func append(item : KeyboardItem) -> Calculator {
        switch item {
        case .digit(let num):
            return appendDigit(num)
        case .dot:
            return appendDot()
        case .operation(let op):
            return appendOperation(op)
        case .command(let cmd):
            return excuteCommand(cmd)
        }
    }
    
    func appendDigit(_ number : Int) -> Self {
        switch self {
        case .input(let value):
            return .input(value.appendDigit(number))
        case .inputOp(_,_):
            return .input("\(number)")
        }
    }
    
    func appendDot() -> Self {
        switch self {
        case .input(let value):
            return .input(value.appendDot())
        case .inputOp(_,_):
            return .input("0.")
        }
    }
    
    func appendOperation(_ operation : KeyboardItem.MathOperation) -> Self {
        switch self {
        case .input(let value):
            Calculator.outputItems.append(value)
            Calculator.outputItems.append(operation.rawValue)
            return .inputOp(left: value, op: operation)
        case .inputOp(let value,_):
            _ = Calculator.outputItems.popLast()
            Calculator.outputItems.append(operation.rawValue)
            return .inputOp(left: value, op: operation)
        }
    }
    
    func excuteCommand(_ cmd : KeyboardItem.Command) -> Self {
        switch cmd {
        case .clear:
            Calculator.outputItems.removeAll()
            return .input("0")
        case .equal:
            return excuteEqual()
        case .delete:
            return excuteDelete()
        default:
            return self
        }
    }
    
    func excuteEqual() -> Self {
        let result = obtainResult(command: true)
        return .input(result)
    }
    
    func excuteDelete() -> Self {
        switch self {
        case .input(let value):
            var old = value
            
            if old.count > 1 {
                old.removeLast()
                return .input(old)
            } else if old.count == 1 {
                old.removeLast()
                if Calculator.outputItems.count > 1 {
                    let count = Calculator.outputItems.count
                    let rawValue = Calculator.outputItems.last!
                    let left = Calculator.outputItems[count - 2]
                    if let operation = KeyboardItem.MathOperation(rawValue: rawValue) {
                        
                        return .inputOp(left: left, op: operation)
                    } else {
                        fatalError("calculate error")
                    }
                } else if Calculator.outputItems.count == 1 {
                    fatalError("calculate error")
                } else {
                    return .input("0")
                }
            } else {
                fatalError("calculate error")
            }
        case .inputOp(let value,_):
            
            if Calculator.outputItems.count > 1 {
                _ = Calculator.outputItems.popLast()
                _ = Calculator.outputItems.popLast()
            }
            
            return .input(value)
        }
    }
    
    /// Obtain result from TextFiled or `=` command
    /// - Parameter command: excute `=` command or not
    func obtainResult(command : Bool = false) -> String {
        var items = Calculator.outputItems
        
        if items.isEmpty && self.innerValue == "0"{
            return "0"
        }
        
        switch self {
        case .input(let value):
            items.append(value)
        case .inputOp(_,_):
            _ = items.popLast()
        }
        print("输出:\(items)")
        
        if command {
            Calculator.outputItems.removeAll()
        }
        
        let result = Algorithm.calculate(items)
        switch result {
        case .success(let value):
            print("✅: \(value)")
            return value
        case .failure(let err):
            print("❌: \(err)")
            return "Error :\(err)"
        }
    }
}

extension String {
    func appendDigit(_ number : Int) -> Self  {
        return self == "0" ? "\(number)" : "\(self)\(number)"
    }
    
    func appendDot() -> Self {
        return containsDot() ? self : (self + ".")
    }
    
    mutating func appendOperation(_ operation : KeyboardItem.MathOperation) -> Self {
        if hasSuffixMathSymbols() || hasSuffixDot() {
            removeLast()
            return self + operation.rawValue
        }
        return self + operation.rawValue
    }
    
    func hasSuffixMathSymbols() -> Bool {
        let symbols = ["+","-","×","÷"]
        for sybmol in symbols {
            if hasSuffix(sybmol) {
                return true
            }
        }
        return false
    }
    
    func hasSuffixDot() -> Bool {
        return hasSuffix(".")
    }
    
    func containsDot() -> Bool {
        return self.contains(".")
    }
}








