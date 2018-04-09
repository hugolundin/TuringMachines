//#-hidden-code
import PlaygroundSupport

let coordinator = PlaygroundCoordinator(PlaygroundPage.current, requiredTapeResult: nil, solution: nil, hints: [])

public func setTape(_ text: String) {
    coordinator._setTape(text)
}

public func addState(named: String, initial: Bool = false, final: Bool = false) {
    coordinator._addState(named, initial: initial, final: final)
}

public func addRule(ifInState: String, readSymbol: Symbol, replaceWith: Symbol, moveTo: Direction, goToState: String) {
    coordinator._addRule(currentState: ifInState, currentSymbol: readSymbol, nextState: goToState, nextSymbol: replaceWith, move: moveTo)
}
//#-end-hidden-code
/*:
# Playground
This is a playground where you can create your own turing machine simulations.
 
Use the previous examples as inspiration and create something on your own!
 
**Good luck!**
 */
//#-code-completion(identifier, hide, coordinator, PlaygroundCoordinator, PlaygroundPage, _setTape(_:), _addState(_:initial:final:), _addRule(currentState:currentSymbol:nextState:nextSymbol:move:), solution, hints, _execute(), ErrorViewController, MachineViewController, MachineState, Rule, TapeState, TuringMachine, UIColor, TMColors, CommandButtonContainer, StateViewContainer, CommandButton, StateView, TapeView, CommandButtonType, Snapshot)
//#-code-completion(literal, hide, color, dictionary, image, integer, nil, tuple)
//#-code-completion(keyword, hide, for, func, if, let, var, while)


//#-editable-code Tap to write your code
//#-end-editable-code

//: **Press "Run My Code" to start the program. Press the green play icon to play-out the execution. Press the blue step icon to step through the execution. Press the red cross to reset. If you want to restart the program, press "Stop" and then "Run My Code" again.**

//#-hidden-code
coordinator._execute()
//#-end-hidden-code
