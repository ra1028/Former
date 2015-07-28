//
//  FormerObserver.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerObserver: NSObject {
    
    private enum KeyPath: String {
        
        case Text = "text"
        case On = "on"
        var key: String {
            return self.rawValue
        }
    }
    
    
    private weak var observedRowFormer: RowFormer?
    private weak var observedObject: NSObject?
    private var observedKeyPath: KeyPath?
    private var targetComponents: [(Selector, UIControlEvents)]?
    
    override init() {
        super.init()
    }
    
    convenience init(inout rowFormer: RowFormer) {
        
        self.init()
        self.observedRowFormer = rowFormer
    }
    
    deinit {
        self.removeSuitableObserver()
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == self.observedKeyPath?.key {
            self.handleSuitableFormer()
        }
    }
    
    public func setObservedFormer(rowFormer: RowFormer) {
        self.removeSuitableObserver()
        self.observedRowFormer = rowFormer
        self.addSuitableObserver()
    }
    
    public func removeSuitableObserver() {
        
        switch (self.observedObject, self.observedKeyPath, self.targetComponents) {
        case (let object?, let keyPath?, let components?):
            object.removeObserver(self, forKeyPath: keyPath.key)
            components.map {
                (object as! UIControl).removeTarget(object, action: $0.0, forControlEvents: $0.1)
            }
        case (let object?, _, let components?):
            components.map {
                (object as! UIControl).removeTarget(object, action: $0.0, forControlEvents: $0.1)
            }
        default: break
        }
        self.observedRowFormer = nil
        self.observedObject = nil
        self.observedKeyPath = nil
        self.targetComponents = nil
    }
    
    private func addSuitableObserver() {
        
        guard let rowFormer = self.observedRowFormer else { return }

        switch rowFormer {
            
        case let rowFormer as TextFieldRowFormer:
            guard let cell = rowFormer.cell as? TextFieldFormableRow else { return }
            self.observedKeyPath = .Text
            self.observedObject = cell.formerTextField()
            self.targetComponents = [
                ("didChangeText", .EditingChanged),
                ("didBeginEditing", .EditingDidBegin),
                ("didEndEditing", .EditingDidEnd)
            ]
        case let rowFormer as TextViewRowFormer:
            guard let cell = rowFormer.cell as? TextViewFormableRow else { return }
            let textView = cell.formerTextView()
            textView.delegate = self
            self.observedKeyPath = .Text
            self.observedObject = textView
            self.targetComponents = [
                ("didChangeText", .EditingChanged),
                ("didBeginEditing", .EditingDidBegin),
                ("didEndEditing", .EditingDidEnd)
            ]
        case let rowFormer as SwitchRowFormer:
            guard let cell = rowFormer.cell as? SwitchFormableRow else { return }
            self.observedKeyPath = .On
            self.observedObject = cell.formerSwitch()
            self.targetComponents = [("switchChanged", .ValueChanged)]
        default: break
        }
        
        self.targetComponents?.map {
            (self.observedObject as? UIControl)?.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
        if case let (object?, keyPath?) = (self.observedObject, self.observedKeyPath) {
            object.addObserver(
                self,
                forKeyPath: keyPath.key,
                options: .New,
                context: nil
            )
        }
    }
    
    private dynamic func handleSuitableFormer() {
        
        switch self.observedRowFormer {
        
        case let rowFormer as TextFieldRowFormer:
            rowFormer.didChangeText()
        case let rowFormer as TextViewRowFormer :
            rowFormer.didChangeText()
        case let rowFormer as SwitchRowFormer:
            rowFormer.switchChanged()
        default: break
        }
    }
}

extension FormerObserver: UITextViewDelegate {
    
    public func textViewDidChange(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).didChangeText()
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).didBeginEditing()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        (self.observedRowFormer as! TextViewRowFormer).didEndEditing()
    }
}