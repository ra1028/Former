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
    func formerDisplayFieldView() -> UITextField?
}

public class InlinePickerRowFormer: RowFormer, InlinePickableRow {
    
    public private(set) var pickerRowFormer: RowFormer = PickerRowFormer(
        cellType: FormerPickerCell.self,
        registerType: .Class
    )
    
    public var valueChangedHandler: ((Int, String) -> Void)?
    public var valueTitles: [String] = []
    public var selectedRow: Int = 0
    public var showsSelectionIndicator: Bool?
    
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
    
    init<T : UITableViewCell where T : InlinePickerFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        valueChangedHandler: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.valueChangedHandler = valueChangedHandler
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
        
        if let row = self.cell as? InlinePickerFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
            let displayField = row.formerDisplayFieldView()
            displayField?.text = self.valueTitles[self.selectedRow]
            displayField?.placeholder = self.placeholder
            displayField?.font =? self.displayTextFont
            displayField?.textColor = self.enabled ? self.displayTextColor : self.displayDisabledTextColor
            displayField?.textAlignment =? self.displayTextAlignment
            displayField?.userInteractionEnabled = false
        }
        
        if let pickerRowFormer = self.pickerRowFormer as? PickerRowFormer {
            
            pickerRowFormer.valueChangedHandler = self.didChangeValue
            pickerRowFormer.valueTitles = self.valueTitles
            pickerRowFormer.selectedRow = self.selectedRow
            pickerRowFormer.showsSelectionIndicator = showsSelectionIndicator
            pickerRowFormer.enabled = self.enabled
        }
    }
    
    private func didChangeValue(row: Int, title: String) {
        
        if let pickerRow = self.cell as? InlinePickerFormableRow where self.enabled {
            self.selectedRow = row
            pickerRow.formerDisplayFieldView()?.text = title
            self.valueChangedHandler?((row, title))
        }
    }
    
    public func editingDidBegin() {
        
        if let row = self.cell as? InlinePickerFormableRow where self.enabled {
            row.formerTitleLabel()?.textColor = self.titleEditingColor
            row.formerDisplayFieldView()?.textColor =? self.displayTextEditingColor
        }
    }
    
    public func editingDidEnd() {
        
        if let row = self.cell as? InlinePickerFormableRow {
            row.formerTitleLabel()?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            row.formerDisplayFieldView()?.textColor = self.enabled ? self.displayTextColor : self.displayDisabledTextColor
        }
    }
}