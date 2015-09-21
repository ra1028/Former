//
//  InlinePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol InlinePickerFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
}

public class InlinePickerRowFormer: RowFormer, InlineRow, FormerValidatable {
    
    public let inlineRowFormer: RowFormer
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: ((Int, String) -> Bool)?

    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var displayDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var displayEditingColor: UIColor?
    
    private var titleColor: UIColor?
    private var displayTextColor: UIColor?
    
    public init<T : UITableViewCell where T : InlinePickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: ((Int, String) -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil,
        inlineCellConfiguration: (FormerPickerCell -> Void)? = nil) {
            
            self.inlineRowFormer = PickerRowFormer(
                cellType: FormerPickerCell.self,
                instantiateType: .Class,
                cellConfiguration: inlineCellConfiguration
            )
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.onValueChanged = onValueChanged
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? InlinePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let displayLabel = row.formerDisplayLabel()
            
            if self.valueTitles.isEmpty {
                displayLabel?.text = ""
            } else {
                displayLabel?.text = self.valueTitles[self.selectedRow]
            }
            
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
                titleLabel?.textColor = self.titleDisabledColor
                displayLabel?.textColor = self.displayDisabledColor
            }
        }
        
        if let pickerRowFormer = self.inlineRowFormer as? PickerRowFormer {
            
            pickerRowFormer.onValueChanged = self.valueChanged
            pickerRowFormer.valueTitles = self.valueTitles
            pickerRowFormer.selectedRow = self.selectedRow
            pickerRowFormer.enabled = self.enabled
            pickerRowFormer.update()
        }
    }
    
    public final func inlineCellUpdate(@noescape update: (FormerPickerCell -> Void)) {
        
        if let inlineCell = self.inlineRowFormer.cell as? FormerPickerCell {
            update(inlineCell)
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
    }
    
    public func validate() -> Bool {
        
        let row = self.selectedRow
        let title = self.valueTitles[row]
        return self.onValidate?(row, title) ?? true
    }
    
    private func valueChanged(row: Int, title: String) {
        
        if let pickerRow = self.cell as? InlinePickerFormableRow where self.enabled {
            self.selectedRow = row
            pickerRow.formerDisplayLabel()?.text = title
            self.onValueChanged?(row, title)
        }
    }
    
    public func editingDidBegin() {
        
        if let row = self.cell as? InlinePickerFormableRow where self.enabled {
            
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
        
        if let row = self.cell as? InlinePickerFormableRow {
            self.isEditing = false
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

        }
    }
}