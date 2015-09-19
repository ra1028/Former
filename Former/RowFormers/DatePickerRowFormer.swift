//
//  DatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol DatePickerFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
    func formerDatePicker() -> UIDatePicker
}

public class DatePickerRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: (NSDate -> Bool)?
    
    public var onDateChanged: (NSDate -> Void)?
    public var date: NSDate = NSDate()
    
    public init<T : UITableViewCell where T : DatePickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onDateChanged: (NSDate -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType)
            self.onDateChanged = onDateChanged
    }
    
    public override func initialize() {
        
        super.initialize()
        self.cellHeight = 216.0
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? DatePickerFormableRow {
            
            let datePicker = row.formerDatePicker()
            datePicker.setDate(self.date, animated: false)
            datePicker.userInteractionEnabled = self.enabled
            datePicker.alpha = self.enabled ? 1.0 : 0.5
            
            row.observer.setTargetRowFormer(self,
                control: datePicker,
                actionEvents: [("dateChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.date) ?? true
    }
    
    public dynamic func dateChanged(datePicker: UIDatePicker) {
        
        if self.enabled {
            let date = datePicker.date
            self.date = date
            self.onDateChanged?(date)
        }
    }
}