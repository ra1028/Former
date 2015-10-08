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
: CustomRowFormer<T>, FormValidatable {
    
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
        let textView = typedCell.formTextView()
        textView.delegate = nil
    }
    
    public override func initialized() {
        super.initialized()
        cellHeight = 110.0
    }
    
    public override func update() {
        super.update()
        
        typedCell.selectionStyle = .None
        let textView = typedCell.formTextView()
        let titleLabel = typedCell.formTitleLabel()
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
        _ = placeholder.map {placeholderLabel?.text  = $0 }
        if let attributedPlaceholder = attributedPlaceholder {
            placeholderLabel?.text = nil
            placeholderLabel?.attributedText = attributedPlaceholder
        }
        updatePlaceholderColor(textView.text)
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                titleColor = nil
            }
            _ = textColor.map { textView.textColor = $0 }
            textColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            if textColor == nil { textColor = textView.textColor }
            titleLabel?.textColor = titleDisabledColor
            textView.textColor = textDisabledColor
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)

        let textView = typedCell.formTextView()
        textView.becomeFirstResponder()
        textView.userInteractionEnabled = enabled
    }
    
    public func validate() -> Bool {
        return onValidate?(text) ?? true
    }
    
    // MARK: Private
    
    private var textColor: UIColor?
    private var titleColor: UIColor?
    private var actualAttributedString: NSAttributedString?
    private weak var placeholderLabel: UILabel?
    private lazy var observer: Observer<T> = { [unowned self] in
        Observer<T>(textViewRowFormer: self)
        }()
    
    private func updatePlaceholderColor(text: String?) {
        if attributedPlaceholder == nil {
            placeholderLabel?.textColor = (text?.isEmpty ?? true) ?
                UIColor(red: 0, green: 0, blue: 0.098 / 255.0, alpha: 0.22) :
                .clearColor()
        } else {
            if text?.isEmpty ?? true {
                _ = actualAttributedString.map { placeholderLabel?.attributedText = $0 }
                actualAttributedString = nil
            } else {
                if actualAttributedString == nil { actualAttributedString = placeholderLabel?.attributedText }
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
        if textViewRowFormer.enabled {
            let titleLabel = textViewRowFormer.typedCell.formTitleLabel()
            if textViewRowFormer.titleColor == nil {
                textViewRowFormer.titleColor = titleLabel?.textColor
            }
            _ = textViewRowFormer.titleEditingColor.map { titleLabel?.textColor = $0 }
            textViewRowFormer.isEditing = true
        }
    }
    
    private dynamic func textViewDidEndEditing(textView: UITextView) {
        guard let textViewRowFormer = textViewRowFormer else { return }
        let titleLabel = textViewRowFormer.typedCell.formTitleLabel()
        textViewRowFormer.typedCell.formTextView().userInteractionEnabled = false
        
        if textViewRowFormer.enabled {
            _ = textViewRowFormer.titleColor.map { titleLabel?.textColor = $0 }
            textViewRowFormer.titleColor = nil
        } else {
            if textViewRowFormer.titleColor == nil {
                textViewRowFormer.titleColor = titleLabel?.textColor
            }
            titleLabel?.textColor = textViewRowFormer.titleDisabledColor
        }
        textViewRowFormer.isEditing = false
    }
}