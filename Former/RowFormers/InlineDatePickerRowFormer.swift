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
    func formerDisplayFieldView() -> UITextField?
}

public class InlineDatePickerRowFormer: RowFormer, InlinePickableRow {
    
    public private(set) var pickerRowFormer: RowFormer = DatePickerRowFormer(
        cellType: FormerDatePickerCell.self,
        registerType: .Class
    )
    
    public var dateChangedHandler: (NSDate -> Void)?
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
    
    public var placeholder: String?
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
    
    init<T : UITableViewCell where T : InlineDatePickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        dateChangedHandler: (NSDate -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.dateChangedHandler = dateChangedHandler
    }
    
    public override func configureRowFormer() {
        
        super.configureRowFormer()
        self.titleDisabledColor = .lightGrayColor()
        self.displayTextColor = .lightGrayColor()
        self.displayDisabledTextColor = .lightGrayColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
            let displayField = row.formerDisplayFieldView()
            displayField?.text = self.displayTextFromDate?(self.date) ?? "\(self.date)"
            displayField?.placeholder = self.placeholder
            displayField?.font =? self.displayTextFont
            displayField?.textColor = self.enabled ? self.displayTextColor : self.displayDisabledTextColor
            displayField?.textAlignment =? self.displayTextAlignment
            displayField?.userInteractionEnabled = false
        }
        
        if let pickerRowFormer = self.pickerRowFormer as? DatePickerRowFormer {
            
            pickerRowFormer.dateChangedHandler = self.didChangeDate
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
        }
    }
    
    private func didChangeDate(date: NSDate) {
        
        if let row = self.cell as? InlineDatePickerFormableRow where self.enabled {
            self.date = date
            row.formerDisplayFieldView()?.text = self.displayTextFromDate?(date) ?? "\(date)"
            self.dateChangedHandler?(date)
        }
    }
    
    public func editingDidBegin() {
        
        if let row = self.cell as? InlineDatePickerFormableRow where self.enabled {
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
            row.formerDisplayFieldView()?.textColor =? self.displayTextEditingColor
        }
    }
    
    public func editingDidEnd() {
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            row.formerTitleLabel()?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            row.formerDisplayFieldView()?.textColor = self.enabled ? self.displayTextColor : self.displayDisabledTextColor
        }
    }
}