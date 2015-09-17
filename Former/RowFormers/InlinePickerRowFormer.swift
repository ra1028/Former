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
    
    public private(set) var inlineRowFormer: RowFormer = PickerRowFormer(
        cellType: FormerPickerCell.self,
        instantiateType: .Class
    )
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: ((Int, String) -> Bool)?

    public var onValueChanged: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var showsSelectionIndicator: Bool?
    
    public var displayTextFont: UIFont?
    public var displayTextColor: UIColor?
    public var displayDisabledColor: UIColor?
    public var displayTextAlignment: NSTextAlignment?
    public var displayTextEditingColor: UIColor?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleEditingColor: UIColor?
    
    public init<T : UITableViewCell where T : InlinePickerFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onValueChanged: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initialize() {
        
        super.initialize()
        self.titleDisabledColor = .lightGrayColor()
        self.displayTextColor = .lightGrayColor()
        self.displayDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? InlinePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            
            let displayLabel = row.formerDisplayLabel()
            displayLabel?.text = self.valueTitles[self.selectedRow]
            displayLabel?.font =? self.displayTextFont
            displayLabel?.textAlignment =? self.displayTextAlignment
            
            if self.enabled {
                
                if self.isEditing {
                    titleLabel?.textColor =? self.titleEditingColor
                    displayLabel?.textColor =? self.displayTextEditingColor
                } else {
                    titleLabel?.textColor =? self.titleColor
                    displayLabel?.textColor =? self.displayTextColor
                }
            } else {
                
                titleLabel?.textColor =? self.titleDisabledColor
                displayLabel?.textColor =? self.displayDisabledColor
            }
        }
        
        if let pickerRowFormer = self.inlineRowFormer as? PickerRowFormer {
            
            pickerRowFormer.onValueChanged = self.valueChanged
            pickerRowFormer.valueTitles = self.valueTitles
            pickerRowFormer.selectedRow = self.selectedRow
            pickerRowFormer.showsSelectionIndicator = showsSelectionIndicator
            pickerRowFormer.enabled = self.enabled
            pickerRowFormer.update()
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
            self.isEditing = true
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
            row.formerDisplayLabel()?.textColor =? self.displayTextEditingColor
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
            } else {
                titleLabel?.textColor =? self.titleDisabledColor
                displayLabel?.textColor =? self.displayDisabledColor
            }

        }
    }
}