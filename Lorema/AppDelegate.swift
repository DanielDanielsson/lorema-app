import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var instructionsView: InstructionsView?
    var noPermissionView: NoPermissionView?
    var preferencesController: NSWindowController?
    
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    @IBAction func openURL(_ sender: AnyObject) {
        NSWorkspace.shared.open(NSURL(string: "https://github.com/DanielDanielsson/lorema-app")! as URL)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        
        if !(preferencesController != nil) {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Preferencess"), bundle: nil)
            preferencesController = storyboard.instantiateInitialController() as? NSWindowController
        }
        
        if (preferencesController != nil ){
            preferencesController!.showWindow(sender)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let loremaIcon = NSImage(named: "loremaMenuIcon")
        loremaIcon?.isTemplate = true
        statusItem?.button?.image = loremaIcon
        
        if UserDefaults.standard.value(forKey: "loPrefix") == nil {
            UserDefaults.standard.setValue(Structures.LOREM_TP, forKey: "loPrefix")
        }
        
        if UserDefaults.standard.value(forKey: "laPrefix") == nil {
            UserDefaults.standard.setValue(Structures.LORA_TP, forKey: "laPrefix")
        }
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        updateNibView(hasPermission: false)
    }
    
    func updateNibView(hasPermission: Bool) {
        if let item = firstMenuItem {
            if hasPermission {
                instructionsView = InstructionsView(frame: NSRect(x: 0.0, y: 0.0, width: 310.0, height: 120.0))
                item.view = instructionsView
            } else {
                noPermissionView = NoPermissionView(frame: NSRect(x: 0.0, y: 0.0, width: 370.0, height: 200.0))
                item.view = noPermissionView
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if UserDefaults.standard.value(forKey: "loPrefix") == nil {
            UserDefaults.standard.setValue(Structures.LOREM_TP, forKey: "loPrefix")
        }
        
        if UserDefaults.standard.value(forKey: "laPrefix") == nil {
            UserDefaults.standard.setValue(Structures.LORA_TP, forKey: "laPrefix")
        }
        
        checkPermission()
    }
    
    func checkPermission(){
        let allowed = AXIsProcessTrusted()

        if(!allowed){
            CGRequestPostEventAccess()
            
            DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name("com.apple.accessibility.api"), object: nil, queue: nil) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    if(AXIsProcessTrusted()){
                        self.updatePrivileges()
                    }
                }
            }
            
        }else{
            _ = LoremaModel.sharedInstance
            updateNibView(hasPermission: true)
        }
    }
    
    func updatePrivileges(){
        updateNibView(hasPermission: true)
        _ = LoremaModel.sharedInstance
    }
}






