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
    
    func formTextField() -> UITextField
    func formTitleLabel() -> UILabel?
}

public class TextFieldRowFormer<T: UITableViewCell where T: TextFieldFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValidate: (String? -> Bool)?
    
    public var onTextChanged: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var attributedPlaceholder: NSAttributedString?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    public var returnToNextRow = true
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        if let row = cell as? TextFieldFormableRow {
            let textField = row.formTextField()
            textField.delegate = nil
        }
    }
    
    public override func update() {
        super.update()
        
        cell?.selectionStyle = .None
        if let row = cell as? TextFieldFormableRow {
            let titleLabel = row.formTitleLabel()
            let textField = row.formTextField()
            textField.text = text
            textField.placeholder =? placeholder
            textField.attributedPlaceholder =? attributedPlaceholder
            textField.userInteractionEnabled = false
//            textField.delegate = self
            
            if enabled {
                if isEditing {
                    titleColor ?= titleLabel?.textColor
                    titleLabel?.textColor =? titleEditingColor
                } else {
                    titleLabel?.textColor =? titleColor
                    titleColor = nil
                }
                textField.textColor =? textColor
                textColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                textColor ?= textField.textColor
                titleLabel?.textColor = titleDisabledColor
                textField.textColor = textDisabledColor
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
        
        if let row = cell as? TextFieldFormableRow where enabled {
            let textField = row.formTextField()
            if !textField.editing {
                textField.userInteractionEnabled = true
                textField.becomeFirstResponder()
            }
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(text) ?? true
    }
    
    // MARK: Private
    
    private var textColor: UIColor?
    private var titleColor: UIColor?
    
    private dynamic func textChanged(textField: UITextField) {
        if enabled {
            let text = textField.text ?? ""
            self.text = text
            onTextChanged?(text)
        }
    }
    
    private dynamic func editingDidBegin(textField: UITextField) {
        if let row = cell as? TextFieldFormableRow where enabled {
            let titleLabel = row.formTitleLabel()
            titleColor ?= titleLabel?.textColor
            titleLabel?.textColor =? titleEditingColor
        }
    }
    
    private dynamic func editingDidEnd(textField: UITextField) {
        if let row = cell as? TextFieldFormableRow {
            let titleLabel = row.formTitleLabel()
            if enabled {
                titleLabel?.textColor =? titleColor
                titleColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                titleLabel?.textColor =? titleEditingColor
            }
            row.formTextField().userInteractionEnabled = false
        }
    }
}

//extension TextFieldRowFormer: UITextFieldDelegate {
//    
//    public func textFieldShouldReturn(textField: UITextField) -> Bool {
//        if returnToNextRow {
//            let returnToNextRow = (former?.canBecomeEditingNext() ?? false) ?
//                former?.becomeEditingNext :
//                former?.endEditing
//            returnToNextRow?()
//        }
//        return !returnToNextRow
//    }
//}