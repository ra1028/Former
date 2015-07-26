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
        
        if case let (object?, keyPath?) = (self.observedObject, self.observedKeyPath) {
            object.removeObserver(self, forKeyPath: keyPath.key)
        }
        self.observedRowFormer = nil
        self.observedObject = nil
        self.observedKeyPath = nil
    }
    
    private func addSuitableObserver() {
        
        guard let rowFormer = self.observedRowFormer else { return }
        
        var keyPath: KeyPath?
        var object: NSObject?
        var targetComponent = [(Selector, UIControlEvents)]()
        switch rowFormer {
            
        case let rowFormer as TextFieldRowFormer:
            guard let cell = rowFormer.cell as? TextFieldFormableRow else { return }
            keyPath = .Text
            object = cell.formerTextField()
            targetComponent = [
                ("editingDidBegin", .EditingDidBegin),
                ("editingDidEnd", .EditingDidEnd),
                ("textChanged", .EditingChanged)
            ]
        case let rowFormer as SwitchRowFormer:
            guard let cell = rowFormer.cell as? SwitchFormableRow else { return }
            keyPath = .On
            object = cell.formerSwitch()
            targetComponent = [("switchChanged", .ValueChanged)]
        default: break
        }
        
        targetComponent.map {
            (object as? UIControl)?.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
        
        self.observedKeyPath = keyPath
        self.observedObject = object
        if case let (keyPath?, object?) = (keyPath, object) {
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
            rowFormer.textChanged()
        case let rowFormer as SwitchRowFormer:
            rowFormer.switchChanged()
        default: break
        }
    }
}