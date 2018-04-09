//
//  TapeView.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-25.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Represents the showing of the turing machine tape.
/// Provides functionality to set, change and highlight parts of the tape.
public final class TapeView: UILabel {
    
    // Stores the currently set tape text.
    private var current: String?
    
    // Stores the first tape text.
    private var original: String?
    
    /// Provides initialisation of tape with a given tape text.
    public init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.set(text, position: nil)
        original = text
    }
    
    /// Provides initialisation of tape without a blank tape text.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        numberOfLines = 1
        textAlignment = .center
        minimumScaleFactor = 0.1
        adjustsFontSizeToFitWidth = true
        font = UIFont.systemFont(ofSize: 25)
        backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1.00)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Reset the tape to its initial text
    public func reset() {
        if let original = original {
            set(original, position: nil)
        }
    }
    
    /// Update highlighting to given position.
    /// Tape text will persist.
    /// - Parameters:
    ///     - position: Position that should be highlighted. If `nil`, nothing will be highlighted.
    public func update(position: Int?) {
        if let current = current {
            set(current, position: position)
        }
    }
    
    /// Set tape to given text and highlight eventual given position
    /// - Parameters:
    ///     - tape: Tape text that should be shown.
    ///     - position: Position that should be highlighted. If `nil`, nothing will be highlighted.
    public func set(_ tape: String, position: Int?) {
        
        // Save the first tape text.
        if original == nil {
            original = tape
        }
        
        let attributedString = NSMutableAttributedString(string: tape)
        current = tape
        
        // Colors that should be used for highlighted and non-highlighted text.
        let highLightColor = UIColor.black
        let otherColor = UIColor.white
        
        // Only highlight if a position was given
        if let position = position {
            
            guard position >= 0 else {
                return
            }
            
            guard position < tape.count else {
                return
            }
            
            // Set color to part before character that should be highlighted
            if position > 0 {
                let before = NSRange(location: 0, length: position)
                attributedString.addAttribute(.foregroundColor, value: otherColor, range: before)
            }
            
            // Highlight given position
            let current = NSRange(location: position, length: 1)
            attributedString.addAttribute(.foregroundColor, value: highLightColor, range: current)
            
            // Set color to part after character that should be highlighted
            let after = NSRange(location: position + 1, length: tape.count - position - 1)
            attributedString.addAttribute(.foregroundColor, value: otherColor, range: after)
            
        } else {
            
            // Highlight nothing
            let all = NSRange(location: 0, length: tape.count)
            attributedString.addAttribute(.foregroundColor, value: otherColor, range: all)
        }
        
        self.attributedText = attributedString
    }
}
