//
//  TextFieldRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFieldFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
    func formerTextField() -> UITextField
    func formerTitleLabel() -> UILabel?
}

public class TextFieldRowFormer: RowFormer {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onTextChanged: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textDisabledColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var clearButtonMode: UITextFieldViewMode?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    public var inputView: UIView?
    public var inputAccessoryView: UIView?
    public var returnToNextRow = true
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleEditingColor: UIColor?
    
    init<T: UITableViewCell where T: TextFieldFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onTextChanged: (String -> Void)? = nil
        ) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.onTextChanged = onTextChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.textDisabledColor = .lightGrayColor()
        self.titleDisabledColor = .lightGrayColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? TextFieldFormableRow {
            
            let textField = row.formerTextField()
            textField.text = self.text
            textField.placeholder = self.placeholder
            textField.font =? self.font
            textField.textColor = self.enabled ? self.textColor : self.textDisabledColor
            textField.textAlignment =? self.textAlignment
            textField.clearButtonMode =? self.clearButtonMode
            textField.keyboardType =? self.keyboardType
            textField.returnKeyType =? self.returnKeyType
            textField.inputView = self.inputView
            textField.inputAccessoryView = self.inputAccessoryView
            textField.userInteractionEnabled = false
            textField.delegate = self
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            titleLabel?.font =? self.font
            
            row.observer.setTargetRowFormer(self,
                control: textField,
                actionEvents: [
                    ("textChanged:", .EditingChanged),
                    ("editingDidBegin:", .EditingDidBegin),
                    ("editingDidEnd:", .EditingDidEnd)
                ]
            )
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        
        if let row = self.cell as? TextFieldFormableRow where self.enabled {
            
            let textField = row.formerTextField()
            if !textField.editing {
                textField.userInteractionEnabled = true
                textField.becomeFirstResponder()
            }
        }
    }
    
    public func textChanged(textField: UITextField) {
        
        if self.enabled {
            let text = textField.text ?? ""
            self.text = text
            self.onTextChanged?(text)
        }
    }
    
    public func editingDidBegin(textField: UITextField) {
        
        if let row = self.cell as? TextFieldFormableRow where self.enabled {
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
        }
    }
    
    public func editingDidEnd(textField: UITextField) {
        
        if let row = self.cell as? TextFieldFormableRow {
            row.formerTitleLabel()?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            row.formerTextField().userInteractionEnabled = false
        }
    }
}

extension TextFieldRowFormer: UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.returnToNextRow {
            let returnToNextRow = (self.former?.canBecomeEditingNext() ?? false) ?
                self.former?.becomeEditingNext :
                self.former?.endEditing
            returnToNextRow?()
        }
        return !self.returnToNextRow
    }
}