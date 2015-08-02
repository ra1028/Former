//
//  FormerSliderCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerSliderCell: FormerCell, SliderFormableRow {
    
    private weak var titleLabel: UILabel!
    private weak var displayLabel: UILabel!
    private weak var slider: UISlider!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerDisplayLabel() -> UILabel? {
        
        return self.displayLabel
    }
    
    public func formerSlider() -> UISlider {
        
        return self.slider
    }
    
    public override func prepareForReuse() {
        
        super.prepareForReuse()
        self.slider.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    }
    
    override public func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGrayColor()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(displayLabel, atIndex: 0)
        self.displayLabel = displayLabel
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(slider, atIndex: 0)
        self.slider = slider
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[title(>=0)]->=0-[slider(>=0)]-10-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "slider": slider]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-10-[display(>=0)]->=0-[slider(>=0)]-10-|",
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
                "H:|-15-[slider]-15-|",
                options: [],
                metrics: nil,
                views: ["slider": slider]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}