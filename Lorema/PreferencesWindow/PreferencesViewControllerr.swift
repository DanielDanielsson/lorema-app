import Cocoa
import ServiceManagement
import LaunchAtLogin

class PreferencesViewControllerr: NSViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var prefixInstructionTextLorem: NSTextField!
    @IBOutlet weak var loremInput: NSTextField!
    @IBOutlet weak var prefixInstructionTextLora: NSTextField!
    @IBOutlet weak var loraInput: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var startAtLogin: NSButton!
    @IBOutlet weak var appVerision: NSTextField!
    
    @IBAction func toggleCheckbox(_ sender: Any) {
    
        if(LaunchAtLogin.isEnabled){
            
            startAtLogin.state = .off
            LaunchAtLogin.isEnabled = false
        }else{
            startAtLogin.state = .on
            LaunchAtLogin.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        
        loadSettings()
        if UserDefaults.standard.value(forKey: "loPrefix") == nil {
            UserDefaults.standard.setValue("lorem", forKey: "loPrefix")
        }
        
        if UserDefaults.standard.value(forKey: "laPrefix") == nil {
            UserDefaults.standard.setValue("lora", forKey: "laPrefix")
        }
        
        if let loremInput = loremInput {
            loremInput.delegate = self
        }
        
        if let loraInput = loraInput {
            loraInput.delegate = self
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    func setTexts() {
        prefixInstructionTextLorem.stringValue = "Prefix for text starting with \"Lorem ipsum\":"
        prefixInstructionTextLora.stringValue = "Prefix for random text:"
        errorMessage.stringValue = ""
        startAtLogin.stringValue = "Start Lorema at login"
        appVerision.stringValue = "Verision: " + PreferencesViewControllerr.appVersion!
    }
    
    func loadSettings() {
        loremInput.stringValue = (UserDefaults.standard.value(forKey: "loPrefix") as? String)!
        loraInput.stringValue = (UserDefaults.standard.value(forKey: "laPrefix") as? String)!

        if (LaunchAtLogin.isEnabled) {
            startAtLogin.state = .on
        }else{
            startAtLogin.state = .off
        }
        loremInput.focusRingType = .none
        loraInput.focusRingType = .none
    }
    
    static var appVersion: String? {
       return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static var buildVersion: String? {
       return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}

// MARK: - Extension text field delegate
extension PreferencesViewControllerr: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        var hasError = validateInputs()

        switch (hasError) {
          case true:
            loremInput.stringValue = (UserDefaults.standard.value(forKey: "loPrefix") as? String)!
            loraInput.stringValue = (UserDefaults.standard.value(forKey: "loPrefix") as? String)!
            hasError = false
          case false:
            if control is NSTextField {
                UpdateGlobalPrefixes()
            }
        }
        return true
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if (!validateInputs()){
            UpdateGlobalPrefixes()
        }
        
        if let window = loremInput.window, window.firstResponder == loremInput {
            _ = validateInputs()
        }
    }
    
    func validateInputs() -> Bool {
        
        if((loremInput.stringValue.range(of: ".*[^A-Za-z].*", options: .regularExpression) != nil) || (loraInput.stringValue.range(of: ".*[^A-Za-z].*", options: .regularExpression) != nil) ){
            errorMessage.stringValue = "No special characters or numbers allowed"
            return true;
        }
        
        if(loremInput.stringValue.count <= 1 || loraInput.stringValue.count <= 1) {
            errorMessage.stringValue = "Minimum length is two characters"
            return true;
        }
        
        if(loremInput.stringValue.count > Structures.MAX_CHAR_LENGTH || loraInput.stringValue.count > Structures.MAX_CHAR_LENGTH) {
            errorMessage.stringValue = "Maximum length is \(Structures.MAX_CHAR_LENGTH) characters"
            return true;
        }
        
        if(loremInput.stringValue.contains(loraInput.stringValue)){
            errorMessage.stringValue = "One prefix can't trigger the other."
            return true;
        }
        
        else{
            errorMessage.stringValue = ""
            return false;
        }
    }
    
    func UpdateGlobalPrefixes() {
        UserDefaults.standard.setValue(loremInput.stringValue, forKey: "loPrefix")
        UserDefaults.standard.setValue(loraInput.stringValue, forKey: "laPrefix")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangePrefixes"), object: nil )
    }
}
