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
    func formerTitleLabel() -> UILabel
}

public class TextFieldRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    public var textChangedHandler: (String -> Void)? {
        get {
            return self.observer.textObservedHandler
        }
        set {
            self.observer.textObservedHandler = newValue
        }
    }
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
    public var titleTextColor: UIColor?
    
    public var enabled: Bool = true
    public var unabledTextColor: UIColor?
    
    init<T: UITableViewCell where T: TextFieldFormableRow>(
        cellType: T.Type,
        title: String? = nil,
        text: String? = nil,
        placeholder: String? = nil,
        selectedHandler: (NSIndexPath -> Void)? = nil,
        textChangedHandler: (String -> Void)? = nil
        ) {
            
            super.init(cellType: cellType)
            self.selectedHandler = { [weak self] indexPath in
                
                if let cell = self?.cell as? FormerTextFieldCell {
                    let textField = cell.formerTextField()
                    if textField.isFirstResponder() {
                        textField.resignFirstResponder()
                    } else {
                        textField.becomeFirstResponder()
                    }
                }
                selectedHandler?(indexPath)
            }
            self.textChangedHandler = { [weak self] text in
                
                self?.text = text
                textChangedHandler?(text)
            }
            self.text = text
            self.title = title
            self.placeholder = placeholder
            self.accessoryType = .None
    }
    
    public override func cellConfigreIfFormable() {
        
        guard let cell = cell as? TextFieldFormableRow else { return }
        
        let textField = cell.formerTextField()
        let titleLabel = cell.formerTitleLabel()
        
        self.observer.addObservedObject(textField)
        
        textField.text = self.text
        textField.placeholder = self.placeholder
        textField.font = self.font
        textField.textColor = self.textColor
        textField.textAlignment =? self.textAlignment
        textField.tintColor = self.tintColor
        textField.clearButtonMode =? self.clearButtonMode
        textField.keyboardType =? self.keyboardType
        textField.returnKeyType =? self.returnKeyType
        
        titleLabel.text = self.title
        titleLabel.textColor = self.titleTextColor
        titleLabel.font = self.font
        
        textField.userInteractionEnabled = self.enabled
        if let unabledTextColor = self.unabledTextColor {
            textField.textColor = unabledTextColor
            titleLabel.textColor = unabledTextColor
        }
    }
}