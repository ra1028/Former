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
        var key: String {
            return self.rawValue
        }
    }
    
    public var textObservedHandler: (String -> Void)?
    
    private weak var observedObject: NSObject?
    private var observedKeyPath: KeyPath?
    
    override init() {
        super.init()
    }
    
    init(inout textField: UITextField, textObservedHandler: (String -> Void)?) {
        
        super.init()
        self.addObservedObject(textField)
        self.textObservedHandler = textObservedHandler
    }
    
    deinit {
        
        self.removeSuitableObserver()
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == self.observedKeyPath?.key {
            self.handleSuitableHandler()
        }
    }
    
    public func addObservedObject(object: NSObject) {
        self.removeSuitableObserver()
        self.observedObject = object
        self.addSuitableObserver()
    }
    
    public func removeSuitableObserver() {
        
        if case let (object?, keyPath?) = (self.observedObject, self.observedKeyPath) {
            object.removeObserver(self, forKeyPath: keyPath.key)
        }
        self.observedObject = nil
        self.observedKeyPath = nil
    }
    
    private func addSuitableObserver() {
        
        guard let object = self.observedObject else { return }
        
        var keyPath: KeyPath?
        switch object {
            
        case let object as UITextField:
            keyPath = .Text
            object.addTarget(self, action: "handleSuitableHandler", forControlEvents: .EditingChanged)
        default: break
        }
        
        self.observedKeyPath = keyPath
        if let keyPath = keyPath {
            object.addObserver(
                self,
                forKeyPath: keyPath.key,
                options: .New,
                context: nil
            )
        }
    }
    
    private dynamic func handleSuitableHandler() {
        
        switch self.observedObject {
        
        case let textField as UITextField:
            self.textObservedHandler?(textField.text ?? "")
        default: break
        }
    }
}