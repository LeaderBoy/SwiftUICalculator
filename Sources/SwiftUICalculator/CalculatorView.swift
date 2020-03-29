//
//  CalculatorView.swift
//  SwiftUICalculator
//
//  Created by 杨 on 2020/3/23.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import SwiftUI
import AudioToolbox

@available(iOS 13.0,*)
public struct CalculatorView: View {
    
    @EnvironmentObject var model : CalculatorModel
    
    var items : [[KeyboardItem]] = [
        [.command(.clear),.command(.delete),.command(.percent),.operation(.divide)],
        [.digit(7),.digit(8),.digit(9),.operation(.multiply)],
        [.digit(4),.digit(5),.digit(6),.operation(.minus)],
        [.digit(1),.digit(2),.digit(3),.operation(.plus)],
        [.digit(0),.dot,.command(.equal)]
    ]
            
    private let soundID : SystemSoundID = 1104
    
    public init() {}
    
    public var body: some View {
        GeometryReader { reader in
            VStack(spacing:10) {
                ForEach(self.items,id: \.self) { row in
                    HStack {
                        ForEach(row,id: \.self) { column in
                            Button(action: {
                                self.buttonAction(at: column)
                            }) {
                                /// https://stackoverflow.com/questions/56509640/how-to-set-custom-highlighted-state-of-swiftui-button
                                /// For button highlight
                                /// We need to set text frame and background rather than button frame and background
                                self.buttonContent(at: column)
                                .foregroundColor(column.textColor)
                                    .frame(width: column.itemSize(in:reader.size,spacing:10).width, height: column.itemSize(in:reader.size,spacing:10).height)
                                .background(column.itemColor)
                            }
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
    
    func buttonContent(at column : KeyboardItem) -> some View {
        HStack {
            if column == .command(.delete) {
                Image(systemName: "delete.left")
            } else {
                Text(column.title)
            }
        }
    }
    
    func buttonAction(at item : KeyboardItem) {
        /// play sound
        AudioServicesPlayAlertSoundWithCompletion(self.soundID, nil)
        ///
        self.model.append(item: item)
    }
}

@available(iOS 13.0,*)
struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculatorView()
        }
    }
}

