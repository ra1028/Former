//
//  FormerTextHeaderView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextHeaderView: FormerHeaderFooterView, TextFormableView {
    
    private weak var formerTextLabel: UILabel!
    
    public func formableTextLabel() -> UILabel {
        
        return self.formerTextLabel
    }
    
    override public func setup() {
        
        super.setup()
        
        let formerTextLabel = UILabel()
        formerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(formerTextLabel, atIndex: 0)
        self.formerTextLabel = formerTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[label(>=0)]-5-|",
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
        self.addConstraints(constraints.flatMap { $0 })
    }
}