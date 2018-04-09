//
//  StatesView.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-25.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Subclass of `UIStackView` with the purpose of
/// arranging and encapsulating `StateView`'s.
public final class StateViewContainer: UIStackView {
    
    /// A dictionary of states. Provides O(1) lookup time
    /// to easier and faster adapt the UI to the turing machine.
    private var states = Dictionary<String, StateView>()
    
    /// Identifier of the current active state.
    /// Used to keep the mutual exclusion
    /// invariant of state switching correct.
    /// When one state is enabled, the old one indicated
    /// by `current` will be disabled.
    private var current: String?
    
    /// Initialiser requires a frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        distribution = .fillEqually
        alignment = .center
        spacing = 15
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    /// Provides a more convenient way to add states to the container.
    /// - Parameters:
    ///     - identifier: Identifier that should be shown on the state.
    public func addState(_ identifier: String) {
        let state = StateView(identifier)
        states[identifier] = state
        self.addArrangedSubview(state)
    }
    
    /// Disable any active state and show the initial state view.
    /// All added states persist.
    public func reset() {
        if let current = current {
            if let old = states[current] {
                old.deactivate()
            }
        }
    }
    
    /// Activate given state with color according to `MachineState`.
    /// - Parameters:
    ///     - identifier: State that should be set to active.
    ///     - machineState: What machineState the state reflect in its color.
    public func setState(_ identifier: String, machineState: MachineState) {
        
        // Disable the old state
        if let current = current {
            if let old = states[current] {
                old.deactivate()
            }
        }
        
        // Activate the new state
        if let next = states[identifier] {
            next.activate(machineState)
        }
        
        current = identifier
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

