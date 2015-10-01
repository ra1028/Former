//
//  DemoInlineSliderRowFomer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 9/6/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

public protocol DemoInlineSliderFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formerColorDisplayView() -> UIView?
}

public class DemoInlineSliderRowFormer<T: UITableViewCell where T: DemoInlineSliderFormableRow>
: CustomRowFormer<T>, InlineRow {
    
    // MARK: Public
    
    public private(set) var inlineRowFormer: RowFormer = SliderRowFormer<FormSliderCell>(instantiateType: .Class)
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var onValueChanged: (Float -> Void)?
    public var adjustedValueFromValue: (Float -> Float)?
    public var value: Float = 0
    public var color: UIColor?
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        if let row = cell as? DemoInlineSliderFormableRow {
            let titleLabel = row.formTitleLabel()
            if enabled {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                titleColor = nil
            } else {
                if titleColor == nil { titleColor = titleLabel?.textColor }
                titleLabel?.textColor = titleDisabledColor
            }
            let colorDisplayView = row.formerColorDisplayView()
            colorDisplayView?.backgroundColor = color
        }
        if let inlineRowFormer = inlineRowFormer as? SliderRowFormer<FormSliderCell> {
            inlineRowFormer.cellHeight = 44.0
            inlineRowFormer.onValueChanged = valueChanged
            inlineRowFormer.adjustedValueFromValue = adjustedValueFromValue
            inlineRowFormer.value = adjustedValueFromValue?(value) ?? value
            inlineRowFormer.enabled = enabled
            inlineRowFormer.update()
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    private func valueChanged(value: Float) {
        self.value = value
        onValueChanged?(value)
    }
    
    public func editingDidBegin() {}
    
    public func editingDidEnd() {}
    
    // MARK: Private
    
    private var titleColor: UIColor?
}