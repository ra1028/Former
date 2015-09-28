//
//  FormerSwitchCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerSwitchCell: FormerCell, SwitchFormableRow {
    
    public let observer = FormerObserver()
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var switchButton: UISwitch!
    
    public func formerTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formerSwitch() -> UISwitch {
        return switchButton
    }
    
    public override func configureViews() {
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let switchButton = UISwitch()
        accessoryView = switchButton
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
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}