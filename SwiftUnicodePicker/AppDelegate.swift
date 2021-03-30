//
//  AppDelegate.swift
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


import Carbon
import SwiftUI


var appPath:String = ""
var pid: pid_t = 0

func handler(hcr: EventHandlerCallRef?, er: EventRef?, data: UnsafeMutableRawPointer?)->OSStatus {
    for nra in NSWorkspace.shared.runningApplications {
        if (nra.isActive) {
            pid = nra.processIdentifier;
            break;
        }
    }
    NSWorkspace.shared.openApplication(at: URL(fileURLWithPath:appPath), configuration: NSWorkspace.OpenConfiguration())
    return 0
}


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var theModel: MyModel!
    var window: NSWindow!

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        _=verifyUnicodeBlocks()
//        _=verifyCodepoints()
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        theModel.window = window
        theModel.showOperatorsX()
        window.isReleasedWhenClosed = false
        window.center()
        window.title = "Swift Unicode Picker"
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: ContentView(theModel))
        window.makeKeyAndOrderFront(nil)
        installHotKeyHandler()

    }

    func fetchHotKeyDef()->(keyCode:UInt32, keyFlags: UInt32) {
        let code = UserDefaults.standard.integer(forKey: "HotKeyCode")
        let flags = UserDefaults.standard.integer(forKey: "HotKeyFlags")
        return (keyCode: UInt32(code != 0 ? code : kVK_ANSI_U),
                keyFlags: UInt32(flags != 0 ? flags : controlKey | shiftKey)) // Default = ^⇧U
    }

    func installHotKeyHandler() {

        appPath = NSRunningApplication.current.bundleURL!.path;
        let hotKeyDef = fetchHotKeyDef()

        var eventType = EventTypeSpec(eventClass:OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        let eventId = EventHotKeyID(signature: OSType(Unicode.Scalar("💔")), id: 1);

        InstallEventHandler(GetApplicationEventTarget(), handler,  1, &eventType, nil, nil )

        var hotKeyRef: EventHotKeyRef?

        RegisterEventHotKey(hotKeyDef.keyCode, hotKeyDef.keyFlags, eventId, GetApplicationEventTarget(), 0, &hotKeyRef);
    }

    @IBAction func showHelp(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "http://www.dromeda.se/SwiftUnicodePicker/Manual/")!)
    }

    @IBAction func showSourceCode(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://github.com/clwi/Swift-Unicode-Picker")!)
    }
}

