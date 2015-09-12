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
    
    func formerTitleLabel() -> UILabel?
    func formerColorDisplayView() -> UIView?
}

public class DemoInlineSliderRowFormer: RowFormer, InlineRow {
    
    public private(set) var inlineRowFormer: RowFormer = SliderRowFormer(
        cellType: FormerSliderCell.self,
        registerType: .Class
    )
    override public var canBecomeEditing: Bool {
        return self.enabled
    }
    
    public var onValueChanged: (Float -> Void)?
    public var adjustedValueFromValue: (Float -> Float)?
    public var value: Float = 0
    public var continuous: Bool?
    public var minimumValue: Float?
    public var maximumValue: Float?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    public var displayColor: UIColor?
    
    public init<T : UITableViewCell where T : DemoInlineSliderFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        onValueChanged: (Float -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.onValueChanged = onValueChanged
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
        self.titleDisabledColor = .lightGrayColor()
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? DemoInlineSliderFormableRow {
            
            if let titleLabel = row.formerTitleLabel() {
                
                self.title.map { titleLabel.text = $0 }
                self.titleFont.map { titleLabel.font = $0 }
                if self.enabled {
                    self.titleColor.map { titleLabel.textColor = $0 }
                } else {
                    self.titleDisabledColor.map { titleLabel.textColor = $0 }
                }
            }
            if let colorDisplayView = row.formerColorDisplayView() {
                
                colorDisplayView.backgroundColor = self.displayColor
            }
        }
        
        if let inlineRowFormer = self.inlineRowFormer as? SliderRowFormer {
            
            inlineRowFormer.cellHeight = 44.0
            inlineRowFormer.onValueChanged = self.valueChanged
            inlineRowFormer.adjustedValueFromValue = self.adjustedValueFromValue
            inlineRowFormer.value = self.adjustedValueFromValue?(self.value) ?? self.value
            inlineRowFormer.continuous = self.continuous
            inlineRowFormer.minimumValue = self.minimumValue
            inlineRowFormer.maximumValue = self.maximumValue
            inlineRowFormer.tintColor = self.tintColor
            inlineRowFormer.enabled = self.enabled
            inlineRowFormer.update()
        }
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        self.former?.deselect(true)
    }
    
    private func valueChanged(value: Float) {
        
        self.value = value
        self.onValueChanged?(value)
    }
    
    public func editingDidBegin() {}
    
    public func editingDidEnd() {}
}