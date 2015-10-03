//
//  TextRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableRow: FormableRow {
    
    func formTextLabel() -> UILabel?
    func formerSubTextLabel() -> UILabel?
}

public class TextRowFormer<T: UITableViewCell where T: TextFormableRow>
: CustomRowFormer<T> {
    
    // MARK: Public
    
    public var text: String?
    public var subText: String?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var subTextDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        let textLabel = typedCell.formTextLabel()
        let subTextLabel = typedCell.formerSubTextLabel()
        textLabel?.text = text
        subTextLabel?.text = subText
        
        if enabled {
            textLabel?.textColor =? textColor
            subTextLabel?.textColor =? subTextColor
            textColor = nil
            subTextColor = nil
        } else {
            textColor ?= textLabel?.textColor
            subTextColor ?= subTextLabel?.textColor
            textLabel?.textColor = textDisabledColor
            subTextLabel?.textColor = subTextDisabledColor
        }
    }
    
    // MARK: Private
    
    private var textColor: UIColor?
    private var subTextColor: UIColor?
}