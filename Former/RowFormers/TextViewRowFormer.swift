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
    
    init<T : UITableViewCell where T : TextViewFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        textChangedHandler: (String -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.textChangedHandler = textChangedHandler
            self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        if let row = self.cell as? TextViewFormableRow {
            
            let textView = row.formerTextView()
            textView.delegate = self
            textView.text =? self.text
            textView.font =? self.font
            textView.textColor =? self.textColor
            textView.textAlignment =? self.textAlignment
            textView.keyboardType =? self.keyboardType
            textView.returnKeyType =? self.returnKeyType
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.font
            titleLabel?.textColor = self.titleColor
            
            textView.userInteractionEnabled = false
            if let disabledTextColor = self.disabledTextColor where !self.enabled {
                textView.textColor = disabledTextColor
                titleLabel?.textColor = disabledTextColor
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
            self.placeholderLabel?.text =? self.placeholder
            self.placeholderLabel?.font =? self.placeholderFont
            self.updatePlaceholderColor(textView.text)
        }
    }
    
    public override func didSelectCell(indexPath: NSIndexPath) {
        
        super.didSelectCell(indexPath)
        
        if let row = self.cell as? TextViewFormableRow {
            let textView = row.formerTextView()
            textView.becomeFirstResponder()
            textView.userInteractionEnabled = self.enabled
        }
    }
    
    private func updatePlaceholderColor(text: String?) {
        
        self.placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
            self.placeholderColor :
            .clearColor()
    }
}

extension TextViewRowFormer: UITextViewDelegate {
    
    public func textViewDidChange(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow {
            let text = row.formerTextView().text ?? ""
            self.text = text
            self.textChangedHandler?(text)
            self.updatePlaceholderColor(text)
        }
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow {
            row.formerTitleLabel()?.textColor =? self.titleEditingColor
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow {
            row.formerTitleLabel()?.textColor = self.titleColor
            row.formerTextView().userInteractionEnabled = false
        }
    }
}