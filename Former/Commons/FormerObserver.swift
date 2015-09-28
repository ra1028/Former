//
//  FormerObserver.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

// TODO: Remove

import UIKit

final public class FormerObserver {
    
    private weak var observedRowFormer: RowFormer?
    private weak var observedControl: UIControl?
    
    deinit {
        
        self.removeAllTarget()
    }
    
    func removeAllTarget() {
        
        self.observedControl?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.observedRowFormer = nil
        self.observedControl = nil
    }
    
    func setTargetRowFormer(rowFormer: RowFormer, control: UIControl, actionEvents: [(Selector, UIControlEvents)]) {
        
        self.removeAllTarget()
        self.observedRowFormer = rowFormer
        self.observedControl = control
        actionEvents.forEach {
            control.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
    }
}