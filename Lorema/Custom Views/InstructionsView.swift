import Cocoa

class InstructionsView: NSView, LoadableView {

// MARK: - IBOutlet Properties
    @IBOutlet weak var instructionLoremText: NSTextField!
    @IBOutlet weak var loremPrefix: NSTextField!
    @IBOutlet weak var loremWordSpace: NSTextField!
    @IBOutlet weak var loraWordSpace: NSTextField!
    @IBOutlet weak var instructionLoraText: NSTextField!
    @IBOutlet weak var loraPrefix: NSTextField!
    
// MARK: - Init
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        _ = load(fromNIBNamed: "InstructionsView")
        
        loremPrefix.stringValue = (UserDefaults.standard.value(forKey: "loPrefix") as? String)!
        loraPrefix.stringValue = (UserDefaults.standard.value(forKey: "laPrefix") as? String)!
        loremWordSpace.stringValue = "+ number of words + space"
        loraWordSpace.stringValue = "+ number of words + space"
        instructionLoremText.stringValue = "Text starting with \"Lorem ipsum\", type:"
        instructionLoraText.stringValue = "Random text, type:"
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidChangePrefix(notification:)), name: NSNotification.Name(rawValue: "didChangePrefixes"), object: nil)
    }
    
    @objc func handleDidChangePrefix(notification: Notification) {
        if let preferredLorem = UserDefaults.standard.value(forKey: "loPrefix") as? String {
            loremPrefix.stringValue = preferredLorem
        }
        
        if let preferredLora = UserDefaults.standard.value(forKey: "laPrefix") as? String {
            loraPrefix.stringValue = preferredLora
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
