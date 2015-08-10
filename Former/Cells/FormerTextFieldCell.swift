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
    
    private weak var textField: UITextField!
    private weak var titleLabel: UILabel!
    private weak var leftConst: NSLayoutConstraint!
    private weak var rightConst: NSLayoutConstraint!

    public func formerTextField() -> UITextField {
        
        return self.textField
    }
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public override func configureWithRowFormer(rowFormer: RowFormer) {
        
        super.configureWithRowFormer(rowFormer)
        
        if let rowFormer = rowFormer as? TextFieldRowFormer {
            self.leftConst.constant = rowFormer.title?.isEmpty ?? true ? 5.0 : 15.0
            self.rightConst.constant = (rowFormer.textAlignment == .Right) ? -15.0 : 0
        }
    }
    
    override public func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let textField = UITextField()
        textField.backgroundColor = .clearColor()
        textField.clearButtonMode = .WhileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(textField, atIndex: 0)
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
        ]
        let leftConst = NSLayoutConstraint(
            item: titleLabel,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 15.0
        )
        let rightConst = NSLayoutConstraint(
            item: textField,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        self.contentView.addConstraints(constraints.flatMap { $0 } + [leftConst, rightConst])
        self.leftConst = leftConst
        self.rightConst = rightConst
    }
}