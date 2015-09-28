//
//  FormerTextHeaderView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextHeaderView: FormerHeaderFooterView, TextFormableView {
    
    public private(set) weak var titleLabel: UILabel!
    
    public func formerTextLabel() -> UILabel {
        return titleLabel
    }
    
    override public func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[label(>=0)]-5-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}