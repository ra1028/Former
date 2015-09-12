//
//  TextViewFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableView: FormableView {
    
    func formerTextLabel() -> UILabel?
}

public class TextViewFormer: ViewFormer {
    
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    
    public init<T: UITableViewHeaderFooterView where T: TextFormableView>(viewType: T.Type, registerType: Former.RegisterType, text: String? = nil) {
        
        super.init(viewType: viewType, registerType: registerType)
        self.text = text
    }
    
    public override func configureViewFormer() {
        
        super.configureViewFormer()
        self.viewHeight = 30.0
    }
    
    public override func update() {
        
        super.update()
        
        if let view = self.view as? TextFormableView {
            let textLabel = view.formerTextLabel()
            textLabel?.text =? self.text
            textLabel?.font =? self.font
            textLabel?.textColor =? self.textColor
            textLabel?.textAlignment =? self.textAlignment
        }
    }
}