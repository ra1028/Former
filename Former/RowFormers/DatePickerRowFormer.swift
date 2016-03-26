//
//  DatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol DatePickerFormableRow: FormableRow {
    
    func formDatePicker() -> UIDatePicker
}

public class DatePickerRowFormer<T: UITableViewCell where T: DatePickerFormableRow>
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    public var date: NSDate = NSDate()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onDateChanged(handler: (NSDate -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    public override func initialized() {
        super.initialized()
        rowHeight = 216
    }
    
    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formDatePicker().addTarget(self, action: #selector(DatePickerRowFormer.dateChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let datePicker = cell.formDatePicker()
        datePicker.setDate(date, animated: false)
        datePicker.userInteractionEnabled = enabled
        datePicker.layer.opacity = enabled ? 1 : 0.5
    }
    
    // MARK: Private
    
    private final var onDateChanged: (NSDate -> Void)?
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        if enabled {
            let date = datePicker.date
            self.date = date
            onDateChanged?(date)
        }
    }
}