//
//  FormLabelFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormLabelFooterView: FormHeaderFooterView, LabelFormableView {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    
    public func formTitleLabel() -> UILabel {
        return titleLabel
    }
    
    override open func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.textColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[label]-5-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
