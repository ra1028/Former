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
        
        cell.selectionStyle = .None
        if let row = cell as? TextFieldFormableRow {
            let titleLabel = row.formTitleLabel()
            let textField = row.formTextField()
            textField.text = text
            textField.placeholder =? placeholder
            textField.attributedPlaceholder =? attributedPlaceholder
            textField.userInteractionEnabled = false
            textField.delegate = observer
            
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
    
    private lazy var observer: Observer<T> = { [unowned self] in
        Observer<T>(textFieldRowFormer: self)
        }()
    
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

private class Observer<T: UITableViewCell where T: TextFieldFormableRow>: NSObject, UITextFieldDelegate {
    
    private weak var textFieldRowFormer: TextFieldRowFormer<T>?
    
    init(textFieldRowFormer: TextFieldRowFormer<T>) {
        self.textFieldRowFormer = textFieldRowFormer
    }
    
    private dynamic func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let textFieldRowFormer = textFieldRowFormer else { return false }
        if textFieldRowFormer.returnToNextRow {
            let returnToNextRow = (textFieldRowFormer.former?.canBecomeEditingNext() ?? false) ?
                textFieldRowFormer.former?.becomeEditingNext :
                textFieldRowFormer.former?.endEditing
            returnToNextRow?()
        }
        return !textFieldRowFormer.returnToNextRow
    }
}