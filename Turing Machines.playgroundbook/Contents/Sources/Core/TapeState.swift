//
//  TMState.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import Foundation

/// Representing a state the turing
/// machine is in while interpreting the current tape.
public final class TapeState: Equatable {
    
    // Used to compare and identify states.
    public let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
    public static func ==(lhs: TapeState, rhs: TapeState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Collection where Element == TapeState {
    
    /// Returns a Boolean value indicating whether
    /// the given collection of states is contained
    /// in the current collection of states.
    /// - Parameters:
    ///     - states: that should be looked for in the current collection.
    /// - Returns: `true` if all elements exist; otherwise `false`.
    public func contains(_ states: [TapeState]) -> Bool {
        for state in states {
            guard self.contains(state) else {
                return false
            }
        }
        
        return true
    }
}
