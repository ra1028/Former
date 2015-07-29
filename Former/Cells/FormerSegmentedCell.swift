//
//  FormerSegmentedCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerSegmentedCell: FormerCell, SegmentedFormableRow {
    
    private weak var titleLabel: UILabel!
    private weak var segmentedControl: UISegmentedControl!
    
    public func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    public func formerSegmented() -> UISegmentedControl {
        
        return self.segmentedControl
    }
    
    override public func configureViews() {
        
        super.configureViews()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(segmentedControl, atIndex: 0)
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
        ]
        let centerYConst = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self.contentView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0
        )
        self.contentView.addConstraints(constraints.flatMap { $0 } + [centerYConst])
    }
}