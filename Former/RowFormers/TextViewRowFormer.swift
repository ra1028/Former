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

public class TextViewRowFormer: RowFormer, FormerValidatable {
    
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValidate: (String? -> Bool)?
    
    public var textChangedHandler: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    
    private var textColor: UIColor?
    private var titleColor: UIColor?
    private weak var placeholderLabel: UILabel?
    
    public init<T : UITableViewCell where T : TextViewFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        textChangedHandler: (String -> Void)? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.textChangedHandler = textChangedHandler
    }
    
    deinit {
        if let row = self.cell as? TextViewFormableRow {
            let textView = row.formerTextView()
            textView.delegate = nil
        }
    }
    
    public override func initialize() {
        
        super.initialize()
        self.cellHeight = 110.0
    }
    
    public override func update() {
        
        super.update()
        
        self.cell?.selectionStyle = .None
        
        if let row = self.cell as? TextViewFormableRow {
            
            let textView = row.formerTextView()
            let titleLabel = row.formerTitleLabel()
            
            textView.text = self.text
            textView.userInteractionEnabled = false
            textView.delegate = self
            
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
            self.placeholderLabel?.text =? self.placeholder
            self.updatePlaceholderColor(textView.text)
            
            if self.enabled {
                if self.isEditing {
                    self.titleColor ?= titleLabel?.textColor
                    titleLabel?.textColor =? self.titleEditingColor
                } else {
                    titleLabel?.textColor =? self.titleColor
                    self.titleColor = nil
                }
                textView.textColor =? self.textColor
                self.textColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                self.textColor ?= textView.textColor
                titleLabel?.textColor = self.titleDisabledColor
                textView.textColor = self.textDisabledColor
            }
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
    
    public func validate() -> Bool {
        
        return self.onValidate?(self.text) ?? true
    }
    
    private func updatePlaceholderColor(text: String?) {
        
        self.placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
            UIColor(white: 0.8, alpha: 1.0) :
            .clearColor()
    }
}

extension TextViewRowFormer: UITextViewDelegate {
    
    public func textViewDidChange(textView: UITextView) {
        
        if self.enabled {
            if UIDevice.currentDevice().systemVersion.compare("8.0.0", options: .NumericSearch) == .OrderedAscending {
                textView.scrollRangeToVisible(textView.selectedRange)
            }
            let text = textView.text ?? ""
            self.text = text
            self.textChangedHandler?(text)
            self.updatePlaceholderColor(text)
        }
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow where self.enabled {
            
            let titleLabel = row.formerTitleLabel()
            self.titleColor ?= titleLabel?.textColor
            titleLabel?.textColor =? self.titleEditingColor
            self.isEditing = true
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        
        if let row = self.cell as? TextViewFormableRow {
            
            let titleLabel = row.formerTitleLabel()
            row.formerTextView().userInteractionEnabled = false
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
                self.titleColor = nil
            } else {
                self.titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = self.titleDisabledColor
            }
            self.isEditing = false
        }
    }
}