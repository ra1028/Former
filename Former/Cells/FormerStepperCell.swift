//
//  FormerStepperCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerStepperCell: FormerCell, StepperFormableRow {
    
    private weak var titleLabel: UILabel!
    private weak var displayLabel: UILabel!
    private weak var stepper: UIStepper!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerDisplayLabel() -> UILabel? {
        
        return self.displayLabel
    }
    
    public func formerStepper() -> UIStepper {
        
        return self.stepper
    }
    
        public override func prepareForReuse() {
        
        super.prepareForReuse()
        self.stepper.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    }
    
    override public func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(displayLabel, atIndex: 0)
        self.displayLabel = displayLabel
        
        let stepper = UIStepper()
        self.accessoryView = stepper
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
                "H:|-15-[title(>=0)]-[display(>=0)]-5-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}