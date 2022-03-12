//
//  ContentView.swift
//  SwiftUnicodePicker
//
//  Created by Claes Wihlborg on 2021-03-21.
//

/*
 The MIT License (MIT)

 Copyright (c) 2021 Claes Wihlborg

 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify,
 merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import SwiftUI

// some useful constants
let lightRed = Color(red: 1.0, green: 0.9, blue: 0.9, opacity: 1.0)
let lightBlue = Color(red: 0.92, green: 0.95, blue: 1.0, opacity: 1.0)
let rubrikrad = UnicodeTableRow(0,0, [48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70])


struct ContentView: View {
    @ObservedObject var model: MyModel

    var body: some View {
        MainView()
            .environmentObject(model)
    }
    init(_ model: MyModel) {
        self.model = model
    }
}


struct MainView: View {
    @EnvironmentObject var model: MyModel
    var body: some View {
        VStack{
            HStack{
                TabellRad(row:rubrikrad)
                    .padding(.trailing)
            }
            .padding(.top)
            .padding(.horizontal)
            List(model.dataSource.unicodeTable){ row in
                if row.base == 0 {
                    RubrikRad(row:row)
                }
                else {
                    TabellRad(row:row)
                }
            }
            BottomView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(MyModel(true))
    }
}


struct UChar: View {
    @EnvironmentObject var model: MyModel
    let iChar: UInt32
    let uChar: String
    var body: some View {
        Text(uChar)
            .font(.title3)
            .multilineTextAlignment(.leading)
            .frame(width: 25.0)
            .background( model.dataSource.specialCodepoints[iChar] != nil ? lightRed :
                            model.dataSource.otherCharacters.contains(iChar) ? lightBlue :
                            Color(white: 1.0, opacity: 0.0)
            )
            .onTapGesture {
                switch model.clickAction {
                case .pasteBack: model.performPasteBack(uChar)
                case .setFirstButtonChar:
                    model.defButton(uChar)
                    model.clickAction = .setNextButtonChar
                case .setNextButtonChar:
                    model.addButton(uChar)
                }
            }
            .help(model.toolTip(iChar))
    }
    init(_ iChar: UInt32) {
        self.iChar = iChar
        uChar = String(Unicode.Scalar(iChar)!)
    }
}

struct QuarterLine: View {
    let base: Int
    let row: UnicodeTableRow
    var body: some View {
        HStack{
            Spacer()
            UChar(row.chars[base+0])
            Spacer()
            UChar(row.chars[base+1])
            Spacer()
            UChar(row.chars[base+2])
            Spacer()
            UChar(row.chars[base+3])
        }
    }
    init(_ base: Int, _ row: UnicodeTableRow) {
        self.base = base
        self.row = row
    }
}

struct TabellRad: View {
    let row: UnicodeTableRow
    var body: some View {
        HStack(alignment: .center){
            Text(row.base > 0 ? String(format:"%05X", row.base) : "")
                .multilineTextAlignment(.center)
                .frame(width: 55.0)
            QuarterLine(0,row)
            QuarterLine(4,row)
            QuarterLine(8,row)
            QuarterLine(12,row)
        }
    }
}

struct RubrikRad: View {
    @EnvironmentObject var model: MyModel
    let row: UnicodeTableRow
    var body: some View {
        HStack{
            Spacer()
            Text(row.segment < model.dataSource.blockTable.count ? model.dataSource.blockTable[row.segment].title : "")
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.top)
            Spacer()
        }
    }
}

struct BottomView: View {
    @EnvironmentObject var model: MyModel
    var body: some View {
        VStack{
            if model.clickAction != ClickAction.pasteBack {
                if model.clickAction == ClickAction.setFirstButtonChar {
                    HStack{
                        Spacer()
                        Text("Select button character")
                        Spacer()
                    }
                    .animation(Animation.`default`)
                }
                if model.clickAction == ClickAction.setNextButtonChar {
                    HStack{
                        Spacer()
                        Text("Select next button character or tab on button to save text")
                        Spacer()
                    }
                    .animation(Animation.`default`)
                }
            }
            HStack {
                Spacer()
                CharButton(0)
                CharButton(1)
                CharButton(2)
                CharButton(3)
                CharButton(4)
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                CharButton(5)
                CharButton(6)
                CharButton(7)
                CharButton(8)
                CharButton(9)
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

struct CharButton: View {
    @EnvironmentObject var model: MyModel
    let buttonNr: Int
    var body: some View {
        Button(model.buttonString(buttonNr),
               action: {
            if model.clickAction == .pasteBack {
                let s = model.buttonStrings[buttonNr]
                if s.count > 0 {
                    model.performPasteBack(s)
                }
            }
            else  {
                model.clickAction = .pasteBack
            }
        })
        .frame(minWidth: 50.0)
        .controlSize(ControlSize.large)
        .font(Font.system(size: 16))
        .padding(.horizontal)
        .disabled((model.clickAction != .pasteBack) && (buttonNr != model.currentlyChangedButtonNr)
        )
    }
    init(_ buttonNr: Int) {
        self.buttonNr = buttonNr
    }
}

