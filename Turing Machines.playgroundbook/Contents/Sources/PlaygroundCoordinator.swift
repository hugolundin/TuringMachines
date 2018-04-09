//
//  PlaygroundCoordinator.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-26.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import PlaygroundSupport
import Foundation
import UIKit

extension Notification.Name {
    static let success = Notification.Name(rawValue: "success")
    static let failure = Notification.Name(rawValue: "failure")
}

public final class PlaygroundCoordinator {
    
    /// Initial state added by the user.
    private var initialState: TapeState?
    
    /// All final states added by the user.
    private var finalStates = [TapeState]()
    
    /// All states added by the user.
    private var allStates = [TapeState]()
    
    /// Tape text entered by the user.
    private var tape: String?
    
    /// Rules entered by the user.
    private var rules = [Rule]()
    
    /// The currently used `PlaygroundPage`.
    private let page: PlaygroundPage
    
    /// Solution to the problem in the calling `PlaygroundPage`.
    private let solution: String?
    
    /// Hints to the problem in the calling `PlaygroundPage`.
    private let hints: [String]
    
    /// What is on the tape after execution
    private var tapeResult: String?
    
    /// What the tape should be after execution
    private var requiredTapeResult: String?
    
    /// Indicate between convenience methods whether to continue running`.
    /// Used to show errors and not continue and therefore indicate
    /// other error or `MachineViewController`.
    private var shouldExecute: Bool = true
    
    public init(_ page: PlaygroundPage, requiredTapeResult: String?, solution: String?, hints: [String]) {
        self.page = page
        self.requiredTapeResult = requiredTapeResult
        self.solution = solution
        self.hints = hints
    }
    
    /// Constants used for verification, hinting and showing solutions.
    struct Text {
        static let tryAgain = "\n \n Please check your code and try again."
        
        struct OneInitialState {
            static let hints: [String] = []
            static let solution: String? = nil
            static let message: String = "1️⃣\n There can only be one initial state. \(Text.tryAgain)"
        }
        
        struct StateDoesNotExist {
            static let hints: [String] = []
            static let solution: String? = nil
            static let message: String = "❓\n The states referenced in the rules does not exist. Make sure that all states are created before the rules. \(Text.tryAgain)"
        }
        
        struct RuleAlreadyDefined {
            static let hints: [String] = []
            static let solution: String? = nil
            static let message: String = "🤯\n Duplicate rules have been created for a combination of state and symbol. \(Text.tryAgain)"
        }
        
        struct TapeInvalid {
            static let hints: [String] = ["Look at the tape and verify that you have entered something valid.", "The only accepted symbols is 0, 1 and #. Everything else will be ignored."]
            static let solution: String? = nil
            static let message: String = "🎞\n The tape could not be read. \(Text.tryAgain)"
        }
        
        struct TapeEmpty {
            static let hints: [String] = ["Look at the tape and verify that you have entered something valid.", "The only accepted symbols is 0, 1 and #. Everything else will be ignored."]
            static let solution: String? = nil
            static let message: String = "🎞\n The tape is empty. \(Text.tryAgain)"
        }
        
        struct InitialState {
            static let hints: [String] = ["Look at your states and make sure that one and one only has `initial: true`.", "Only one state can be initial.", "One state need to be initial."]
            static let solution: String? = nil
            static let message: String = "➡️\n An initial state does not exist. \(Text.tryAgain)"
        }
        
        struct AllStates {
            static let hints: [String] = ["Make sure that you have created a state.", "A state is created using `addState`."]
            static let solution: String? = nil
            static let message: String = "💾\n There are no states. \(Text.tryAgain)"
        }
        
        struct Creating {
            static let hints: [String] = ["Look through your code and make sure that everything seems to be correct."]
            static let solution: String? = nil
            static let message: String = "🤔\n Something went wrong while creating the Turing machine. \(Text.tryAgain)"
        }
        
        struct Running {
            static let hints: [String] = ["Look through your code and make sure that everything seems to be correct"]
            static let solution: String? = nil
            static let message: String = "🚦\n Something went wrong while running the Turing machine. \(Text.tryAgain)"
        }
        
        struct Success {
            static let message = "Good job! The turing machine accepted your input.\n [Proceed to next page →](@next)"
        }
    }
    
    /// Convenience methods to be called from a `Playground`.
    /// Preferably these methods should be contained in additional containers,
    /// in order to abstract away unnecessary objects from the user.
    /// Additional containers can also be used to add challenge/problem-specific verification.
    
