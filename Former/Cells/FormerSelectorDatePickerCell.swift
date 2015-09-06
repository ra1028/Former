//
//  FormerSelectorDatePickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerSelectorDatePickerCell: UITableViewCell, SelectorDatePickerFormableRow {
    
    public var selectorDatePicker: UIDatePicker?
    public var selectorAccessoryView: UIView?
    private var titleLabel: UILabel!
    private var displayLabel: UILabel!
    private var displayLabelRightConst: NSLayoutConstraint!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerDisplayLabel() -> UILabel? {
        
        return self.displayLabel
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {
        
        self.displayLabelRightConst.constant = (self.accessoryType == .None) ? -15.0 : 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }
    
    private func configureViews() {
        
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.textLabel?.backgroundColor = .clearColor()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(displayLabel, atIndex: 0)
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
        ]
        let displayLabelRightConst = NSLayoutConstraint(
            item: displayLabel,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        self.contentView.addConstraints(constraints.flatMap { $0 } + [displayLabelRightConst])
        self.displayLabelRightConst = displayLabelRightConst
    }
}