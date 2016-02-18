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
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var text: String?
    public var placeholder: String?
    public var attributedPlaceholder: NSAttributedString?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    public var titleEditingColor: UIColor?
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        cell.formTextView().delegate = nil
    }
    
    public final func onTextChanged(handler: (String -> Void)) -> Self {
        onTextChanged = handler
        return self
    }
    
    public override func initialized() {
        super.initialized()
        rowHeight = 110
    }
    
    public override func cellInitialized(cell: T) {
        cell.formTextView().delegate = observer
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let textView = cell.formTextView()
        let titleLabel = cell.formTitleLabel()
        textView.text = text
        textView.userInteractionEnabled = false
        
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
        _ = placeholder.map { placeholderLabel?.text  = $0 }
        if let attributedPlaceholder = attributedPlaceholder {
            placeholderLabel?.text = nil
            placeholderLabel?.attributedText = attributedPlaceholder
        }
        updatePlaceholderColor(textView.text)
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                titleColor = nil
            }
            _ = textColor.map { textView.textColor = $0 }
            textColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            if textColor == nil { textColor = textView.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
            textView.textColor = textDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        let textView = cell.formTextView()
        textView.becomeFirstResponder()
        textView.userInteractionEnabled = enabled
    }
    
    // MARK: Private
    
    private final var onTextChanged: (String -> Void)?
    private final var textColor: UIColor?
    private final var titleColor: UIColor?
    private final var _attributedString: NSAttributedString?
    private final weak var placeholderLabel: UILabel?
    private final lazy var observer: Observer<T> = Observer<T>(textViewRowFormer: self)
    
    private final func updatePlaceholderColor(text: String?) {
        if attributedPlaceholder == nil {
            placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
                UIColor(red: 0, green: 0, blue: 0.098 / 255, alpha: 0.22) :
                .clearColor()
        } else {
            if text?.isEmpty ?? true {
                _ = _attributedString.map { placeholderLabel?.attributedText = $0 }
                _attributedString = nil
            } else {
                if _attributedString == nil { _attributedString = placeholderLabel?.attributedText }
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
            textViewRowFormer.onTextChanged?(text)
            textViewRowFormer.updatePlaceholderColor(text)
        }
    }
    
    private dynamic func textViewDidBeginEditing(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        if textViewRowFormer.enabled {
            let titleLabel = textViewRowFormer.cell.formTitleLabel()
            if textViewRowFormer.titleColor == nil {
                textViewRowFormer.titleColor = titleLabel?.textColor ?? .blackColor()
            }
            _ = textViewRowFormer.titleEditingColor.map { titleLabel?.textColor = $0 }
            textViewRowFormer.isEditing = true
        }
    }
    
    private dynamic func textViewDidEndEditing(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        let titleLabel = textViewRowFormer.cell.formTitleLabel()
        textViewRowFormer.cell.formTextView().userInteractionEnabled = false
        
        if textViewRowFormer.enabled {
            _ = textViewRowFormer.titleColor.map { titleLabel?.textColor = $0 }
            textViewRowFormer.titleColor = nil
        } else {
            if textViewRowFormer.titleColor == nil {
                textViewRowFormer.titleColor = titleLabel?.textColor ?? .blackColor()
            }
            titleLabel?.textColor = textViewRowFormer.titleDisabledColor
        }
        textViewRowFormer.isEditing = false
    }
}