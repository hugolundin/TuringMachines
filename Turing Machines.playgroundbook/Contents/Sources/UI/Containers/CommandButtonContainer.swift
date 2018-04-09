//
//  CommandContainer.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-25.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Subclass of `UIStackView` with the purpose of
/// arranging `CommandButton`'s.
public final class CommandButtonContainer: UIStackView {
    
    /// Initialiser requires a frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 5
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    /// Add a button to the `CommandButtonContainer`.
    /// Provides a more convenient way to add interface buttons.
    /// - Parameters:
    ///    - button: `CommandButton` that should be added to the container.
    ///    - pushed: Closure that should run when button is pushed.
    public func addCommand(_ button: CommandButton, pushed: @escaping (_ button: UIButton) -> ()) {
        button.touchUp = pushed
        addArrangedSubview(button)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
