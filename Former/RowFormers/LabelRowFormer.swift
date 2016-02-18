//
//  LabelRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol LabelFormableRow: FormableRow {
    
    func formTextLabel() -> UILabel?
    func formSubTextLabel() -> UILabel?
}

public class LabelRowFormer<T: UITableViewCell where T: LabelFormableRow>
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    public var text: String?
    public var subText: String?
    public var textDisabledColor: UIColor? = .lightGrayColor()
    public var subTextDisabledColor: UIColor? = .lightGrayColor()
    
    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        let textLabel = cell.formTextLabel()
        let subTextLabel = cell.formSubTextLabel()
        textLabel?.text = text
        subTextLabel?.text = subText
        
        if enabled {
            _ = textColor.map { textLabel?.textColor = $0 }
            _ = subTextColor.map { subTextLabel?.textColor = $0 }
            textColor = nil
            subTextColor = nil
        } else {
            if textColor == nil { textColor = textLabel?.textColor ?? .blackColor() }
            if subTextColor == nil { subTextColor = subTextLabel?.textColor ?? .blackColor() }
            textLabel?.textColor = textDisabledColor
            subTextLabel?.textColor = subTextDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var textColor: UIColor?
    private final var subTextColor: UIColor?
}