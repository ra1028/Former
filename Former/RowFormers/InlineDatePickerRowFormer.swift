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

public final class InlineDatePickerRowFormer<T: UITableViewCell where T: InlineDatePickerFormableRow>
: CustomRowFormer<T>, InlineForm, ConfigurableForm {
    
    // MARK: Public
    
    public let inlineRowFormer: RowFormer
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
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
    
    public final func onDateChanged(handler: (NSDate -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    public final func displayTextFromDate(handler: (NSDate -> String)) -> Self {
        displayTextFromDate = handler
        return self
    }
    
    public override func update() {
        super.update()
        
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor }
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            _ = titleDisabledColor.map { titleLabel?.textColor = $0 }
            _ = displayDisabledColor.map { displayLabel?.textColor = $0 }
        }
        
        let inlineRowFormer = self.inlineRowFormer as! DatePickerRowFormer<FormDatePickerCell>
        inlineRowFormer.configure {
            $0.onDateChanged = dateChanged
            $0.date = date
            $0.enabled = enabled
        }.update()
    }
    
    public final func inlineCellUpdate(@noescape update: (FormDatePickerCell -> Void)) {
        let inlineRowFormer = self.inlineRowFormer as! DatePickerRowFormer<FormDatePickerCell>
        update(inlineRowFormer.cell)
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    private func dateChanged(date: NSDate) {
        if enabled {
            self.date = date
            cell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
        isEditing = false
    }
    
    // MARK: Private
    
    private final var onDateChanged: (NSDate -> Void)?
    private final var displayTextFromDate: (NSDate -> String)?
    private final var titleColor: UIColor?
    private final var displayTextColor: UIColor?
}