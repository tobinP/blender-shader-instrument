
import GameController

class PadMan: ObservableObject{
    let socketMan: SocketMan
    let encoder = JSONEncoder()

    init(_ socketMan: SocketMan) {
        self.socketMan = socketMan
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil, using: didConnectController)
        GCController.startWirelessControllerDiscovery{}
    }

    func didConnectController(_ notification: Notification) {
        guard
            let controller = notification.object as? GCController,
            let gamepad = controller.extendedGamepad
        else { return }
        print("controller connected \(controller.productCategory)")

        for button in gamepad.allButtons {
            button.pressedChangedHandler = onSingleValueChanged(button:value:pressed:)
        }

        gamepad.leftTrigger.valueChangedHandler = onSingleValueChanged(button:value:pressed:)
        gamepad.rightTrigger.valueChangedHandler = onSingleValueChanged(button:value:pressed:)
        gamepad.leftThumbstick.valueChangedHandler = onStickValueChanged(button:xVal:yVal:)
        gamepad.rightThumbstick.valueChangedHandler = onStickValueChanged(button:xVal:yVal:)
    }

    func onSingleValueChanged(button: GCControllerButtonInput, value: Float, pressed: Bool) {
        let eventName = getEventFor(name: button.localizedName ?? "unknown")
        print(eventName, value)
        let mappedValue = getValueFor(name: button.localizedName ?? "unknown", inputValue: value)
        print("mapped value:", mappedValue)
        let event = Event(name: eventName, xVal: mappedValue, yVal: 0, isPressed: pressed)
        do {
            let data = try self.encoder.encode(event)
            self.socketMan.sendEvent(data)
        } catch {
            print("error:", error)
        }
    }

    func onStickValueChanged(button: GCControllerDirectionPad, xVal: Float, yVal: Float) {
        print("X & Y: ", xVal, yVal)
    }

    func getValueFor(name: String, inputValue: Float) -> Float {
        switch name {
        case "Right Trigger":
            return inputValue * 6.2
        case "Left Thumbstick":
            return inputValue * 10
        default:
            return inputValue
        }
    }

    func getEventFor(name: String) -> String {
        switch name {
        case "Left Thumbstick":
            return "psycho-static"
        case "Left Trigger":
            return "metallic"
        case "Right Trigger":
            return "twist"
        default:
            return name
        }
    }
}
