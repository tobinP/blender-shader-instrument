
import GameController

class Gamepad: ObservableObject{
    let socketMan: SocketMan
//    var buttons = [GCControllerButtonInput]()

    init(_ socketMan: SocketMan) {
        self.socketMan = socketMan
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil, using: didConnectController)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil, using: didDisconnectController)
        GCController.startWirelessControllerDiscovery{}
    }

    func didConnectController(_ notification: Notification) {
        guard
            let controller = notification.object as? GCController,
            let gamepad = controller.extendedGamepad
        else { return }
        print("controller connected \(controller.productCategory)")
//        buttons.append(gamepad.dpad.left)
//        buttons.append(gamepad.dpad.up)
//        buttons.append(gamepad.dpad.right)
//        buttons.append(gamepad.dpad.down)
//        buttons.append(gamepad.buttonX)
//        buttons.append(gamepad.buttonY)
//        buttons.append(gamepad.buttonB)
//        buttons.append(gamepad.buttonA)
//        buttons.append(gamepad.buttonOptions!)
//        buttons.append(gamepad.buttonMenu)
//        buttons.append(gamepad.leftThumbstickButton!)
//        buttons.append(gamepad.rightThumbstickButton!)
//        buttons.append(gamepad.leftShoulder)
//        buttons.append(gamepad.rightShoulder)

        for button in gamepad.allButtons {
            button.pressedChangedHandler = {(button, value, pressed) in

                // add struct with boolean press and int value
                // serialize to json
                self.socketMan.sendEvent("value: \(value)")
            }
        }

        // are trigger presses contained in the `allButtons` collection?
//        gamepad.leftTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(14, pressed) }
//        gamepad.rightTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(15, pressed) }


        // add 2 methods to handle both value types here
//        gamepad.leftTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(14, value) }
//        gamepad.rightTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(15, value) }
//        gamepad.leftThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(10, xvalue, yvalue) }
//        gamepad.rightThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(11, xvalue, yvalue) }
    }
    func didDisconnectController(_ notification: Notification) {
        let controller = notification.object as! GCController
        print("controller disconnected \(controller.productCategory)")
    }
}

