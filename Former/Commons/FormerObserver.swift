//
//  FormerObserver.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerObserver: NSObject {
    
    private weak var observedRowFormer: RowFormer?
    private weak var observedControl: UIControl?
    
    override init() {
        
        super.init()
    }
    
    deinit {
        
        self.removeAllTarget()
    }
    
    public func removeAllTarget() {
        
        self.observedControl?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.observedRowFormer = nil
        self.observedControl = nil
    }
    
    public func setTargetRowFormer(rowFormer: RowFormer, control: UIControl, actionEvents: [(Selector, UIControlEvents)]) {
        
        self.removeAllTarget()
        self.observedRowFormer = rowFormer
        self.observedControl = control
        actionEvents.map {
            control.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
    }
}