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
//#-editable-code
//#-end-editable-code
//#-end-hidden-code
//#-code-completion(identifier, hide, coordinator, PlaygroundCoordinator, PlaygroundPage, _setTape(_:), _addState(_:initial:final:), _addRule(currentState:currentSymbol:nextState:nextSymbol:move:), solution, hints, _execute(), ErrorViewController, MachineViewController, MachineState, Rule, TapeState, TuringMachine, UIColor, TMColors, CommandButtonContainer, StateViewContainer, CommandButton, StateView, TapeView, CommandButtonType, Snapshot)
//#-code-completion(literal, hide, color, dictionary, image, integer, nil, tuple)
//#-code-completion(keyword, hide, for, func, if, let, var, while)
/*:
 # Turing Machines
 
 **Made by [Hugo Lundin](https://www.github.com/hugolundin) in March 2018.**
 
 ## What is a Turing machine?
 In the 1930's [Alan Turing](#) introduced what we today refer to as a [Turing machine]().
 
 The turing machine is a theoretical computing device and a good introduction to the science of computing. Turing machines inspired the invention of computers we have today!
 
 ## How does a Turing machine work?
A turing machine has a few different things:
 * A `Tape`: The input read by the machine. It can be 3 different symbols: 0, 1 and # (the last one is called .blank). The machine goes through the tape one symbol at the time, starting from left to right.
 * A set of `Execution States`: While the machine is running, it move between states. The machine need at least one initial state and one final state. There can be many final states, however only one initial (we can only start in one place).
 * A set of `Rules`: They decide how the machine should act. The rules are defined for which state the machine has, in combination with what symbol it read from the tape. The rule decides which direction we should keep moving in, what symbol should be placed on the current position of the tape and what state we should be in next.
 
 The overall machine also has its own states:
 * `.accepting`: The start state, indicated by orange color. This means that the machine will continue reading the tape.
 * `.accepted`: If the machine reach a final state, the input is `.accepted`. The machine will keep on running until there are no more rules. If it still is `.accepted` while the machine has finished running, this will be shown by green color.
 * `.rejected`: If there are no rules defined for the combination of execution state and read symbol the machine will stop and the input is not accepted. This is shown by red color.
 
We will try this out in practice using Swift!

 **Example:** A machine that read 0's and keep moving to the right until a 1 is found.
 */

// What input that should be processed.
setTape("000001")

// State the machine starts in
addState(named: "Q0", initial: true)

// State the machine should finish in
addState(named: "Q1", final: true)

// If we are in state Q0 and read a 0 → Keep the 0, move to the right and stay in Q0.
addRule(ifInState: "Q0",
        readSymbol: .zero,
        replaceWith: .zero,
        moveTo: .right,
        goToState: "Q0")

// If we are in state Q0 and read a 1 → Keep the 1, stay at the tape position and move to Q1, which is final.
addRule(ifInState: "Q0",
        readSymbol: .one,
        replaceWith: .one,
        moveTo: .right,
        goToState: "Q1")

//: **Press "Run My Code" to start the program. Press the green play icon to play-out the execution. Press the blue step icon to step through the execution. Press the red cross to reset. If you want to restart the program, press "Stop" and then "Run My Code" again.**

//#-hidden-code
coordinator._execute()
//#-end-hidden-code
