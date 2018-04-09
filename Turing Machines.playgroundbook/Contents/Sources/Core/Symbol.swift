//
//  Symbol.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import Foundation

/// Representing symbols that can be part of tape.
/// Used as an intermediate representation to filter out invalid symbols
/// and strictly define in an easy way what is allowed to exist on the execution tape.
///
/// The lifecycle of tape interpretation is:
///
/// * User set the tape as a `String`.
/// * Symbol.interpret(_ input: String)` is run on the input to filter out invalid characters.
/// * `[Symbol]` is passed to the machine and used during execution.
/// * The result of a run is represented in `[Snapshot]` which contains the current tape state.
/// * The current tape state is converted into a string representation visualized in a `UILabel`.
public enum Symbol: Character {
    case blank = "#"
    case zero = "0"
    case one = "1"
    
    /// Interpret given string into tape symbols.
    /// - Parameters:
    ///     - input: Text that should be interpreted.
    /// - Returns: An array with symbols representing the tape.
    static func interpret(_ input: String) -> [Symbol] {
        var result = [Symbol]()
        
        for c in input {
            switch c {
            case Symbol.zero.rawValue:  result.append(.zero)
            case Symbol.one.rawValue:   result.append(.one)
            case Symbol.blank.rawValue: result.append(.blank)
                
                // Characters not recognized are skipped.
                // May cause confusion if the user enter `222` as tape,
                // and it is reported that the tape is empty.
                // I chose to do this to easier report to the user
            // in the playground that there was no valid input.
            default:
                break
            }
        }
        
        return result
    }
}

extension Array where Element == Symbol {
    
    /// Returns `String`-representation of
    /// `Array` containing `Symbol`'s.
    var representation: String {
        var result = ""
        for element in self {
            result.append(element.rawValue)
        }
        return result
    }
}
