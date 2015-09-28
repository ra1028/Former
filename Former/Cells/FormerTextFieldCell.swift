//
//  FormerTextFieldCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextFieldCell: FormerCell, TextFieldFormableRow {
    
    public let observer = FormerObserver()
    
    public private(set) weak var textField: UITextField!
    public private(set) weak var titleLabel: UILabel!
    
    private weak var leftConst: NSLayoutConstraint!
    private weak var rightConst: NSLayoutConstraint!

    public func formerTextField() -> UITextField {
        return textField
    }
    
    public func formerTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public override func updateWithRowFormer(rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        
        leftConst.constant = titleLabel.text?.isEmpty ?? true ? 5.0 : 15.0
        rightConst.constant = (textField.textAlignment == .Right) ? -15.0 : 0
    }
    
    public override func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: UILayoutConstraintAxis.Horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let textField = UITextField()
        textField.backgroundColor = .clearColor()
        textField.clearButtonMode = .WhileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(textField, atIndex: 0)
        self.textField = textField
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[label]-0-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[field]-0-|",
                options: [],
                metrics: nil,
                views: ["field": textField]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[label]-10-[field]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel, "field": textField]
            )
            ].flatMap { $0 }
        let leftConst = NSLayoutConstraint(
            item: titleLabel,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 15.0
        )
        let rightConst = NSLayoutConstraint(
            item: textField,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        contentView.addConstraints(constraints + [leftConst, rightConst])
        self.leftConst = leftConst
        self.rightConst = rightConst
    }
}