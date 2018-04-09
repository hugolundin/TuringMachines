//
//  TMCommandButton.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-21.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// The different kind of
/// `CommandButton` that is available.
public enum CommandButtonType {
    case play
    case reset
    case step
    case pause
}

/// Subclass of `UIButton` with required properties.
/// Customized for a few different styles, which
/// can be changed dynamically during runtime.
public final class CommandButton: UIButton {
    
    // MARK: - Configuration and styling
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    public init(frame: CGRect, _ type: CommandButtonType) {
        super.init(frame: frame)
        self.type = type
        touchSetup()
        configureButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = TMColors.gray
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
    
    /// Configure `CommandButton` according to choosen `CommandButtonType`.
    public func configureButton() {
        if type == .play {
            self.setTitleColor(TMColors.green, for: .normal)
            self.setTitle("▶", for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7.0, bottom: 0, right: 0)
            return
        }
        
        if type == .pause {
            self.setTitleColor(TMColors.green, for: .normal)
            self.setTitle("■", for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return
        }
        
        if type == .reset {
            self.setTitleColor(TMColors.red, for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.setTitle("✕", for: .normal)
            return
        }
        
        if type == .step {
            self.setTitleColor(TMColors.blue, for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.setTitle("→", for: .normal)
            return
        }
    }
    
    // MARK: - Properties
    
    /// Provides runtime customization of button type.
    public var type: CommandButtonType! {
        didSet {
            configureButton()
        }
    }
    
    /// Overriden to change `backgroundColor` while highlighted.
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? TMColors.darkGray : TMColors.gray
        }
    }
    
    /// Overriden to provide additional alpha customization.
    override open var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
    
    // MARK: - Touch Actions
    public var touchDown: ((_ button: UIButton) -> ())?
    public var touchExit: ((_ button: UIButton) -> ())?
    public var touchUp:   ((_ button: UIButton) -> ())?
    
    @objc func touchDown(_ sender: UIButton) {
        touchDown?(sender)
    }
    
    @objc func touchExit(_ sender: UIButton) {
        touchExit?(sender)
    }
    
    @objc func touchUp(_ sender: UIButton) {
        touchUp?(sender)
    }
    
    /// Configure touch closures.
    private func touchSetup() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchExit(_:)), for: [.touchCancel, .touchDragExit])
        addTarget(self, action: #selector(touchUp(_:)),   for: [.touchUpInside])
    }
}
