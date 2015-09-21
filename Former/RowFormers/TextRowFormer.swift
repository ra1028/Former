//
//  TextRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableRow: FormableRow {
    
    func formerTextLabel() -> UILabel?
    func formerSubTextLabel() -> UILabel?
}

public class TextRowFormer: RowFormer {
    
    public var text: String?
    public var subText: String?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var subTextDisabledColor: UIColor? = .lightGrayColor()
    
    private var textColor: UIColor?
    private var subTextColor: UIColor?
    
    public init<T: UITableViewCell where T: TextFormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        text: String? = nil,
        cellConfiguration: (T -> Void)? = nil) {
            
            super.init(cellType: cellType, instantiateType: instantiateType, cellConfiguration: cellConfiguration)
            self.text = text
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? TextFormableRow {
            
            let textLabel = row.formerTextLabel()
            let subTextLabel = row.formerSubTextLabel()
            
            textLabel?.text = self.text
            subTextLabel?.text = self.subText
            
            if self.enabled {
                textLabel?.textColor =? self.textColor
                subTextLabel?.textColor =? self.subTextColor
                self.textColor = nil
                self.subTextColor = nil
            } else {
                self.textColor ?= textLabel?.textColor
                self.subTextColor ?= textLabel?.textColor
                textLabel?.textColor = self.textDisabledColor
                subTextLabel?.textColor = self.subTextDisabledColor
            }
        }
    }
}