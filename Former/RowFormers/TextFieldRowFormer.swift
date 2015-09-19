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

public class TextFieldRowFormer: RowFormer, FormerValidatable {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: (String? -> Bool)?
    
    public var onTextChanged: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var returnToNextRow = true
    
    private var textColor: UIColor?
    private var titleColor: UIColor?
    
    public init<T: UITableViewCell where T: TextFieldFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onTextChanged: (String -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType)
            self.onTextChanged = onTextChanged
    }
    
    deinit {
        if let row = self.cell as? TextFieldFormableRow {
            let textField = row.formerTextField()
            textField.delegate = nil
        }
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? TextFieldFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            let textField = row.formerTextField()
            textField.text = self.text
            textField.placeholder =? self.placeholder
            textField.userInteractionEnabled = false
            textField.delegate = self
            
            if self.enabled {
                if self.isEditing {
                    self.titleColor ?= titleLabel?.textColor
                    titleLabel?.textColor =? self.titleEditingColor
                } else {
                    titleLabel?.textColor =? self.titleColor
                    self.titleColor = nil
                }
                textField.textColor =? self.textColor
                self.textColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.textColor ?= textField.textColor
                titleLabel?.textColor = self.titleDisabledColor
                textField.textColor = self.textDisabledColor
            }
            
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
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.text) ?? true
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
            
            let titleLabel = row.formerTitleLabel()
            self.titleColor ?= titleLabel?.textColor
            titleLabel?.textColor =? self.titleEditingColor
        }
    }
    
    public func editingDidEnd(textField: UITextField) {
        
        if let row = self.cell as? TextFieldFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                self.titleColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                titleLabel?.textColor =? self.titleEditingColor
            }
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