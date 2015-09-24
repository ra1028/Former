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
        return self.enabled
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
            
            self.inlineRowFormer = DatePickerRowFormer(
                cellType: FormerDatePickerCell.self,
                instantiateType: .Class,
                cellConfiguration: inlineCellConfiguration
            )
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onDateChanged = onDateChanged
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.displayTextFromDate?(self.date) ?? "\(self.date)"
            
            if self.enabled {
                
                if self.isEditing {
                    self.titleColor ?= titleLabel?.textColor
                    self.displayTextColor ?= displayLabel?.textColor
                    titleLabel?.textColor =? self.titleEditingColor
                    displayLabel?.textColor =? self.displayEditingColor
                } else {
                    titleLabel?.textColor =? self.titleColor
                    displayLabel?.textColor =? self.displayTextColor
                    self.titleColor = nil
                    self.displayTextColor = nil
                }
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor =? self.titleDisabledColor
                displayLabel?.textColor =? self.displayDisabledColor
            }
        }
        
        if let pickerRowFormer = self.inlineRowFormer as? DatePickerRowFormer {
            
            pickerRowFormer.onDateChanged = self.dateChanged
            pickerRowFormer.date = self.date
            pickerRowFormer.enabled = self.enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormerDatePickerCell? -> Void)) {
        
        update(self.inlineRowFormer.cell as? FormerDatePickerCell)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
    }
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.date) ?? true
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
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            
            self.titleColor ?= titleLabel?.textColor
            self.displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor =? self.titleEditingColor
            displayLabel?.textColor =? self.displayEditingColor
            self.isEditing = true
        }
    }
    
    public func editingDidEnd() {
        
        if let row = self.cell as? InlineDatePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                displayLabel?.textColor =? self.displayTextColor
                self.titleColor = nil
                self.displayTextColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.displayTextColor ?= displayLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
                displayLabel?.textColor = self.displayDisabledColor
            }
            self.isEditing = false
        }
    }
}