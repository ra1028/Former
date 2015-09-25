//
//  TextViewFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableView: FormableView {
    
    func formerTextLabel() -> UILabel
}

public class TextViewFormer: ViewFormer {
    
    public var text: String?
    
    public init<T: UITableViewHeaderFooterView where T: TextFormableView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        text: String? = nil,
        viewConfiguration: (T -> Void)? = nil) {
        
            super.init(viewType: viewType, instantiateType: instantiateType, viewConfiguration: viewConfiguration)
            self.text = text
    }
    
    public override func initialize() {
        
        super.initialize()
        self.viewHeight = 30.0
    }
    
    public override func update() {
        
        super.update()
        
        if let view = self.view as? TextFormableView {
            let textLabel = view.formerTextLabel()
            textLabel.text = self.text
        }
    }
}