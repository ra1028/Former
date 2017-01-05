//
//  FormLabelCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormLabelCell: FormCell, LabelFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var subTextLabel: UILabel!
    
    public func formTextLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formSubTextLabel() -> UILabel? {
        return subTextLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        rightConst.constant = (accessoryType == .none) ? -15 : 0
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let subTextLabel = UILabel()
        subTextLabel.textColor = .lightGray
        subTextLabel.textAlignment = .right
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(subTextLabel, at: 0)
        self.subTextLabel = subTextLabel
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[sub]-0-|",
                options: [],
                metrics: nil,
                views: ["sub": subTextLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-10-[sub(>=0)]",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "sub": subTextLabel]
            )
            ].flatMap { $0 }
        let rightConst = NSLayoutConstraint(
            item: subTextLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        contentView.addConstraints(constraints + [rightConst])
        self.rightConst = rightConst
    }
    
    // MARK: Private
    
    private weak var rightConst: NSLayoutConstraint!
}
