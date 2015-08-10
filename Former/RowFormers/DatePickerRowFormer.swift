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

public class DatePickerRowFormer: RowFormer {
    
    public var dateChangedHandler: (NSDate -> Void)?
    @NSCopying public var calendar: NSCalendar!
    public var date: NSDate = NSDate()
    public var minuteInterval: Int?
    public var minimumDate: NSDate?
    public var maximumDate: NSDate?
    public var countDownDuration: NSTimeInterval?
    public var datePickerMode: UIDatePickerMode?
    public var locale: NSLocale?
    public var timeZone: NSTimeZone?
    
    init<T : UITableViewCell where T : DatePickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        dateChangedHandler: (NSDate -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.dateChangedHandler = dateChangedHandler
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.cellHeight = 216.0
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? DatePickerFormableRow {
            
            let datePicker = row.formerDatePicker()
            datePicker.calendar =? self.calendar
            datePicker.minuteInterval =? self.minuteInterval
            datePicker.minimumDate =? self.minimumDate
            datePicker.maximumDate =? self.maximumDate
            datePicker.countDownDuration =? self.countDownDuration
            datePicker.datePickerMode =? self.datePickerMode
            datePicker.locale =? self.locale
            datePicker.timeZone =? self.timeZone
            datePicker.setDate(self.date, animated: false)
            datePicker.enabled = self.enabled
            
            row.observer.setTargetRowFormer(self,
                control: datePicker,
                actionEvents: [("dateChanged:", .ValueChanged)]
            )
        }
    }
    
    public func dateChanged(datePicker: UIDatePicker) {
        
        if self.enabled {
            let date = datePicker.date
            self.date = date
            self.dateChangedHandler?(date)
        }
    }
}