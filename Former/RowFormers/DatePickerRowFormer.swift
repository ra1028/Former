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

open class DatePickerRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: DatePickerFormableRow {
    
    // MARK: Public
    
    open var date: Date = Date()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onDateChanged(_ handler: @escaping ((Date) -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    open override func initialized() {
        super.initialized()
        rowHeight = 216
    }
    
    open override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        cell.formDatePicker().addTarget(self, action: #selector(DatePickerRowFormer.dateChanged(datePicker:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let datePicker = cell.formDatePicker()
        datePicker.setDate(date, animated: false)
        datePicker.isUserInteractionEnabled = enabled
        datePicker.layer.opacity = enabled ? 1 : 0.5
    }
    
    // MARK: Private
    
    private final var onDateChanged: ((Date) -> Void)?
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        if enabled {
            let date = datePicker.date
            self.date = date
            onDateChanged?(date)
        }
    }
}
