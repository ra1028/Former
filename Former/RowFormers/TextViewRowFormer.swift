//
//  TextViewRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/28/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextViewFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
    func formerTextView() -> UITextView
}

public class TextViewRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var textChangedHandler: (String -> Void)?
    
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleTextColor: UIColor?
    public var titleTextEditingColor: UIColor?
    
    public var enabled: Bool = true
    public var disabledTextColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        textChangedHandler: (String -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.textChangedHandler = textChangedHandler
    }
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        
        self.observer.setObservedFormer(self)
        
        let textView = cell.formerTextView()
        let titleLabel = cell.formerTitleLabel()
        
        textView.text =? self.text
        textView.font =? self.font
        textView.textColor =? self.textColor
        textView.textAlignment =? self.textAlignment
        textView.keyboardType =? self.keyboardType
        textView.returnKeyType =? self.returnKeyType
        
        titleLabel?.text =? self.title
        titleLabel?.font =? self.font
        titleLabel?.textColor = self.titleTextColor
        
        textView.userInteractionEnabled = self.enabled
        if let disabledTextColor = self.disabledTextColor where !self.enabled {
            textView.textColor = disabledTextColor
            titleLabel?.textColor = disabledTextColor
        }
    }
    
    public dynamic func didChangeText() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        let text = cell.formerTextView().text ?? ""
        
        self.text = text
        self.textChangedHandler?(text)
    }
    
    public dynamic func didBeginEditing() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        cell.formerTitleLabel()?.textColor =? self.titleTextEditingColor
        
        guard let indexPath = self.indexPath else { return }
        self.cellSelected(indexPath)
    }
    
    public dynamic func didEndEditing() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        cell.formerTitleLabel()?.textColor = self.titleTextColor
    }
}