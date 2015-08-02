//
//  FormerTextFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextFooterView: FormerHeaderFooterView, TextFormableView {
    
    private weak var footerTextLabel: UILabel!
    
    public func formerTextLabel() -> UILabel? {
        
        return self.footerTextLabel
    }
    
    override public func setup() {
        
        super.setup()
        
        let footerTextLabel = UILabel()
        footerTextLabel.font = UIFont.systemFontOfSize(14.0)
        footerTextLabel.textAlignment = .Center
        footerTextLabel.numberOfLines = 0
        footerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(footerTextLabel, atIndex: 0)
        self.footerTextLabel = footerTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-5-[label]-5-|",
                options: [],
                metrics: nil,
                views: ["label": footerTextLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": footerTextLabel]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}