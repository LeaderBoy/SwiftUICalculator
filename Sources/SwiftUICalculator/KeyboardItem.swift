//
//  KeyboardItem.swift
//  SwiftUICalculator
//
//  Created by 杨 on 2020/3/23.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI

public enum KeyboardItem {
    public enum MathOperation : String {
        case plus       = "+"
        case minus      = "-"
        case multiply   = "×"
        case divide     = "÷"        
    }
    
    public enum Command : String {
        case clear = "AC"
        case delete = "􀆛"
        case percent = "%"
        case equal   = "="
    }
    
    case digit(Int)
    case dot
    case operation(MathOperation)
    case command(Command)
}


extension KeyboardItem : CustomStringConvertible,CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }

    public var debugDescription: String {
        switch self {
        case .digit(let num):
            return String("\(num)")
        case .dot:
            return "."
        case .operation(let opera):
            return opera.rawValue
        case .command(let cmd):
            return cmd.rawValue
        }
    }
}

extension KeyboardItem : Hashable {}

extension KeyboardItem {
    var title : String {
        switch self {
        case .digit(let value):
            return "\(value)"
        case .dot:
            return "."
        case .operation(let op):
            return op.rawValue
        case .command(let cm):
            return cm.rawValue
        }
    }
    
    var itemColor : Color {
        switch self {
        case .command(.equal):
            return Color(hex:"#EAAA44")
        default:
            return Color(hex:"#F7F4F8")
        }
    }
    
    var textColor : Color {
        switch self {
        case .command(.equal):
            return .white
        default:
            return .black
        }
    }
    
    func itemSize(in size: CGSize,spacing: CGFloat) -> CGSize {
        let maxHeight : CGFloat = 50
        switch self {
        case .digit(0):
            let h = (size.width - spacing * 3) / 4.0
            let w = (size.width - spacing * 3) / 4.0 * 2 + spacing
            
            return CGSize(width: w, height: min(h, maxHeight))
        default:
            let w = (size.width - spacing * 3) / 4.0
            return CGSize(width: w, height: min(w, maxHeight))
        }
    }
}


extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}
