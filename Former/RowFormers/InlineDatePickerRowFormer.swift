//
//  InlineDatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol InlineDatePickerFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

public class InlineDatePickerRowFormer<T: UITableViewCell where T: InlineDatePickerFormableRow>
: CustomRowFormer<T>, InlineRow, FormerValidatable {
    
    // MARK: Public
    
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
    
    public init(
        instantiateType: Former.InstantiateType = .Class,
        inlineCellSetup: (FormDatePickerCell -> Void)? = nil,
        cellSetup: (T -> Void)?) {
            inlineRowFormer = DatePickerRowFormer<FormDatePickerCell>(instantiateType: .Class, cellSetup: inlineCellSetup)
            super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        let titleLabel = typedCell.formTitleLabel()
        let displayLabel = typedCell.formDisplayLabel()
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
        
        if let pickerRowFormer = inlineRowFormer as? DatePickerRowFormer<FormDatePickerCell> {
            pickerRowFormer.onDateChanged = dateChanged
            pickerRowFormer.date = date
            pickerRowFormer.enabled = enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormDatePickerCell -> Void)) {
        update(inlineRowFormer.cell as! FormDatePickerCell)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    public func validate() -> Bool {
        return onValidate?(date) ?? true
    }
    
    private func dateChanged(date: NSDate) {
        if enabled {
            self.date = date
            typedCell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = typedCell.formTitleLabel()
            let displayLabel = typedCell.formDisplayLabel()
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor =? titleEditingColor
            displayLabel?.textColor =? displayEditingColor
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        let titleLabel = typedCell.formTitleLabel()
        let displayLabel = typedCell.formDisplayLabel()
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
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
}