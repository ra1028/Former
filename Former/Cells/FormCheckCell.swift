//
//  FormCheckCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormCheckCell: FormCell, CheckFormableRow {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[label]-0-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-15-[label(>=0)]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
