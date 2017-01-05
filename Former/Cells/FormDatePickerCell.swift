//
//  FormDatePickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormDatePickerCell: FormCell, DatePickerFormableRow {
    
    // MARK: Public
    
    public private(set) weak var datePicker: UIDatePicker!
    
    public func formDatePicker() -> UIDatePicker {
        return datePicker
    }
    
    open override func setup() {
        super.setup()
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(datePicker, at: 0)
        self.datePicker = datePicker
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[picker]-15-|",
                options: [],
                metrics: nil,
                views: ["picker": datePicker]
            ),
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": datePicker]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
