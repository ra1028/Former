//
//  TextViewRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/28/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextViewFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formTextView() -> UITextView
}

public class TextViewRowFormer<T: UITableViewCell where T: TextViewFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValidate: (String? -> Bool)?
    
    public var textChangedHandler: (String -> Void)?
    public var text: String?
    public var placeholder: String?
    public var attributedPlaceholder: NSAttributedString?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        if let row = cell as? TextViewFormableRow {
            let textView = row.formTextView()
            textView.delegate = nil
        }
    }
    
    public override func initialized() {
        super.initialized()
        cellHeight = 110.0
    }
    
    public override func update() {
        super.update()
        
        cell?.selectionStyle = .None
        if let row = cell as? TextViewFormableRow {
            let textView = row.formTextView()
            let titleLabel = row.formTitleLabel()
            textView.text = text
            textView.userInteractionEnabled = false
//            textView.delegate = self
            
            if placeholderLabel == nil {
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
                    ].flatMap { $0 }
                textView.addConstraints(constraints)
            }
            placeholderLabel?.text =? placeholder
            placeholderLabel?.attributedText =? attributedPlaceholder
            updatePlaceholderColor(textView.text)
            
            if enabled {
                if isEditing {
                    titleColor ?= titleLabel?.textColor
                    titleLabel?.textColor =? titleEditingColor
                } else {
                    titleLabel?.textColor =? titleColor
                    titleColor = nil
                }
                textView.textColor =? textColor
                textColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                textColor ?= textView.textColor
                titleLabel?.textColor = titleDisabledColor
                textView.textColor = textDisabledColor
            }
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        
        if let row = cell as? TextViewFormableRow {
            let textView = row.formTextView()
            textView.becomeFirstResponder()
            textView.userInteractionEnabled = enabled
        }
    }
    
    public func validate() -> Bool {
        return onValidate?(text) ?? true
    }
    
    // MARK: Private
    
    private var textColor: UIColor?
    private var titleColor: UIColor?
    private weak var placeholderLabel: UILabel?
    
    private func updatePlaceholderColor(text: String?) {
        placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
            UIColor(red: 0, green: 0, blue: 0.098 / 255.0, alpha: 0.22) :
            .clearColor()
    }
}

//extension TextViewRowFormer: UITextViewDelegate {
//    
//    public func textViewDidChange(textView: UITextView) {
//        if enabled {
//            if UIDevice.currentDevice().systemVersion.compare("8.0.0", options: .NumericSearch) == .OrderedAscending {
//                textView.scrollRangeToVisible(textView.selectedRange)
//            }
//            let text = textView.text ?? ""
//            self.text = text
//            textChangedHandler?(text)
//            updatePlaceholderColor(text)
//        }
//    }
//    
//    public func textViewDidBeginEditing(textView: UITextView) {
//        if let row = cell as? TextViewFormableRow where enabled {
//            let titleLabel = row.formTitleLabel()
//            titleColor ?= titleLabel?.textColor
//            titleLabel?.textColor =? titleEditingColor
//            isEditing = true
//        }
//    }
//    
//    public func textViewDidEndEditing(textView: UITextView) {
//        if let row = cell as? TextViewFormableRow {
//            let titleLabel = row.formTitleLabel()
//            row.formTextView().userInteractionEnabled = false
//            
//            if enabled {
//                titleLabel?.textColor =? titleColor
//                titleColor = nil
//            } else {
//                titleColor ?= titleLabel?.textColor
//                titleLabel?.textColor = titleDisabledColor
//            }
//            isEditing = false
//        }
//    }
//}