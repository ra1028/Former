//
//  InlinePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol InlinePickerFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

public class InlinePickerRowFormer<T: UITableViewCell where T: InlinePickerFormableRow>
: CustomRowFormer<T>, FormInlinable, FormValidatable {
    
    // MARK: Public
    
    public let inlineRowFormer: RowFormer
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValidate: ((Int, String) -> Bool)?

    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    public init(
        instantiateType: Former.InstantiateType = .Class,
        inlineCellSetup: (FormPickerCell -> Void)? = nil,
        cellSetup: (T -> Void)?) {
            inlineRowFormer = PickerRowFormer<FormPickerCell>(instantiateType: .Class, cellSetup: inlineCellSetup)
            super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if valueTitles.isEmpty {
            displayLabel?.text = ""
        } else {
            displayLabel?.text = valueTitles[selectedRow]
        }
        
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
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
        
        if let pickerRowFormer = inlineRowFormer as? PickerRowFormer<FormPickerCell> {
            pickerRowFormer.onValueChanged = valueChanged
            pickerRowFormer.valueTitles = valueTitles
            pickerRowFormer.selectedRow = selectedRow
            pickerRowFormer.enabled = enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormPickerCell -> Void)) {
        let inlineRowFormer = self.inlineRowFormer as! PickerRowFormer<FormPickerCell>
        update(inlineRowFormer.cell)
    }

    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    public func validate() -> Bool {
        let row = selectedRow
        let title = valueTitles[row]
        return onValidate?(row, title) ?? true
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
        isEditing = false
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
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    private func valueChanged(row: Int, title: String) {
        if enabled {
            selectedRow = row
            cell.formDisplayLabel()?.text = title
            onValueChanged?(row, title)
        }
    }
}