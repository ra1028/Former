//
//  FormerTextCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextCell: FormerCell, TextFormableRow {
    
    private var subTextLabel: UILabel!
    private var subTextLabelRightConst: NSLayoutConstraint!
    
    public func formerTextLabel() -> UILabel? {
        
        return self.textLabel
    }
    
    public func formerSubTextLabel() -> UILabel? {
        
        return self.subTextLabel
    }
    
    public override func configureWithRowFormer(rowFormer: RowFormer) {
        
        super.configureWithRowFormer(rowFormer)
        
        self.subTextLabelRightConst.constant = (self.accessoryType == .None) ? -15.0 : 0
    }
    
    public override func configureViews() {
        
        super.configureViews()
        
        let subTextLabel = UILabel()
        subTextLabel.textColor = .lightGrayColor()
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(subTextLabel, atIndex: 0)
        self.subTextLabel = subTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[label]-0-|",
                options: [],
                metrics: nil,
                views: ["label": subTextLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[label(>=0)]",
                options: [],
                metrics: nil,
                views: ["label": subTextLabel]
            )
        ]
        let subTextLabelRightConst = NSLayoutConstraint(
            item: subTextLabel,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        self.contentView.addConstraints(constraints.flatMap { $0 } + [subTextLabelRightConst])
        self.subTextLabelRightConst = subTextLabelRightConst
    }
}