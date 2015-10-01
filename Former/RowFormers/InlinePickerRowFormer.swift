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
: CustomRowFormer<T>, InlineRow, FormerValidatable {
    
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
        
        if let row = cell as? InlinePickerFormableRow {
            let titleLabel = row.formTitleLabel()
            let displayLabel = row.formDisplayLabel()
            if valueTitles.isEmpty {
                displayLabel?.text = ""
            } else {
                displayLabel?.text = valueTitles[selectedRow]
            }
            
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
                titleLabel?.textColor = titleDisabledColor
                displayLabel?.textColor = displayDisabledColor
            }
        }
        
        if let pickerRowFormer = inlineRowFormer as? PickerRowFormer<FormPickerCell> {
            pickerRowFormer.onValueChanged = valueChanged
            pickerRowFormer.valueTitles = valueTitles
            pickerRowFormer.selectedRow = selectedRow
            pickerRowFormer.enabled = enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormPickerCell? -> Void)) {
        update(inlineRowFormer.cell as? FormPickerCell)
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
        if let row = cell as? InlinePickerFormableRow where enabled {
            let titleLabel = row.formTitleLabel()
            let displayLabel = row.formDisplayLabel()
            titleColor ?= titleLabel?.textColor
            displayTextColor ?= displayLabel?.textColor
            titleLabel?.textColor =? titleEditingColor
            displayLabel?.textColor =? displayEditingColor
            isEditing = true
        }
    }
    
    public func editingDidEnd() {
        if let row = cell as? InlinePickerFormableRow {
            isEditing = false
            let titleLabel = row.formTitleLabel()
            let displayLabel = row.formDisplayLabel()
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

        }
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    private func valueChanged(row: Int, title: String) {
        if let pickerRow = cell as? InlinePickerFormableRow where enabled {
            selectedRow = row
            pickerRow.formDisplayLabel()?.text = title
            onValueChanged?(row, title)
        }
    }
}