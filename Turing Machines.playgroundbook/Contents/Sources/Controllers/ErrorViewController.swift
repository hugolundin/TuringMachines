//
//  ErrorViewController.swift
//  TuringMachine
//
//  Created by Hugo Lundin on 2018-03-27.
//  Copyright © 2018 Hugo Lundin. All rights reserved.
//

import UIKit

/// Subclass of `UIViewController` presenting
/// a simple error view with the ability to
/// show a custom message.
public class ErrorViewController: UIViewController {
    
    // Message that should be presented to the user
    private var message: String
    
    // Label that the message is presented on
    private var label: UILabel!
    
    public init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Subview positions are chosen within `viewWillLayoutSubviews()`.
    /// This can not be done in `viewDidLoad()` due to the
    /// playground dimensions being given to the `ErrorViewController`
    /// after it is ran in the lifecycle.
    public override func viewWillLayoutSubviews() {
        label.frame = CGRect(x: view.frame.width * 0.05, y: 0, width: view.frame.width * 0.9, height: view.frame.height)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        label = UILabel(frame: CGRect.zero)
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        self.view.addSubview(label)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.message = "An error occured. Please try to run the code again."
        super.init(coder: aDecoder)
    }
}
