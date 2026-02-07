import Cocoa

class NoPermissionView: NSView, LoadableView {
    
    @IBOutlet weak var instructionText: NSTextField!
    @IBOutlet weak var settingsPathText: NSTextField!
    
    @IBAction func goToSettings(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "NoPermissionView")

        instructionText.stringValue = "In order for Lorema to run, you need to allow accessability permission in the security & privacy settings."
        settingsPathText.stringValue = "System Preferences > Security & Privacy > Accessibility, then add and checkmark Lorema."
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
