import Foundation
import SwiftUI

final class CGEventTapAction {

    private var runState: RunState? = nil
    
    @Published var text = ""
    
    private struct RunState {
        let port: CFMachPort
        let setStatus: (String) -> Void
    }
    
    func start(_ setStatus: @escaping (String) -> Void) {
        precondition(self.runState == nil)
        
        print("will create tap")
        let info = Unmanaged.passRetained(self).toOpaque()
        let mask = CGEventMask(1 << CGEventType.keyDown.rawValue)
        guard let port = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { (proxy, type, event, info) -> Unmanaged<CGEvent>? in
                let obj = Unmanaged<CGEventTapAction>.fromOpaque(info!).takeUnretainedValue()
                obj.didReceiveEvent(event)
                return Unmanaged.passUnretained(event)
            },
            userInfo: info
        ) else {
            print("did not create tap")
            Unmanaged<CGEventTapAction>.fromOpaque(info).release()
            setStatus("Failed to create event tap.")
            return
        }
        let rls = CFMachPortCreateRunLoopSource(nil, port, 0)!
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, .defaultMode)
        self.runState = RunState(port: port, setStatus: setStatus)
        print("did create tap")
    }
    
    private func didReceiveEvent(_ event: CGEvent) {
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        
        guard let nsevent = NSEvent(cgEvent: event) else { return }
        
        let char = nsevent.charactersIgnoringModifiers;
        
        if(self.text.count >= Structures.MAX_CHAR_LENGTH + Structures.MAX_NUMBER_LENGTH + 1){
            self.text.removeFirst()
        }
        
        if keyCode == 51 && !self.text.isEmpty{
            self.text.removeLast()
        } else if keyCode > 100 {
            self.text = ""
        }else{
            self.text += char!
        }
        
        guard let runState = self.runState else { return }
        runState.setStatus(self.text)
    }

    func stop() {
        guard let runState = self.runState else { return }
        self.runState = nil

        print("will stop tap")
        CFMachPortInvalidate(runState.port)
        Unmanaged.passUnretained(self).release()
        print("did stop tap")
    }
    

}

extension NSEvent{
    var isDelete: Bool{
        keyCode == 51
    }
}
