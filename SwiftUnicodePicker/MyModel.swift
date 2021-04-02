//
//  MyModel.swift
//  SwiftUnicodePicker
//
//  Created by Claes Wihlborg on 2021-03-25.
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



import Cocoa


enum ClickAction {
    case pasteBack, setFirstButtonChar, setNextButtonChar
}

enum UnicodeSet {
    case nothiingSet, operatorSet, identifierSet
}


class MyModel: NSObject, ObservableObject {

    @Published var buttonStrings: [String] = []
    @Published var clickAction: ClickAction = ClickAction.pasteBack
    @Published var currentlyChangedButtonNr: Int = -1

    @Published var dataSource: MyDataSource = MyDataSource()

    var chooseOp: Bool = true
    var window: NSWindow!

    

    func defButton(_ str: String) {
        buttonStrings[currentlyChangedButtonNr] = str
        UserDefaults.standard.set(buttonStrings, forKey: chooseOp ? "Operators" : "Identifiers" )
    }

    func addButton(_ str: String) {
        self.defButton(buttonStrings[currentlyChangedButtonNr]+str)
    }

    func buttonString(_ ix: Int)->String {
        let a: Int = (16 - 3*buttonStrings[ix].count) / 2
        switch a {
        case  8: return "                "
        case  7: return "       " + buttonStrings[ix] + "       "
        case  6: return "      " + buttonStrings[ix] + "      "
        case  5: return "     " + buttonStrings[ix] + "     "
        case  4: return "    " + buttonStrings[ix] + "    "
        case  3: return "   " + buttonStrings[ix] + "   "
        case  2: return "  " + buttonStrings[ix] + "  "
        case  1: return " " + buttonStrings[ix] + " "
        default: return buttonStrings[ix]
        }
    }

    func toolTip(_ iChar: UInt32)->String {
        if iChar == 0 {
            return "You find nothing here" }
        var s: String = ""
        if let name = Unicode.Scalar(iChar)?.properties.name {
            s = name + "\n"
        }
        s += "UTF8:"
        let u8 = String(Unicode.Scalar(iChar)!).utf8CString
        for u in u8 {
            if u != 0 {
                s += " " + String(format: "%02x", Int(u) & 0x0ff)
            }
        }
        if dataSource.specialCodepoints.keys.contains(iChar) {
            s += "\n" + dataSource.specialCodepoints[iChar]!
        }
        if dataSource.otherCharacters.contains(iChar) {
            s += "\nMust NOT be used as first character in " + (chooseOp ? "operator" : "identifier")
        }
        return s
    }

    func performPasteBack(_ string:String) {
        // put string on clipboard
        let pb = NSPasteboard.general
        pb.declareTypes([NSPasteboard.PasteboardType.string], owner:nil)
        pb.setString(string, forType:NSPasteboard.PasteboardType.string)
        let pidApp = NSRunningApplication.current;
        pidApp.hide()

        // paste on next app
        self.perform(#selector(postToPidCommand), with: nil, afterDelay: 0.1)

        return;
    }

    @objc   func postToPidCommand() {
        let virtualKey: CGKeyCode = 9 // kVK_ANSI_V
        let source = CGEventSource(stateID: CGEventSourceStateID.combinedSessionState);
        if source != nil
        {
            let copyDownKeyboardEvent = CGEvent(keyboardEventSource: source, virtualKey: virtualKey, keyDown: true); // kVK_ANSI_C
            if let cdke = copyDownKeyboardEvent
            {
                cdke.flags = CGEventFlags.maskCommand;
                let copyUpKeyboardEvent = CGEvent(keyboardEventSource: source, virtualKey: virtualKey, keyDown: false);
                if let cuke = copyUpKeyboardEvent
                {
                    cdke.postToPid(pid);
                    cuke.postToPid(pid);
                }
            }
        }
        pid = 0
    }

//    UserDefaults.standard.set("mynameisben", forKey: "username")
//    let userName = UserDefaults.standard.string(forKey: "username")

    @IBAction func showOperators(_ sender: NSMenuItem) {
        self.showOperatorsX()
    }

     func showOperatorsX() {
        window.subtitle = "Operators"
        chooseOp = true
        UserDefaults.standard.set(chooseOp, forKey: "SelectedView")
        dataSource = operatorDataSource
        clickAction = ClickAction.pasteBack
        currentlyChangedButtonNr = -1
        let b = UserDefaults.standard.stringArray(forKey: "Operators")
        if b != nil {
            buttonStrings = b!
        }
        else {
            buttonStrings = ["","","","","","","","","",""]
        }
    }

    @IBAction func showIdentifiers(_ sender: NSMenuItem) {
        self.showIdentifiersX()
    }

     func showIdentifiersX() {
        window.subtitle = "Identifiers"
        chooseOp = false
        UserDefaults.standard.set(chooseOp, forKey: "SelectedView")
        dataSource = identifierDataSource
        clickAction = ClickAction.pasteBack
        currentlyChangedButtonNr = -1
        let b = UserDefaults.standard.stringArray(forKey: "Identifiers")
        if b != nil {
            buttonStrings = b!
        }
        else {
            buttonStrings = ["","","","","","","","","",""]
        }
    }

    @IBAction func clickButton(_ sender: NSMenuItem) {
        let ix = sender.tag
        performPasteBack(buttonStrings[ix])
    }

    @IBAction func defineButton(_ sender: NSMenuItem) {
        let ix = sender.tag
        currentlyChangedButtonNr = ix;
        buttonStrings[ix] = ""
        clickAction = ClickAction.setFirstButtonChar;
    }


    convenience init(_ chooseOp: Bool) {
        self.init()
        if chooseOp {
            self.showOperatorsX()
        }
        else {
            self.showIdentifiersX()
        }
    }
}
