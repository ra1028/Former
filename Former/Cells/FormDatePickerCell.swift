//
//  FormDatePickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormDatePickerCell: FormCell, DatePickerFormableRow {
    
    // MARK: Public
    
    public private(set) weak var datePicker: UIDatePicker!
    
    public func formDatePicker() -> UIDatePicker {
        return datePicker
    }
    
    public override func setup() {
        super.setup()
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(datePicker, atIndex: 0)
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
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}