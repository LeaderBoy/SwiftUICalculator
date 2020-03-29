//
//  Algorithm.swift
//  SwiftUICalculator
//
//  Created by 杨 on 2020/3/25.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

public struct Algorithm {
    public typealias ResultValue = Result<String,Calculator.Error>
    
    public static func calculate(_ items : [String]) -> ResultValue {
        let expression = ShuntingYard.excute(for: items)
        return ReversePolishNotation.excute(for: expression)
    }
    
    static func calculate(_ string : String) -> ResultValue {
        let items = string.map{String($0)}
        let res = ShuntingYard.excute(for: items)
        return ReversePolishNotation.excute(for: res)
    }
    
    /// 先判断是否是数值
    static func isDigitValue(for string : String) -> Bool {
        if string.count > 0 {
            let superSet = CharacterSet(charactersIn: "1234567890.")
            return superSet.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return false
    }
    
    /// Character at `index` in `items` is negative or not
    /// - Parameters:
    ///   - items: string items
    ///   - index: character's position
    static func isNegative(for items: [String],at index : Int) -> Bool {
        if items.count <= index {
            fatalError("isNegative index out of bounds")
        }
        let item = items[index]
        if (index == 0 && item == "-") || (item == "-" && items[index - 1] == "(") {
            return true
        }
        return false
    }

    
    /// is basic operators or not
    /// - Parameter c: the character to compare
    static func isMathSymbol(_ c : String) -> Bool {
        let symbols = ["+","-","×","÷"]
        return symbols.contains(c)
    }
        
    /// Mathematical symbol priority comparison
    /// if lhs `>` rhs return true
    /// - Parameters:
    ///   - lhs: lhs
    ///   - rhs: rhs
    static func isPriorityLargerThan(lhs : String,rhs : String) -> Bool {
        if (lhs == "×" || lhs == "÷" || lhs == "+" || lhs == "-") && (rhs == "(" || rhs == ")"){
            return true
        }
        
        if (lhs == "×" || lhs == "÷") && (rhs == "+" || rhs == "-") {
            return true
        } else {
            return false
        }
    }
    
    /// is `(` or not
    /// - Parameter c: the character to compare
    static func isLeftBracket(_ c : String) -> Bool {
        return c == "("
    }
    
    
    /// is `)` or not
    /// - Parameter c: the character to compare
    static func isRightBracket(_ c : String) -> Bool {
        return c == ")"
    }
    
    /// is `×` or not
    /// - Parameter c: the character to compare
    static func isMultiply(_ c : String) -> Bool {
        return c == "×"
    }
    
    /// is `÷` or not
    /// - Parameter c: the character to compare
    static func isDivede(_ c : String) -> Bool {
        return c == "÷"
    }
    
    /// is `+` or not
    /// - Parameter c: the character to compare
    static func isPlus(_ c : String) -> Bool {
        return c == "+"
    }
    
    /// is `-` or not
    /// - Parameter c: the character to compare
    static func isMinus(_ c : String) -> Bool {
        return c == "-"
    }
    
    /// is `.` or not
    /// - Parameter c: the character to compare
    static func isDot(_ c : String) -> Bool {
        return c == "."
    }
}

/// MARK: Reverse Polish notation algorithm
extension Algorithm {
    public struct ReversePolishNotation {
        /// Reverse Polish notation algorithm : 逆波兰算法
        /// transform from ShuntingYard.excute(["5","+","(","(","1","+","2",")","x","4",")","-","3"]) into "14"
        /// items must be an obj that beening transformed from `ShuntingYard` algorithm first
        /// - Parameter items: transformed result from ShuntingYard
        public static func excute(for items : [String]) -> ResultValue {
            if items.isEmpty {
                return .success("0")
            }
            
            var resStack = Stack<String>()
            
            for item in items {
                if isDigitValue(for: item) {
                    resStack.push(item)
                } else if isMathSymbol(item) {
                    if resStack.size > 1 {
                        let pop1 = resStack.pop()!
                        let pop2 = resStack.pop()!
                        
                        let resultDigit1 = Double(pop1)!
                        let resultDigit2 = Double(pop2)!
                        
                        var result : String = ""
                        if isPlus(item) {
                            result = String("\(resultDigit2 + resultDigit1)")
                        } else if isMinus(item) {
                            result = String("\(resultDigit2 - resultDigit1)")
                        } else if isMultiply(item) {
                            result = String("\(resultDigit2 * resultDigit1)")
                        } else if isDivede(item) {
                            if resultDigit1 == 0 {
                                return .failure(.input)
                            }
                            result = String("\(resultDigit2 / resultDigit1)")
                        }
                        resStack.push(result)
                    } else {
                        print("resStack 小于等于1")
                    }
                } else {
                    return .failure(.output)
                }
            }
            
            if resStack.size == 1 {
                return .success(resStack.peek!)
            }
            
            return .failure(.output)
        }
    }
}
/// MARK:  ShuntingYard
extension Algorithm {
    public struct ShuntingYard {
        /// Shunting Yard Algorithm : 调度场算法将中缀表达式转换为后缀表达式
        /// Theory :
        /// https://zh.wikipedia.org/wiki/%E8%B0%83%E5%BA%A6%E5%9C%BA%E7%AE%97%E6%B3%95
        /// https://www.jianshu.com/p/8b38f61693b9
        /// https://www.cnblogs.com/magisk/p/8620303.html
        /// transform characters from ["3","+","4"] into ["3","4","+"]
        public static func excute(for characters : [String]) -> [String] {
            if characters.isEmpty {
                return []
            }
            
            var opStack = Stack<String>()
            var resultList : [String] = []
            
            func recursiveBracket(for item : String) {
                if let peek = opStack.peek {
                    if isLeftBracket(peek) {
                        opStack.pop()
                        return
                    }

                    if isMathSymbol(peek) {
                        opStack.pop()
                        resultList.append(peek)
                    }
                    recursiveBracket(for: item)
                }
            }
            
            func recursiveMathSymbol(for item : String) {
                if let peek = opStack.peek {
                    if isPriorityLargerThan(lhs: item, rhs: peek) {
                        opStack.push(item)
                    } else {
                        opStack.pop()
                        resultList.append(peek)
                        recursiveMathSymbol(for: item)
                    }
                } else {
                    opStack.push(item)
                }
            }
            
            var newCharacters = characters
            /// prevent first is +  ×  ÷
            if let first = characters.first,isDot(first) {
                newCharacters.removeFirst()
            }
            
            /// prevent last + - × ÷
            if let last = characters.last,isMathSymbol(last) {
                newCharacters.removeLast()
            }
            
            for (index,item) in newCharacters.enumerated() {
                if isNegative(for: newCharacters, at: index) {
                    resultList.append("0")
                    opStack.push(item)
                } else if isDigitValue(for:item) {
                    resultList.append(item)
                } else if isMathSymbol(item) {
                    recursiveMathSymbol(for: item)
                } else if isLeftBracket(item) {
                    opStack.push(item)
                } else if isRightBracket(item) {
                    recursiveBracket(for: item)
                }
            }
            
            for el in opStack.elements.reversed() {
                resultList.append(el)
            }
            
            opStack.removeAll()
            
            return resultList
        }
    }
}
