//
//  FormerTextViewCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/28/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextViewCell: FormerCell, TextViewFormableRow {
    
    public private(set) weak var textView: UITextView!
    public private(set) weak var titleLabel: UILabel!
    
    private weak var leftConst: NSLayoutConstraint!
    
    public func formerTextView() -> UITextView {
        return textView
    }
    
    public func formerTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public override func updateWithRowFormer(rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)

        leftConst.constant = titleLabel.text?.isEmpty ?? true ? 5.0 : 15.0
    }
    
    public override func configureViews() {
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let textView = UITextView()
        textView.backgroundColor = .clearColor()
        textView.font = .systemFontOfSize(17.0)
        textView.contentSize.height = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(textView, atIndex: 0)
        self.textView = textView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[label(>=0)]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[text]-0-|",
                options: [],
                metrics: nil,
                views: ["text": textView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[label]-5-[text]-10-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel, "text": textView]
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
        contentView.addConstraints(constraints + [leftConst])
        self.leftConst = leftConst
    }
}