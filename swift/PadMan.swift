
import GameController

class PadMan: ObservableObject{
    let socketMan: SocketMan

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
            button.pressedChangedHandler = {(button, value, pressed) in
                print("value: ", value)

                // add struct with boolean press and int value
                // serialize to json
                self.socketMan.sendEvent("value: \(value)")
            }
        }

        gamepad.leftTrigger.valueChangedHandler = onSingleValueChanged(button:value:pressed:)
        gamepad.rightTrigger.valueChangedHandler = onSingleValueChanged(button:value:pressed:)
        gamepad.leftThumbstick.valueChangedHandler = onStickValueChanged(button:xVal:yVal:)
        gamepad.rightThumbstick.valueChangedHandler = onStickValueChanged(button:xVal:yVal:)
    }

    func onSingleValueChanged(button: GCControllerButtonInput, value: Float, pressed: Bool) {
        print("value: ", value)
    }

    func onStickValueChanged(button: GCControllerDirectionPad, xVal: Float, yVal: Float) {
        print("X & Y: ", xVal, yVal)
    }
}
