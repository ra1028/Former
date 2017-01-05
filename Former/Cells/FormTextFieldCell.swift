//
//  FormTextFieldCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormTextFieldCell: FormCell, TextFieldFormableRow {
    
    // MARK: Public
    
    public private(set) weak var textField: UITextField!
    public private(set) weak var titleLabel: UILabel!

    public func formTextField() -> UITextField {
        return textField
    }
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        leftConst.constant = titleLabel.text?.isEmpty ?? true ? 5 : 15
        rightConst.constant = (textField.textAlignment == .right) ? -15 : 0
    }
    
    open override func setup() {
        
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, for: UILayoutConstraintAxis.horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(textField, at: 0)
        self.textField = textField
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[label]-0-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[field]-0-|",
                options: [],
                metrics: nil,
                views: ["field": textField]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:[label]-10-[field]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel, "field": textField]
            )
            ].flatMap { $0 }
        let leftConst = NSLayoutConstraint(
            item: titleLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .leading,
            multiplier: 1,
            constant: 15
        )
        let rightConst = NSLayoutConstraint(
            item: textField,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        contentView.addConstraints(constraints + [leftConst, rightConst])
        self.leftConst = leftConst
        self.rightConst = rightConst
    }
    
    // MARK: Private
    
    private weak var leftConst: NSLayoutConstraint!
    private weak var rightConst: NSLayoutConstraint!
}
