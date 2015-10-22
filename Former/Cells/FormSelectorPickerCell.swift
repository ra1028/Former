//
//  FormSelectorPickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormSelectorPickerCell: FormCell, SelectorPickerFormableRow {
    
    // MARK: Public
    
    public var selectorPickerView: UIPickerView?
    public var selectorAccessoryView: UIView?
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var displayLabel: UILabel!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    public override func updateWithRowFormer(rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        rightConst.constant = (accessoryType == .None) ? -15 : 0
    }
    
    public override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGrayColor()
        displayLabel.textAlignment = .Right
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, atIndex: 0)
        self.displayLabel = displayLabel
        
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
                views: ["display": displayLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[title]-10-[display(>=0)]",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            )
            ].flatMap { $0 }
        let rightConst = NSLayoutConstraint(
            item: displayLabel,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0
        )        
        contentView.addConstraints(constraints + [rightConst])
        self.rightConst = rightConst
    }
    
    // MARK: Private
    
    private weak var rightConst: NSLayoutConstraint!
}