    public func _addState(_ identifier: String, initial: Bool = false, final: Bool = false) {
        guard shouldExecute else {
            return
        }
        
        let state = TapeState(identifier)
        
        if final {
            finalStates.append(state)
        }
        
        if initial {
            guard initialState == nil else {
                page.assessmentStatus = .fail(hints: Text.OneInitialState.hints, solution: Text.OneInitialState.solution)
                page.liveView = ErrorViewController(message: Text.OneInitialState.message)
                shouldExecute = false
                return
            }
            
            initialState = state
        }
        
        allStates.append(state)
    }
    
    public func _addRule(currentState: String, currentSymbol: Symbol, nextState: String, nextSymbol: Symbol, move: Direction) {
        guard shouldExecute else {
            return
        }
        
        let current = TapeState(currentState)
        let next = TapeState(nextState)
        
        guard allStates.contains([current, next]) else {
            page.assessmentStatus = .fail(hints: Text.StateDoesNotExist.hints, solution: Text.StateDoesNotExist.solution)
            page.liveView = ErrorViewController(message: Text.StateDoesNotExist.message)
            shouldExecute = false
            return
        }
        
        let rule = Rule(currentState: current, currentSymbol: currentSymbol, nextState: next, nextSymbol: nextSymbol, move: move)
        
        guard !rules.contains(rule) else {
            page.assessmentStatus = .fail(hints: Text.RuleAlreadyDefined.hints, solution: Text.RuleAlreadyDefined.solution)
            page.liveView = ErrorViewController(message: Text.RuleAlreadyDefined.message)
            shouldExecute = false
            return
        }
        
        rules.append(rule)
    }
    
    public func _setTape(_ text: String) {
        guard shouldExecute else {
            return
        }
        
        tape = text
    }
    
    public func _execute() {
        guard shouldExecute else {
            return
        }
        
        guard let tape = tape else {
            page.assessmentStatus = .fail(hints: Text.TapeInvalid.hints, solution: Text.TapeInvalid.solution)
            page.liveView = ErrorViewController(message: Text.TapeInvalid.message)
            return
        }
        
        let symbols = Symbol.interpret(tape)
        
        guard symbols.count > 0 else {
            page.assessmentStatus = .fail(hints: Text.TapeEmpty.hints, solution: Text.TapeEmpty.solution)
            page.liveView = ErrorViewController(message: Text.TapeEmpty.message)
            return
        }
        
        guard let initialState = initialState else {
            page.assessmentStatus = .fail(hints: Text.InitialState.hints, solution: Text.InitialState.solution)
            page.liveView = ErrorViewController(message: Text.InitialState.message)
            return
        }
        
        guard allStates.count > 0 else {
            page.assessmentStatus = .fail(hints: Text.AllStates.hints, solution: Text.AllStates.solution)
            page.liveView = ErrorViewController(message: Text.AllStates.message)
            return
        }
        
        guard let turingMachine = TuringMachine(tape: symbols, initial: initialState, states: allStates, final: finalStates, rules: rules) else {
            page.assessmentStatus = .fail(hints: Text.Creating.hints, solution: Text.Creating.solution)
            page.liveView = ErrorViewController(message: Text.Creating.message)
            return
        }
        
        let run = turingMachine.run()
        
        guard run.count > 0 else {
            page.assessmentStatus = .fail(hints: Text.Running.hints, solution: Text.Running.solution)
            page.liveView = ErrorViewController(message: Text.Running.message)
            return
        }
        
        // Save the tape state of the last snapshot as tapeResult
        tapeResult = run[run.count - 1].tapeState.tape.representation
        
        NotificationCenter.default.addObserver(self, selector: #selector(executionSuccess), name: .success, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(executionFailure), name: .failure, object: nil)
        
        let controller = MachineViewController(states: allStates, tape: symbols.representation, machineStates: run)
        
        page.liveView = controller
    }
    
    private func requiredTape() -> Bool {
        guard let tapeResult = self.tapeResult else {
            return false
        }
        
        guard let requiredTapeResult = self.requiredTapeResult else {
            return false
        }
        
        if tapeResult == requiredTapeResult {
            page.assessmentStatus = .pass(message: "Good job! The tape contain what you were instructed to produce.\n [Proceed to next page →](@next)")
        } else {
            page.assessmentStatus = .fail(hints: self.hints, solution: self.solution)
        }
        
        return true
    }
    
    @objc private func executionSuccess() {
        guard !requiredTape() else {
            return
        }
        
        page.assessmentStatus = .pass(message: Text.Success.message)
    }
    
    @objc private func executionFailure() {
        guard !requiredTape() else {
            return
        }
        
        page.assessmentStatus = .fail(hints: self.hints, solution: self.solution)
    }
}
