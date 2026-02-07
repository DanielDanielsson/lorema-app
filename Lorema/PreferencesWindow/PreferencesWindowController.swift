//
//  PreferencesWindowController.swift
//  Lorema
//
//  Created by Daniel Danielsson on 2022-05-22.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.level = .floating
        self.window?.center()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        self.window?.orderOut(sender)
        return false
    }

}
