//
//  FormerTextCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerTextCell: UITableViewCell, TextFormableRow {
    
    private var titleLabel: UILabel!
    private var subTextLabel: UILabel!
    private var subTextLabelRightConst: NSLayoutConstraint!
    
    public func formerTextLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerSubTextLabel() -> UILabel? {
        
        return self.subTextLabel
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {
        
        self.subTextLabelRightConst.constant = (self.accessoryType == .None) ? -15.0 : 0
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
        
        let subTextLabel = UILabel()
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(subTextLabel, atIndex: 0)
        self.subTextLabel = subTextLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[sub]-0-|",
                options: [],
                metrics: nil,
                views: ["sub": subTextLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[title]-10-[sub(>=0)]",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "sub": subTextLabel]
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