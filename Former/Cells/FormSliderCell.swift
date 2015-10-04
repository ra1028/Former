//
//  FormSliderCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormSliderCell: FormCell, SliderFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var displayLabel: UILabel!
    public private(set) weak var slider: UISlider!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    public func formSlider() -> UISlider {
        return slider
    }
    
    public override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGrayColor()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, atIndex: 0)
        self.displayLabel = displayLabel
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(slider, atIndex: 0)
        self.slider = slider
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[title(>=0)]->=0-[slider(>=0)]-10-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "slider": slider]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[display(>=0)]->=0-[slider(>=0)]",
                options: [],
                metrics: nil,
                views: ["display": displayLabel, "slider": slider]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[title(>=0)]->=0-[display(>=0)]-15-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[slider]-20-|",
                options: [],
                metrics: nil,
                views: ["slider": slider]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}