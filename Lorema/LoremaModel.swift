//
//  LoremaModel.swift
//  Lorema
//
//  Created by Daniel Danielsson on 2022-04-20.
//

import SwiftUI
import Foundation

class LoremaModel: ObservableObject{
    
    @Published var text = ""
    static let sharedInstance = LoremaModel()
    var CGEventTap = CGEventTapAction()
    
    var currentLoremPrefix : String = UserDefaults.standard.value(forKey: "loPrefix") == nil ? Structures.LOREM_TP : UserDefaults.standard.value(forKey: "loPrefix") as! String
    
    var currentLoraPrefix : String = UserDefaults.standard.value(forKey: "laPrefix") == nil ? Structures.LORA_TP : UserDefaults.standard.value(forKey: "laPrefix") as! String
    
    // MARK: - Init
    init(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidChangePrefix(notification:)), name: NSNotification.Name(rawValue: "didChangePrefixes"), object: nil)
        
        CGEventTap.start { text in
            self.text = text
            self.matchSnippet()
        }
    }
    
    @objc func handleDidChangePrefix(notification: Notification) {
        if let preferredLorem = UserDefaults.standard.value(forKey: "loPrefix") as? String {
            
            
            
            currentLoremPrefix = preferredLorem
        }
        if let preferredLora = UserDefaults.standard.value(forKey: "laPrefix") as? String {
            currentLoraPrefix = preferredLora
        }
    }
    
    // MARK: - Match expressions
    func matchSnippet(){
        
        if(self.text.range(of: "\(String(describing: currentLoremPrefix))+(?:[1-9][0-9]*){1,\(Structures.MAX_NUMBER_LENGTH)}+[ ]", options: .regularExpression) != nil ){
            if let number = Int.parse(from: String(self.text.components(separatedBy: currentLoremPrefix).last!)) {
                insertText(number, currentLoremPrefix as String)
            }
        }
        
        else if(self.text.range(of: "\(String(describing: currentLoraPrefix))+(?:[1-9][0-9]*){1,\(Structures.MAX_NUMBER_LENGTH)}+[ ]", options: .regularExpression) != nil ){
            
            if let number = Int.parse(from: String(self.text.components(separatedBy: currentLoraPrefix).last!)) {
                insertText(number, currentLoraPrefix as String)
            }
        }
    }
    
    // MARK: - Insert text
    func insertText(_ amountOfWords: Int,_ type: String ){
        let charactersToDelete : Int = numberOfDigits(amountOfWords) + type.count + 1;

        var i : Int = 0
        while (i < charactersToDelete) {
            self.delete()
            i += 1
        }

        let mode: GenerationMode = (type == currentLoremPrefix) ? .lorem : .random
        let result = TextGenerator.generate(wordCount: amountOfWords, mode: mode)

        let oldClipboard = NSPasteboard.general.string(forType: .string)
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(result, forType: .string)
        paste()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let oldClipboard = oldClipboard {
                NSPasteboard.general.setString(oldClipboard, forType: .string)
            }
        }
    }
    
    // MARK: - Hit delete key
    func delete() {
        let eventSource = CGEventSource(stateID: .combinedSessionState)

        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: true)

        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: false)

        let loc = CGEventTapLocation.cghidEventTap

        keyDownEvent?.post(tap: loc)
        keyUpEvent?.post(tap: loc)
    }
    
    // MARK: - Hit cmd + v
    func paste() {

        let keyCode = CGKeyCode(9)

        let eventSource = CGEventSource(stateID: .combinedSessionState)

        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey:  keyCode,
            keyDown: true)

        keyDownEvent?.flags.insert(.maskCommand)

        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey:  keyCode,
            keyDown: false)

        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    // MARK: - Number of digits
    func numberOfDigits(_ number: Int) -> Int {
        if number < 10 && number >= 0 || number > -10 && number < 0 {
            return 1
        } else {
            return 1 + numberOfDigits(number/10)
        }
    }
}

// MARK: - Minor extensions

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

