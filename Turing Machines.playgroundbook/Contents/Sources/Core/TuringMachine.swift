//
//  TuringMachine.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import Foundation

/// A snapshot represents the state of a turing machine, and all necessary details needed to visualize an execution.
public typealias Snapshot = (currentState: TapeState, machineState: MachineState, tapeState: (tape: [Symbol], position: Int), done: Bool)

/// A Turing machine simulator.
///
/// Given a tape, a number of states (where one should be initial and at least one should be final) and a
/// set of rules, it behaves according to the behaviour specification of a Turing machine within Computer Science.
/// Running the run method results in an array of `Snapshot`'s representing every step taken by the Turing machine.
///
/// It was chosen that execution (which is very fast) is performed before returing snapshots.
/// This makes it easier to without having to do any kind of synchronisation between UI and model
/// do a visualization.
public final class TuringMachine {
    
    /// The current state of the execution tape.
    private var tape: [Symbol]
    
    /// Current tape position
    private var position: Int = 0
    
    /// Indicate whether execution has finished.
    private var done = false
    
    /// The initial execution state of the tape.
    private let initial: TapeState
    
    /// The final execution states of the tape.
    private let final: [TapeState]
    
    /// Array containing all execution states.
    private let states: [TapeState]
    
    /// Indicate current execution state.
    private var currentState: TapeState
    
    /// Indicate current machine state.
    private var machineState: MachineState
    
    /// Dictionary containing all given rules.
    /// An array is not used, since O(1) access now can be provided - making the
    /// execution faster.
    private var transitionRules =  Dictionary<String, Dictionary<Symbol, Rule>>()
    
    /// The initialiser verifies the given tape, states and rules in some different ways.
    /// If it does not correspond to specification, it will return `nil`.
    /// It is recommended to do some verification of input before giving it to the initializer.
    ///
    /// - Parameters:
    ///     - tape: Tape that should be used during execution.
    ///     - initial: Initial state that the machine should start in.
    ///     - states: All states that the execution can be in (including initial and final states).
    ///     - final: A set of final states.
    ///     - rules: All rules for how the machine should act depending on current state and read symbol.
    public init?(tape: [Symbol], initial: TapeState, states: [TapeState], final: [TapeState], rules: [Rule]) {
        self.tape = tape
        self.initial = initial
        self.states = states
        self.final = final
        
        // The machine starts with the initial execution state.
        self.currentState = initial
        
        // The machine starts in an accepting machine state.
        self.machineState = .accepting
        
        // Make sure that the initial state is contained in the state list.
        guard states.contains(initial) else {
            NSLog("The state list should contain all states. Please add the initial state.")
            return nil
        }
        
        // Make sure that all final states is contained in the state list.
        guard states.contains(final) else {
            NSLog("The state list should contain all states. Please add missing final states.")
            return nil
        }
        
        /// Move all rules from the given array to the rule dictionary.
        for rule in rules {
            
            // If there is not any rules defined for a certain state
            // create a new dictionary to keep symbol rules in.
            if transitionRules[rule.currentState.identifier] == nil {
                transitionRules[rule.currentState.identifier] = Dictionary<Symbol, Rule>()
                transitionRules[rule.currentState.identifier]?[rule.currentSymbol] = rule
                continue
            }
            
            // If there already is rules defined for a certain state, add
            // a new rule for the current symbol.
            transitionRules[rule.currentState.identifier]?[rule.currentSymbol] = rule
        }
    }
    
    /// Return a snapshot representing the current state of the machine.
    private func getSnapshot() -> Snapshot {
        return (currentState: currentState, machineState: machineState, tapeState: (tape: tape, position: position), done: done)
    }
    
    /// Run the defined Turing machine.
    /// - Returns: An array of `Snapshot`'s
    /// describing the run of all steps.
    public func run() -> [Snapshot] {
        var snapshots = [Snapshot]()
        
        // Get the initial step
        var current = getSnapshot()
        
        // While execution is not done,
        // keep adding steps.
        while (!current.done) {
            snapshots.append(current)
            proceed()
            current = getSnapshot()
        }
        
        // Add the final step when the machine is done.
        snapshots.append(getSnapshot())
        
        return snapshots
    }
    
    private func proceed() {
        // If execution is done nothing should be done.
        if done {
            return
        }
        
        // If current stte is final, indicate that
        // the turing machine accepted the given tape.
        // Otherwise, keep accepting.
        if final.contains(currentState) {
            machineState = .accepted
        } else {
            machineState = .accepting
        }
        
        // If a rule is found for the current state and currently read symbol,
        // proceed. Otherwise, the machine is either done with execution
        // or has rejected the input.
        if let stateRules = transitionRules[currentState.identifier],
            let symbolRule = stateRules[tape[position]] {
            
            // Transist to next execution state.
            currentState = symbolRule.nextState
            
            // Write the symbol specified in the rule to the tape at the current position.
            tape[position] = symbolRule.nextSymbol
            
            // Check after transition whether the current state is final.
            if final.contains(currentState) {
                machineState = .accepted
            } else {
                machineState = .accepting
            }
            
            // Determine which direction the tape should move in.
            switch symbolRule.move {
                
                // In a Turing machine, according to definition the tape is infinitly long
                // and filled with blanks in both directions. Since this is hard to show in
                // a user interface, we only append blanks when a position
            // outside of the given tape is entered.
            case .right: if position >= tape.count - 1 && symbolRule.move == .right {
                tape.append(.blank)
                position += 1
            } else {
                position += 1
                }
                
                // Perform the same action as above, but insert blanks in the beginning,
            // and stay logically at position 0.
            case .left:  if position == 0 && symbolRule.move == .left {
                tape.insert(.blank, at: 0)
            } else {
                position -= 1
                }
                
            // If the rule indicates `.stay` do not move anywhere on the tape.
            case .stay:  break
                
            }
        } else {
            // When coming to this clause, if the machine is still accepting,
            // there are no rules and the input should be rejected.
            if machineState == .accepting {
                machineState = .rejected
            }
            
            // Indicate that execution is done.
            done = true
        }
    }
}
