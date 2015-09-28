//
//  FormerStepperCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerStepperCell: FormerCell, StepperFormableRow {
    
    public let observer = FormerObserver()
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var displayLabel: UILabel!
    public private(set) weak var stepper: UIStepper!
    
    public func formerTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formerDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    public func formerStepper() -> UIStepper {
        return stepper
    }
    
    public override func configureViews() {
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, atIndex: 0)
        self.displayLabel = displayLabel
        
        let stepper = UIStepper()
        accessoryView = stepper
        self.stepper = stepper
        
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
                "H:|-15-[title]-(>=0)-[display]-5-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}