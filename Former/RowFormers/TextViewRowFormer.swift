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
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var textChangedHandler: (String -> Void)?
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textDisabledColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    public var inputView: UIView?
    public var inputAccessoryView: UIView?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    public var titleEditingColor: UIColor?
    
    private weak var placeholderLabel: UILabel?
    public var placeholder: String?
    public var placeholderFont: UIFont?
    public var placeholderColor: UIColor?
    
    public init<T : UITableViewCell where T : TextViewFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        textChangedHandler: (String -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.textChangedHandler = textChangedHandler
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.textDisabledColor = .lightGrayColor()
        self.titleDisabledColor = .lightGrayColor()
        self.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.cellHeight = 100.0
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? TextViewFormableRow {
            
            let textView = row.formerTextView()
            textView.delegate = self
            textView.text = self.text
            textView.font =? self.font
            textView.textColor = self.enabled ? self.textColor : self.textDisabledColor
            textView.textAlignment =? self.textAlignment
            textView.keyboardType =? self.keyboardType
            textView.returnKeyType =? self.returnKeyType
            textView.inputView = self.inputView
            textView.inputAccessoryView = self.inputAccessoryView
            textView.userInteractionEnabled = false
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ?
                (self.isEditing ? self.titleEditingColor : self.titleColor) :
                self.titleDisabledColor
            
            if self.placeholderLabel?.superview !== textView {
                self.placeholderLabel?.removeFromSuperview()
                self.placeholderLabel = nil
            }
            if self.placeholderLabel == nil {
                let placeholderLabel = UILabel()
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                textView.insertSubview(placeholderLabel, atIndex: 0)
                self.placeholderLabel = placeholderLabel
                let constraints = [
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-8-[label(>=0)]",
                        options: [],
                        metrics: nil,
                        views: ["label": placeholderLabel]
                    ),
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-5-[label]-0-|",
                        options: [],
                        metrics: nil,
                        views: ["label": placeholderLabel]
                    )
                ]
                textView.addConstraints(constraints.flatMap { $0 })
            }
            self.placeholderLabel?.text = self.placeholder
            self.placeholderLabel?.font =? self.placeholderFont
            self.placeholderLabel?.textAlignment =? self.textAlignment
            self.updatePlaceholderColor(textView.text)
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        
        if let row = self.cell as? TextViewFormableRow {
            let textView = row.formerTextView()
            textView.becomeFirstResponder()
            textView.userInteractionEnabled = self.enabled
        }
    }
    
    private func updatePlaceholderColor(text: String?) {
        
        self.placeholderLabel?.textColor =? (text?.isEmpty ?? true) ?
            self.placeholderColor :
            .clearColor()
    }
}

extension TextViewRowFormer: UITextViewDelegate {
    
    public func textViewDidChange(textView: UITextView) {
        
        if self.enabled {
            let text = textView.text ?? ""
            self.text = text
            self.textChangedHandler?(text)
            self.updatePlaceholderColor(text)
        }
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow where self.enabled {
            self.isEditing = true
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow {
            self.isEditing = false
            row.formerTitleLabel()?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            row.formerTextView().userInteractionEnabled = false
        }
    }
}