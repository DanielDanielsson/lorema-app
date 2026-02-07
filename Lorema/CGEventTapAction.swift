import Cocoa

final class CGEventTapAction {

    private var runState: RunState? = nil
    private var text = ""

    private struct RunState {
        let port: CFMachPort
        let setStatus: (String) -> Void
    }

    func start(_ setStatus: @escaping (String) -> Void) {
        precondition(self.runState == nil)

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
            Unmanaged<CGEventTapAction>.fromOpaque(info).release()
            setStatus("Failed to create event tap.")
            return
        }
        let rls = CFMachPortCreateRunLoopSource(nil, port, 0)!
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, .defaultMode)
        self.runState = RunState(port: port, setStatus: setStatus)
    }

    private func didReceiveEvent(_ event: CGEvent) {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

        if keyCode == 51 && !self.text.isEmpty {
            self.text.removeLast()
        } else if keyCode > 100 {
            self.text = ""
        } else {
            guard let nsevent = NSEvent(cgEvent: event),
                  let char = nsevent.charactersIgnoringModifiers else { return }

            if self.text.count >= Structures.MAX_CHAR_LENGTH + Structures.MAX_NUMBER_LENGTH + 1 {
                self.text.removeFirst()
            }
            self.text += char
        }

        guard let runState = self.runState else { return }
        runState.setStatus(self.text)
    }

    func stop() {
        guard let runState = self.runState else { return }
        self.runState = nil
        CFMachPortInvalidate(runState.port)
        Unmanaged.passUnretained(self).release()
    }
}
