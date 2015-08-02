//
//  FormerDatePickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerDatePickerCell: FormerCell, DatePickerFormableRow {
    
    private weak var datePicker: UIDatePicker!
    
    public func formerDatePicker() -> UIDatePicker {
        
        return self.datePicker
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.datePicker.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    }
    
    override public func configureViews() {
        
        super.configureViews()
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(datePicker, atIndex: 0)
        self.datePicker = datePicker
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-15-[picker]-15-|",
                options: [],
                metrics: nil,
                views: ["picker": datePicker]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": datePicker]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}