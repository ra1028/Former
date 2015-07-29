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
    private weak var placeholderLabel: UILabel?
    
    public var textChangedHandler: (String -> Void)?
    
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleEditingColor: UIColor?
    
    public var placeholder: String?
    public var placeholderFont: UIFont?
    public var placeholderColor: UIColor? = .lightGrayColor()
    
    public var enabled: Bool = true
    public var disabledTextColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        textChangedHandler: (String -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.textChangedHandler = textChangedHandler
            self.selectionStyle = UITableViewCellSelectionStyle.None
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
        titleLabel?.textColor = self.titleColor
        
        if self.placeholderLabel == nil {
            let placeholderLabel = UILabel()
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            textView.insertSubview(placeholderLabel, atIndex: 0)
            self.placeholderLabel = placeholderLabel
            let constraints = [
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-10-[label(>=0)]",
                    options: [],
                    metrics: nil,
                    views: ["label": placeholderLabel]
                ),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-5-[label(>=0)]|",
                    options: [],
                    metrics: nil,
                    views: ["label": placeholderLabel]
                )
            ]
            textView.addConstraints(constraints.flatMap {$0})
        }
        self.placeholderLabel?.text =? self.placeholder
        self.placeholderLabel?.font =? self.placeholderFont
        self.updatePlaceholderColor(textView.text)
        
        textView.userInteractionEnabled = false
        if let disabledTextColor = self.disabledTextColor where !self.enabled {
            textView.textColor = disabledTextColor
            titleLabel?.textColor = disabledTextColor
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        let textView = cell.formerTextView()
        
        textView.becomeFirstResponder()
        textView.userInteractionEnabled = self.enabled
    }
    
    public dynamic func didChangeText() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        let text = cell.formerTextView().text ?? ""
        
        self.text = text
        self.textChangedHandler?(text)
        self.updatePlaceholderColor(text)
    }
    
    public dynamic func didBeginEditing() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        cell.formerTitleLabel()?.textColor =? self.titleEditingColor
    }
    
    public dynamic func didEndEditing() {
        
        guard let cell = self.cell as? TextViewFormableRow else { return }
        cell.formerTitleLabel()?.textColor = self.titleColor
        cell.formerTextView().userInteractionEnabled = false
    }
    
    private func updatePlaceholderColor(text: String?) {
        
        self.placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
            self.placeholderColor :
            .clearColor()
    }
}