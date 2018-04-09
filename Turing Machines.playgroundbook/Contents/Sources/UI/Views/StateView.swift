//
//  TMStateView.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Subclass of `UILabel` representing a turing machine state
public final class StateView: UILabel {
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 40)
    }
    
    /// Initialiser requires text that identifies the state.
    init(_ identifier: String) {
        super.init(frame: CGRect.zero)
        
        self.text = identifier
        self.textAlignment = .center
        self.textColor = .white
        self.font = font.withSize(30)
        self.backgroundColor = TMColors.darkGray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Activate the current state according to given `MachineState`.
    /// - Parameters:
    ///     - state: MachineState that state should reflect.
    public func activate(_ state: MachineState) {
        switch state {
        case .accepting: self.backgroundColor = TMColors.orange
        case .accepted: self.backgroundColor = TMColors.green
        case .rejected: self.backgroundColor = TMColors.red
        }
        
        self.textColor = .white
        self.layer.borderWidth = 0
    }
    
    /// Deactivate the current state and change to default colors.
    public func deactivate() {
        self.textColor = .white
        self.backgroundColor = TMColors.darkGray
    }
}
