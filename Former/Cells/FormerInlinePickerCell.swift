//
//  FormerInlinePickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerInlinePickerCell: FormerCell, InlinePickerFormableRow {
    
    private var titleLabel: UILabel!
    private var displayField: UITextField!
    private var displayFieldRightConst: NSLayoutConstraint!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerDisplayFieldView() -> UITextField? {
        
        return self.displayField
    }
    
    public override func configureWithRowFormer(rowFormer: RowFormer) {
        
        super.configureWithRowFormer(rowFormer)
        
        self.displayFieldRightConst.constant =
            (self.accessoryType == .None && self.accessoryView == nil) ? -15.0 : 0
    }
    
    public override func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayField = UITextField()
        displayField.textColor = .lightGrayColor()
        displayField.textAlignment = .Right
        displayField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(displayField, atIndex: 0)
        self.displayField = displayField
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[display]-0-|",
                options: [],
                metrics: nil,
                views: ["display": displayField]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[title(>=0)]-10-[display(>=0)]",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayField]
            )
        ]
        let displayFieldRightConst = NSLayoutConstraint(
            item: displayField,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        self.contentView.addConstraints(constraints.flatMap { $0 } + [displayFieldRightConst])
        self.displayFieldRightConst = displayFieldRightConst
    }
}