//
//  TextFieldRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFieldFormableRow: FormableRow {
    
    func formerTextField() -> UITextField
    func formerTitleLabel() -> UILabel?
}

public class TextFieldRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var textChangedHandler: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var tintColor: UIColor?
    public var clearButtonMode: UITextFieldViewMode?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleEditingColor: UIColor?
    
    public var enabled: Bool = true
    public var disabledTextColor: UIColor?
    
    init<T: UITableViewCell where T: TextFieldFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        textChangedHandler: (String -> Void)? = nil
        ) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.textChangedHandler = textChangedHandler
            self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        if let row = cell as? TextFieldFormableRow {
            
            let textField = row.formerTextField()
            self.observer.setTargetRowFormer(self, control: textField, actionEvents: [
                ("didChangeText", .EditingChanged),
                ("editingDidBegin", .EditingDidBegin),
                ("editingDidEnd", .EditingDidEnd)
                ])
            textField.text = self.text
            textField.placeholder = self.placeholder
            textField.font = self.font
            textField.textColor = self.textColor
            textField.textAlignment =? self.textAlignment
            textField.tintColor = self.tintColor
            textField.clearButtonMode =? self.clearButtonMode
            textField.keyboardType =? self.keyboardType
            textField.returnKeyType =? self.returnKeyType
            textField.userInteractionEnabled = false
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.textColor = self.titleColor
            titleLabel?.font = self.font
            
            if let disabledTextColor = self.disabledTextColor where !self.enabled {
                textField.textColor = disabledTextColor
                titleLabel?.textColor = disabledTextColor
            }
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        
        if let row = self.cell as? TextFieldFormableRow {
            let textField = row.formerTextField()
            if !textField.editing {
                textField.userInteractionEnabled = self.enabled
                textField.becomeFirstResponder()
            }
        }
    }
    
    public dynamic func didChangeText() {
        
        if let row = self.cell as? TextFieldFormableRow {
            let text = row.formerTextField().text ?? ""
            self.text = text
            self.textChangedHandler?(text)
        }
    }
    
    public dynamic func editingDidBegin() {
        
        if let row = self.cell as? TextFieldFormableRow {
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
        }
    }
    
    public dynamic func editingDidEnd() {
        
        if let row = self.cell as? TextFieldFormableRow {
            row.formerTitleLabel()?.textColor = self.titleColor
            row.formerTextField().userInteractionEnabled = false
        }
    }
}