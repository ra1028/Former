//
//  FormerTextHeaderView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextHeaderView: FormerHeaderFooterView, TextFormableView {
    
    private weak var headerTextLabel: UILabel!
    
    public func formerTextLabel() -> UILabel? {
        
        return self.headerTextLabel
    }
    
    override public func setup() {
        
        super.setup()
        
        let headerTextLabel = UILabel()
        headerTextLabel.font = UIFont.systemFontOfSize(14.0)
        headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.baseView.insertSubview(headerTextLabel, atIndex: 0)
        self.headerTextLabel = headerTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[label(>=0)]-5-|",
                options: [],
                metrics: nil,
                views: ["label": headerTextLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": headerTextLabel]
            )
        ]
        self.baseView.addConstraints(constraints.flatMap { $0 })
    }
}