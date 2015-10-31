//
//  InlineSliderRowFomer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 9/6/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

public protocol InlineSliderFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formColorDisplayView() -> UIView?
}

public final class InlineSliderRowFormer<T: UITableViewCell where T: InlineSliderFormableRow>
: CustomRowFormer<T>, ConfigurableInlineForm, ConfigurableForm {
    
    // MARK: Public
    
    public typealias InlineCellType = FormSliderCell
    
    public let inlineRowFormer: RowFormer
    override public var canBecomeEditing: Bool {
        return enabled
    }
    
    public var value: Float = 0
    public var color: UIColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: (T -> Void)? = nil) {
            inlineRowFormer = SliderRowFormer<InlineCellType>(instantiateType: .Class)
            super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onValueChanged(handler: (Float -> Void)) -> Self {
        onValueChanged = handler
        return self
    }
    
    public final func adjustedValueFromValue(handler: (Float -> Float)) -> Self {
        adjustedValueFromValue = handler
        return self
    }
    
    public override func update() {
        super.update()
        
        let titleLabel = cell.formTitleLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor }
            titleLabel?.textColor = titleDisabledColor
        }
        let colorDisplayView = cell.formColorDisplayView()
        colorDisplayView?.backgroundColor = color
        
        let inlineRowFormer = self.inlineRowFormer as! SliderRowFormer<InlineCellType>
        inlineRowFormer.configure { form in
            form.value = adjustedValueFromValue?(value) ?? value
            form.enabled = enabled
            form.cellHeight = 44
            _ = adjustedValueFromValue.map { form.adjustedValueFromValue($0) }
        }.onValueChanged(valueChanged).update()
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        super.cellSelected(indexPath)
        former?.deselect(true)
    }
    
    private func valueChanged(value: Float) {
        self.value = value
        let colorValue = CGFloat(value)
        color = UIColor(hue: colorValue, saturation: colorValue, brightness: colorValue, alpha: 1)
        update()
        onValueChanged?(value)
    }
    
    public func editingDidBegin() {}
    
    public func editingDidEnd() {}
    
    // MARK: Private
    
    private var onValueChanged: (Float -> Void)?
    private var adjustedValueFromValue: (Float -> Float)?
    private var titleColor: UIColor?
}