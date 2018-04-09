//
//  ViewController.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-19.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Subclass of `UIViewController` representing a currently
/// running Turing machine. Features the ability to
/// control execution using `CommandButton`'s,
/// visualizing current state and what the outcome
/// of the execution is.
public class MachineViewController: UIViewController {
    
    /// Container responsible for keeping and showing execution states.
    private var stateContainer: StateViewContainer!
    
    /// View responsible for showing current tape state.
    private var tape: TapeView!
    
    /// Container responsible for keeping and showing commands that
    /// can be executed in the interface.
    private var commandButtonContainer: CommandButtonContainer!
    
    /// Symbols on the current tape.
    private var tapeText: String = ""
    
    /// Execution states the machine can be in.
    private var states = [TapeState]()
    
    /// Result snapshots after machine execution.
    private var snapshots = [Snapshot]()
    
    /// Current position on the tape.
    private var position = 0
    
    /// Whether the playout is done or not.
    private var done = false
    
    /// See `CommandButton` closure for the play button.
    private var playID = 0
    
    /// - Parameters:
    ///     - states: States that should be shown in the interface.
    ///     - tape: Tape that should be shown in the interface.
    ///     - machineStates: Snapshots that should be iterated through during playout.
    public init(states: [TapeState], tape: String, machineStates: [Snapshot]) {
        self.states = states
        self.tapeText = tape
        self.snapshots = machineStates
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Subview positions are chosen within `viewWillLayoutSubviews()`.
    /// This can not be done in `viewDidLoad()` due to the
    /// playground dimensions being given to the `MachineViewController`
    /// after it is ran in the lifecycle.
    public override func viewWillLayoutSubviews() {
        stateContainer.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height * 0.5)
        
        tape.frame = CGRect(x: 20, y: view.frame.height * 0.56, width: view.frame.width - 40, height: 150)
        
        commandButtonContainer.frame = CGRect(x: view.frame.width * 0.4 / 2, y: view.frame.height - 85, width: view.frame.width * 0.6, height: 60)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Add states to the interface.
        for state in states {
            stateContainer.addState(state.identifier)
        }
        
        // Add tape text to interface but highlight nothing.
        tape.set(tapeText, position: nil)
    }
    
    private func setupUI() {
        
        // The background color is the same as behind the code in the playground.
        view.backgroundColor = UIColor.white
        
        stateContainer = StateViewContainer(frame: CGRect.zero)
        view.addSubview(stateContainer)
        
        tape = TapeView(frame: CGRect.zero)
        view.addSubview(tape)
        
        commandButtonContainer = CommandButtonContainer(frame: CGRect.zero)
        
        // Create user interface command buttons.
        let reset = CommandButton(frame: CGRect.zero, .reset)
        let play = CommandButton(frame: CGRect.zero, .play)
        let step = CommandButton(frame: CGRect.zero, .step)
        
        // Reset command is used to reset the
        // execution visualisation.
        commandButtonContainer.addCommand(reset) { _ in
            self.tape.reset()
            self.stateContainer.reset()
            self.position = 0
            step.isEnabled = true
            play.isEnabled = true
            play.type = .play
            self.done = true
        }
        
        // Play execution visualisation from the beginning.
        // A major problem that occured in the user interface
        // was due to the delay used to visualise change between
        // different states. If one pressed play → reset → play,
        // it would start in the middle due to the delayed playout of
        // future states.
        // To solve this, every state playout gets an identifier `playID`.
        // When play is pressed the playID is increased hence all scheduled
        // playouts will be invalidated and therefore not run `proceed()`
        // (they will invalidate silently in the background).
        commandButtonContainer.addCommand(play) { _ in
            
            // Step is disabled during continuous playout.
            step.isEnabled = false
            
            // Play button is disabled during continuous playout.
            play.isEnabled = false
            
            // Indicate that a playout session started.
            self.done = false
            
            self.playID += 1
            let playID = self.playID
            
            // Iterate over all snapshots and play them out with a delay
            // in proportion to order. Make sure that the snapshot
            // is part of the current playout sessino and that
            // execution is not already done.
            for index in 0...self.snapshots.count - 1 {
                self.delay(Double(index) * 0.4) {
                    if !self.done && playID == self.playID {
                        proceed()
                    }
                }
            }
        }
        
        // Allow the user the playout a session by stepping through it.
        // Can be compared to the step functionality in many debuggers,
        // which also can be useful here – to see where execution
        // of the turing machine is incorrect or weird.
        commandButtonContainer.addCommand(step) { _ in
            
            // Indicate that a playout session started.
            self.done = false
            
            // Play button is disabled during step playout.
            play.isEnabled = false
            
            proceed()
        }
        
        view.addSubview(commandButtonContainer)
        
        func proceed() {
            
            // Obtain snapshot with index of current position
            let current = self.snapshots[self.position]
            
            if (self.position < self.snapshots.count) {
                
                if current.done {
                    
                    // Stop highlighting of a certain position, only show the playout outcome.
                    self.tape.set(current.tapeState.tape.representation, position: nil)
                    
                    // Indicate by color which machineState the machine is in, in relation to current execution state.
                    self.stateContainer.setState(current.currentState.identifier, machineState: current.machineState)
                    step.isEnabled = false
                    play.isEnabled = false
                    
                    // Tell the playground that the user have ran the machine through a whole playout execution.
                    
                    // Indicate success.
                    if current.machineState == .accepted {
                        NotificationCenter.default.post(name: .success, object: nil)
                    }
                    
                    // Indicate failure.
                    if current.machineState == .rejected {
                        NotificationCenter.default.post(name: .failure, object: nil)
                    }
                    
                } else {
                    
                    // Highlight the current tape position.
                    self.tape.set(current.tapeState.tape.representation, position: current.tapeState.position)
                    
                    // Indicate by color which machineState the machine is in, in relation to current execution state.
                    self.stateContainer.setState(current.currentState.identifier, machineState: current.machineState)
                    
                    // Increase tape position.
                    self.position += 1
                }
            }
        }
    }
    
    /// Execute `closure` after given `delay`.
    /// - Parameters:
    ///     - delay: How long time that should be delayed.
    ///     - closure: Closure that should be executed after delay.
    func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
