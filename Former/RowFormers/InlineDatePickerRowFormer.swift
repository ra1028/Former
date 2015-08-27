//
//  InlineDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol InlineDatePickerFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class InlineDatePickerRowFormer: RowFormer, InlinePickableRow {
    
    public private(set) var pickerRowFormer: RowFormer = DatePickerRowFormer(
        cellType: FormerDatePickerCell.self,
        registerType: .Class
    )
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onDateChanged: (NSDate -> Void)?
    public var displayTextFromDate: (NSDate -> String)?
    @NSCopying public var calendar: NSCalendar!
    public var date: NSDate = NSDate()
    public var minuteInterval: Int?
    public var minimumDate: NSDate?
    public var maximumDate: NSDate?
    public var countDownDuration: NSTimeInterval?
    public var datePickerMode: UIDatePickerMode?
    public var locale: NSLocale?
    public var timeZone: NSTimeZone?
    
    public var displayTextFont: UIFont?
    public var displayTextColor: UIColor?
    public var displayDisabledTextColor: UIColor?
    public var displayTextAlignment: NSTextAlignment?
    public var displayTextEditingColor: UIColor?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleEditingColor: UIColor?
    
    public init<T : UITableViewCell where T : InlineDatePickerFormableRow>(
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
        self.displayDisabledTextColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ?
                (self.isEditing ? self.titleEditingColor : self.titleColor) :
                self.titleDisabledColor
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromDate?(self.date) ?? "\(self.date)"
            displayLabel?.font =? self.displayTextFont
            displayLabel?.textAlignment =? self.displayTextAlignment
            displayLabel?.textColor = self.enabled ?
                (self.isEditing ? self.displayTextEditingColor : self.displayTextColor) :
                self.displayDisabledTextColor
        }
        
        if let pickerRowFormer = self.pickerRowFormer as? DatePickerRowFormer {
            
            pickerRowFormer.onDateChanged = self.dateChanged
            pickerRowFormer.calendar = self.calendar
            pickerRowFormer.minuteInterval = self.minuteInterval
            pickerRowFormer.minimumDate = self.minimumDate
            pickerRowFormer.maximumDate = self.maximumDate
            pickerRowFormer.countDownDuration = self.countDownDuration
            pickerRowFormer.datePickerMode = self.datePickerMode
            pickerRowFormer.locale = self.locale
            pickerRowFormer.timeZone = self.timeZone
            pickerRowFormer.date = self.date
            pickerRowFormer.enabled = self.enabled
            pickerRowFormer.update()
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
    }
    
    private func dateChanged(date: NSDate) {
        
        if let row = self.cell as? InlineDatePickerFormableRow where self.enabled {
            self.date = date
            row.formerDisplayLabel()?.text = self.displayTextFromDate?(date) ?? "\(date)"
            self.onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        
        if let row = self.cell as? InlineDatePickerFormableRow where self.enabled {
            self.isEditing = true
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
            row.formerDisplayLabel()?.textColor =? self.displayTextEditingColor
        }
    }
    
    public func editingDidEnd() {
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            self.isEditing = false
            row.formerTitleLabel()?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            row.formerDisplayLabel()?.textColor = self.enabled ? self.displayTextColor : self.displayDisabledTextColor
        }
    }
}