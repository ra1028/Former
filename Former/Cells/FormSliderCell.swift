//
//  FormSliderCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormSliderCell: FormCell, SliderFormableRow {
    
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
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(slider, at: 0)
        self.slider = slider
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[title(>=0)]->=0-[slider(>=0)]-10-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "slider": slider]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[display(>=0)]->=0-[slider(>=0)]",
                options: [],
                metrics: nil,
                views: ["display": displayLabel, "slider": slider]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title(>=0)]->=0-[display(>=0)]-15-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[slider]-20-|",
                options: [],
                metrics: nil,
                views: ["slider": slider]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
