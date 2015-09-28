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

public class InlineDatePickerRowFormer: RowFormer, InlineRow, FormerValidatable {
    
    public let inlineRowFormer: RowFormer
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValidate: (NSDate -> Bool)?
    
    public var onDateChanged: (NSDate -> Void)?
    public var displayTextFromDate: (NSDate -> String)?
    public var date: NSDate = NSDate()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayEditingColor: UIColor?
    public var titleEditingColor: UIColor?
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    public init<T : UITableViewCell where T : InlineDatePickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onDateChanged: (NSDate -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil,
        inlineCellConfiguration: (FormerDatePickerCell -> Void)? = nil) {
            inlineRowFormer = DatePickerRowFormer(
                cellType: FormerDatePickerCell.self,
                instantiateType: .Class,
                cellConfiguration: inlineCellConfiguration
            )
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onDateChanged = onDateChanged
    }
    
    public override func update() {
        super.update()
        
        if let row = cell as? InlineDatePickerFormableRow {
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
            
            if enabled {
                if isEditing {
                    titleColor ?= titleLabel?.textColor
                    displayTextColor ?= displayLabel?.textColor
                    titleLabel?.textColor =? titleEditingColor
                    displayLabel?.textColor =? displayEditingColor
                } else {
                    titleLabel?.textColor =? titleColor
                    displayLabel?.textColor =? displayTextColor
                    titleColor = nil
                    displayTextColor = nil
                }
            } else {
                titleColor ?= titleLabel?.textColor
                displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor =? titleDisabledColor
                displayLabel?.textColor =? displayDisabledColor
            }
        }
        
        if let pickerRowFormer = inlineRowFormer as? DatePickerRowFormer {
            pickerRowFormer.onDateChanged = dateChanged
            pickerRowFormer.date = date
            pickerRowFormer.enabled = enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormerDatePickerCell? -> Void)) {
        update(inlineRowFormer.cell as? FormerDatePickerCell)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    public func validate() -> Bool {
        return onValidate?(date) ?? true
    }
    
    private func dateChanged(date: NSDate) {
        if let row = cell as? InlineDatePickerFormableRow where enabled {
            self.date = date
            row.formerDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        if let row = cell as? InlineDatePickerFormableRow where enabled {
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor =? titleEditingColor
            displayLabel?.textColor =? displayEditingColor
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        if let row = cell as? InlineDatePickerFormableRow {
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            if enabled {
                titleLabel?.textColor =? titleColor
                displayLabel?.textColor =? displayTextColor
                titleColor = nil
                displayTextColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
                displayLabel?.textColor = displayDisabledColor
            }
            isEditing = false
        }
    }
}