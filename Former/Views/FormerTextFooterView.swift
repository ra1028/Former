//
//  FormerTextFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextFooterView: FormerHeaderFooterView, TextFormableView {
    
    private weak var formerTextLabel: UILabel!
    
    public func formableTextLabel() -> UILabel {
        
        return self.formerTextLabel
    }
    
    override public func setup() {
        
        super.setup()
        
        let formerTextLabel = UILabel()
        formerTextLabel.textAlignment = .Center
        formerTextLabel.numberOfLines = 0
        formerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(formerTextLabel, atIndex: 0)
        self.formerTextLabel = formerTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-5-[label]-5-|",
                options: [],
                metrics: nil,
                views: ["label": formerTextLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": formerTextLabel]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}