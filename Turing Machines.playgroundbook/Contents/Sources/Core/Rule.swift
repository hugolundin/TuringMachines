//
//  TMRule.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import Foundation

/// Representing rules for a turing machine.
public struct Rule {
    
    // Rule applies to combination of state and symbol.
    let currentState: TapeState
    let currentSymbol: Symbol
    
    // What state that should be transitioned to.
    let nextState: TapeState
    
    // What symbol that should be written to the current tape position.
    let nextSymbol: Symbol
    
    // How the tape should move.
    let move: Direction
}

extension Rule: Equatable {
    public static func ==(lhs: Rule, rhs: Rule) -> Bool {
        return lhs.currentState == rhs.currentState && lhs.currentSymbol == rhs.currentSymbol
    }
}
