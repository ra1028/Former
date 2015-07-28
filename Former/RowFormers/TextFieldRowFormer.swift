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
    public var titleTextColor: UIColor?
    public var titleTextEditingColor: UIColor?
    
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
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = cell as? TextFieldFormableRow else { return }
        
        let textField = cell.formerTextField()
        let titleLabel = cell.formerTitleLabel()
        
        self.observer.setObservedFormer(self)
        
        textField.text = self.text
        textField.placeholder = self.placeholder
        textField.font = self.font
        textField.textColor = self.textColor
        textField.textAlignment =? self.textAlignment
        textField.tintColor = self.tintColor
        textField.clearButtonMode =? self.clearButtonMode
        textField.keyboardType =? self.keyboardType
        textField.returnKeyType =? self.returnKeyType
        
        titleLabel?.text = self.title
        titleLabel?.textColor = self.titleTextColor
        titleLabel?.font = self.font
        
        textField.userInteractionEnabled = false
        if let disabledTextColor = self.disabledTextColor where !self.enabled {
            textField.textColor = disabledTextColor
            titleLabel?.textColor = disabledTextColor
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        
        guard let cell = self.cell as? TextFieldFormableRow else { return }
        let textField = cell.formerTextField()
        if !textField.editing {
            textField.userInteractionEnabled = self.enabled
            textField.becomeFirstResponder()
        }
    }
    
    public dynamic func didChangeText() {
        
        guard let cell = self.cell as? TextFieldFormableRow else { return }
        let text = cell.formerTextField().text ?? ""
        
        self.text = text
        self.textChangedHandler?(text)
    }
    
    public dynamic func didBeginEditing() {
        
        guard let cell = self.cell as? TextFieldFormableRow else { return }
        cell.formerTitleLabel()?.textColor =? self.titleTextEditingColor
    }
    
    public dynamic func didEndEditing() {
        
        guard let cell = self.cell as? TextFieldFormableRow else { return }
        let titleLabel = cell.formerTitleLabel()
        let textField = cell.formerTextField()
        titleLabel?.textColor = self.titleTextColor
        textField.userInteractionEnabled = false
    }
}