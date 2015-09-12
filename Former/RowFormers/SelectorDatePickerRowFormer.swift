//
//  SelectorDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SelectorDatePickerFormableRow: FormableRow {
    
    var selectorDatePicker: UIDatePicker? { get set } // Not need to set UIDatePicker instance.
    var selectorAccessoryView: UIView? { get set } // Not need to set UIView instance.
    
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class SelectorDatePickerRowFormer: RowFormer, FormerValidatable {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: (NSDate -> Bool)?
    
    public var onDateChanged: (NSDate -> Void)?
    public var displayTextFromDate: (NSDate -> String)?
    @NSCopying public var calendar: NSCalendar?
    public var date: NSDate = NSDate()
    public var minuteInterval: Int?
    public var minimumDate: NSDate?
    public var maximumDate: NSDate?
    public var countDownDuration: NSTimeInterval?
    public var datePickerMode: UIDatePickerMode?
    public var locale: NSLocale?
    public var timeZone: NSTimeZone?
    public var pickerBackgroundColor: UIColor?
    public var inputAccessoryView: UIView?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleAlignment: NSTextAlignment?
    public var titleNumberOfLines: Int?
    
    public var displayTextFont: UIFont?
    public var displayTextColor: UIColor?
    public var displayDisabledColor: UIColor?
    public var displayTextAlignment: NSTextAlignment?
    
    deinit {
        self.inputView.removeTarget(self, action: nil, forControlEvents: .AllEvents)
    }
    
    private lazy var inputView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
        return datePicker
        }()
    
    public init<T: UITableViewCell where T: SelectorDatePickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onDateChanged: (NSDate -> Void)? = nil) {
            super.init(cellType: cellType, registerType: registerType)
            self.onDateChanged = onDateChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
        self.displayTextColor = .lightGrayColor()
        self.displayDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        self.inputView.calendar = self.calendar
        self.inputView.minuteInterval =? self.minuteInterval
        self.inputView.minimumDate = self.minimumDate
        self.inputView.maximumDate = self.maximumDate
        self.inputView.countDownDuration =? self.countDownDuration
        self.inputView.datePickerMode =? self.datePickerMode
        self.inputView.locale = self.locale
        self.inputView.timeZone = self.timeZone
        self.inputView.date = self.date
        self.inputView.backgroundColor = self.pickerBackgroundColor
        
        if let row = self.cell as? SelectorDatePickerFormableRow {
            
            row.selectorDatePicker = self.inputView
            row.selectorAccessoryView = self.inputAccessoryView
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textAlignment =? self.titleAlignment
            titleLabel?.numberOfLines =? self.titleNumberOfLines
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromDate?(self.date) ?? "\(self.date)"
            displayLabel?.font =? self.displayTextFont
            displayLabel?.textAlignment =? self.displayTextAlignment
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                displayLabel?.textColor =? self.displayTextColor
            } else {
                titleLabel?.textColor =? self.titleDisabledColor
                displayLabel?.textColor =? self.displayDisabledColor
            }
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
        
        if self.enabled {
            self.cell?.becomeFirstResponder()
        }
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.date) ?? true
    }
    
    public dynamic func dateChanged(datePicker: UIDatePicker) {
        
        if let row = self.cell as? SelectorDatePickerFormableRow where self.enabled {
            let date = datePicker.date
            self.date = date
            row.formerDisplayLabel()?.text = self.displayTextFromDate?(date) ?? "\(date)"
            self.onDateChanged?(date)
        }
    }
}