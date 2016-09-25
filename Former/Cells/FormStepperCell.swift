//
//  FormStepperCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormStepperCell: FormCell, StepperFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var displayLabel: UILabel!
    public private(set) weak var stepper: UIStepper!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    public func formStepper() -> UIStepper {
        return stepper
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGray
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, at: 0)
        self.displayLabel = displayLabel
        
        let stepper = UIStepper()
        accessoryView = stepper
        self.stepper = stepper
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[display]-0-|",
                options: [],
                metrics: nil,
                views: ["display": displayLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-(>=0)-[display]-5-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
