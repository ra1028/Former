//
//  CenterLabelCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/8/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class CenterLabelCell: FormCell, LabelFormableRow {
    
    // MARK: Public
    
    func formTextLabel() -> UILabel? {
        return titleLabel
    }
    
    func formSubTextLabel() -> UILabel? {
        return nil
    }
    
    weak var titleLabel: UILabel!
    
    override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.textColor = .formerColor()
        titleLabel.font = .boldSystemFontOfSize(15)
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[titleLabel]-0-|",
                options: [],
                metrics: nil,
                views: ["titleLabel": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[titleLabel]-0-|",
                options: [],
                metrics: nil,
                views: ["titleLabel": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}