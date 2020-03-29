//
//  CalculatorModel.swift
//  SwiftUICalculator
//
//  Created by 杨 on 2020/3/23.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI
import Combine

public class CalculatorModel: ObservableObject {

    @Published public var calculator : Calculator = .input("0")
    
    public var history : String {
        return calculator.history
    }
    
    public var output : String  {
        return calculator.output
    }
    
    public func append(item : KeyboardItem) {
        calculator = calculator.append(item: item)
    }
}
