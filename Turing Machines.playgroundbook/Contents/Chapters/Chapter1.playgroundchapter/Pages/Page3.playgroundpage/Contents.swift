//#-code-completion(everything, hide)
//#-code-completion(identifier, show, setTape(), addState(), addRule())

//#-hidden-code
import PlaygroundSupport

let solution = """
Create two states, for example `Q0` and `Q1`. \n
`Q0` is `initial` and `final`, while `Q1` is a regular state. \n
Create four rules:
* First rule: If I am in state `Q0` and read a `.zero`, write a `.zero`, move to the `.right` and stay in state `Q0`.
* Second rule: If I am in state `Q0` and read a `.one`, write a `.one`, move to the `.right` and move to state `Q1`.
* Third rule: If I am in state `Q1` and read a `.zero`, write a `.zero`, move to the `.right` and stay in state `Q1`.
* Fourth rule: If I am in state `Q1` and read a `.one`, write a `.one`, move to the `.right` and move to state `Q0`.
"""

let coordinator = PlaygroundCoordinator(PlaygroundPage.current, requiredTapeResult: nil, solution: solution, hints: ["You need 2 states to solve this problem.", "0 is by definition an even number, hence the start state should be final.", "Read 0's can be discarded.", "You need 4 rules to solve this problem."])

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
//#-code-completion(identifier, hide, coordinator, PlaygroundCoordinator, PlaygroundPage, _setTape(_:), _addState(_:initial:final:), _addRule(currentState:currentSymbol:nextState:nextSymbol:move:), solution, hints, _execute(), ErrorViewController, MachineViewController, MachineState, Rule, TapeState, TuringMachine, UIColor, TMColors, CommandButtonContainer, StateViewContainer, CommandButton, StateView, TapeView, CommandButtonType, Snapshot)
//#-code-completion(literal, hide, color, dictionary, image, integer, nil, tuple)
//#-code-completion(keyword, hide, for, func, if, let, var, while)
/*:
# Challenge
 **Time for a challenge!** Define a turing machine that accept all inputs where the number of 1's is even. Everything else should be rejected.
 
 **Should be accepted:** `0`, `11`, `0011`, `0101`, `01111`
 
 **Should be rejected:** `1`, `01`, `101111`, `11111`, `1111111`

 **Note:** If you change the code, you will need to press "Run My Code" again.
*/

setTape(<#T##tape input##String#>)

addState(named: "Q0", initial: <#T##initial state##Bool#>, final: <#T##final state##Bool#>)
addState(named: "Q1", initial: <#T##initial state##Bool#>, final: <#T##final state##Bool#>)

addRule(ifInState: "Q0",
        readSymbol: <#T##read symbol##Symbol#>,
        replaceWith: <#T##replace symbol##Symbol#>,
        moveTo: .right,
        goToState: "Q0")

addRule(ifInState: "Q0",
        readSymbol: <#T##read symbol##Symbol#>,
        replaceWith: <#T##replace symbol##Symbol#>,
        moveTo: .right,
        goToState: "Q1")

addRule(ifInState: "Q1",
        readSymbol: <#T##read symbol##Symbol#>,
        replaceWith: <#T##replace symbol##Symbol#>,
        moveTo: .right,
        goToState: "Q1")

addRule(ifInState: "Q1",
        readSymbol: <#T##read symbol##Symbol#>,
        replaceWith: <#T##replace symbol##Symbol#>,
        moveTo: .right,
        goToState: "Q0")

//: **Press "Run My Code" to start the program. Press the green play icon to play-out the execution. Press the blue step icon to step through the execution. Press the red cross to reset. If you want to restart the program, press "Stop" and then "Run My Code" again.**

//#-hidden-code
coordinator._execute()
//#-end-hidden-code
