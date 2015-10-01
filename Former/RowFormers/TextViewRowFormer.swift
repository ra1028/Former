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
            textView.delegate = observer
            
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
            if let attributedPlaceholder = attributedPlaceholder {
                placeholderLabel?.text = nil
                placeholderLabel?.attributedText = attributedPlaceholder
            }
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
    private var actualAttributedString: NSAttributedString?
    private weak var placeholderLabel: UILabel?
    private lazy var observer: Observer<T> = {
        Observer<T>(textViewRowFormer: self)
        }()
    
    private func updatePlaceholderColor(text: String?) {
        if attributedPlaceholder == nil {
            placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
                UIColor(red: 0, green: 0, blue: 0.098 / 255.0, alpha: 0.22) :
                .clearColor()
        } else {
            if text?.isEmpty ?? true {
                placeholderLabel?.attributedText =? actualAttributedString
                actualAttributedString = nil
            } else {
                actualAttributedString ?= placeholderLabel?.attributedText
                placeholderLabel?.attributedText = nil
            }
        }
    }
}

private class Observer<T: UITableViewCell where T: TextViewFormableRow>:
NSObject, UITextViewDelegate {
    
    private weak var textViewRowFormer: TextViewRowFormer<T>?
    
    init(textViewRowFormer: TextViewRowFormer<T>) {
        self.textViewRowFormer = textViewRowFormer
    }
    
    private dynamic func textViewDidChange(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        if textViewRowFormer.enabled {
            if UIDevice.currentDevice().systemVersion.compare("8.0.0", options: .NumericSearch) == .OrderedAscending {
                textView.scrollRangeToVisible(textView.selectedRange)
            }
            let text = textView.text ?? ""
            textViewRowFormer.text = text
            textViewRowFormer.textChangedHandler?(text)
            textViewRowFormer.updatePlaceholderColor(text)
        }
    }
    
    private dynamic func textViewDidBeginEditing(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        if let row = textViewRowFormer.cell as? TextViewFormableRow where textViewRowFormer.enabled {
            let titleLabel = row.formTitleLabel()
            textViewRowFormer.titleColor ?= titleLabel?.textColor
            titleLabel?.textColor =? textViewRowFormer.titleEditingColor
            textViewRowFormer.isEditing = true
        }
    }
    
    private dynamic func textViewDidEndEditing(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        if let row = textViewRowFormer.cell as? TextViewFormableRow {
            let titleLabel = row.formTitleLabel()
            row.formTextView().userInteractionEnabled = false
            
            if textViewRowFormer.enabled {
                titleLabel?.textColor =? textViewRowFormer.titleColor
                textViewRowFormer.titleColor = nil
            } else {
                textViewRowFormer.titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = textViewRowFormer.titleDisabledColor
            }
            textViewRowFormer.isEditing = false
        }
    }
}