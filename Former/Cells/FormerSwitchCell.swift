//
//  FormerSwitchCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerSwitchCell: UITableViewCell, SwitchFormableRow {
    
    public let observer = FormerObserver()
    
    private weak var titleLabel: UILabel!
    private weak var switchButton: UISwitch!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerSwitch() -> UISwitch {
        
        return self.switchButton
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {}
    
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let switchButton = UISwitch()
        self.accessoryView = switchButton
        self.switchButton = switchButton

        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[label]-0-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[label(>=0)]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}