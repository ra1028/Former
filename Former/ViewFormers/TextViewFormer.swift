//
//  TextViewFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableView: FormableView {
    
    func formTextLabel() -> UILabel
}

public class TextViewFormer<T: UITableViewHeaderFooterView where T: TextFormableView>
: CustomViewFormer<T> {
    
    // MARK: Public
    
    public var text: String?
    
    required public init(instantiateType: Former.InstantiateType = .Class, viewSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, viewSetup: viewSetup)
    }
    
    public override func initialized() {
        super.initialized()
        viewHeight = 30.0
    }
    
    public override func update() {
        super.update()
        
        if let view = view as? TextFormableView {
            let textLabel = view.formTextLabel()
            textLabel.text = text
        }
    }
}