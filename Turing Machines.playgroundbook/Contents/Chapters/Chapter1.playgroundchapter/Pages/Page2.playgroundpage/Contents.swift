//#-code-completion(everything, hide)
//#-code-completion(identifier, show, setTape(), addState(), addRule())

//#-hidden-code
import PlaygroundSupport

let coordinator = PlaygroundCoordinator(PlaygroundPage.current, requiredTapeResult: "#111111", solution: nil, hints: [])
var tape = ""

public func setTape(_ text: String) {
    coordinator._setTape(text)
    tape = text
}

public func addState(named: String, initial: Bool = false, final: Bool = false) {
    coordinator._addState(named, initial: initial, final: final)
}

public func addRule(ifInState: String, readSymbol: Symbol, replaceWith: Symbol, moveTo: Direction, goToState: String) {
    coordinator._addRule(currentState: ifInState, currentSymbol: readSymbol, nextState: goToState, nextSymbol: replaceWith, move: moveTo)
}
//#-end-hidden-code
//#-code-completion(identifier, hide, coordinator, PlaygroundCoordinator, PlaygroundPage, _setTape(_:), _addState(_:initial:final:), _addRule(currentState:currentSymbol:nextState:nextSymbol:move:), solution, hints, _execute(), ErrorViewController, MachineViewController, MachineState, Rule, TapeState, TuringMachine, UIColor, TMColors, CommandButtonContainer, StateViewContainer, CommandButton, StateView, TapeView, CommandButtonType, Snapshot)
//#-code-completion(literal, hide, color, dictionary, image, integer, nil, tuple)
//#-code-completion(keyword, hide, for, func, if, let, var, while)
/*:
# Addition
In this example we do not care whether the input is rejected or accepted – instead we will use the machine to add two numbers.
 
**Example:** Given "11#11", the result will be "1111" (numbers that should be added is separated with a blank symbol).
 
**To complete this challenge, first run the machine and see if you understand the execution. Then change the input to something that will give `111111` as result.**

**Note:** If you change the code, you will need to press "Run My Code" again.
 
 */
setTape(/*#-editable-code*/"11#11"/*#-end-editable-code*/)

addState(named: "Q0", initial: true)
addState(named: "Q1")
addState(named: "Q2")

addRule(ifInState: "Q0",
        readSymbol: .one,
        replaceWith: .blank,
        moveTo: .right,
        goToState: "Q1")

addRule(ifInState: "Q1",
        readSymbol: .one,
        replaceWith: .one,
        moveTo: .right,
        goToState: "Q1")

addRule(ifInState: "Q1",
        readSymbol: .blank,
        replaceWith: .one,
        moveTo: .right,
        goToState: "Q2")

//: **Press "Run My Code" to start the program. Press the green play icon to play-out the execution. Press the blue step icon to step through the execution. Press the red cross to reset. If you want to restart the program, press "Stop" and then "Run My Code" again.**

//#-hidden-code
coordinator._execute()
//#-end-hidden-code
