//
//  FormSegmentedCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormSegmentedCell: FormCell, SegmentedFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var segmentedControl: UISegmentedControl!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formSegmented() -> UISegmentedControl {
        return segmentedControl
    }
    
    public override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(segmentedControl, atIndex: 0)
        self.segmentedControl = segmentedControl
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[segment(30)]",
                options: [],
                metrics: nil,
                views: ["segment": segmentedControl]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[title(>=0)]->=0-[segment(>=0)]-15-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "segment": segmentedControl]
            )
            ].flatMap { $0 }
        let centerYConst = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0
        )
        contentView.addConstraints(constraints + [centerYConst])
    }
}