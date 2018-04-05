//
//  FormSegmentedCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormSegmentedCell: FormCell, SegmentedFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var segmentedControl: UISegmentedControl!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formSegmented() -> UISegmentedControl {
        return segmentedControl
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(segmentedControl, at: 0)
        self.segmentedControl = segmentedControl
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:[segment(30)]",
                options: [],
                metrics: nil,
                views: ["segment": segmentedControl]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title(>=0)]->=0-[segment(>=0)]-15-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "segment": segmentedControl]
            )
            ].flatMap { $0 }
        let centerYConst = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        contentView.addConstraints(constraints + [centerYConst])
    }
}
