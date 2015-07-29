//
//  StepperRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol StepperFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
    func formerDisplayLabel() -> UILabel?
    func formerStepper() -> UIStepper
}

public class StepperRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var stepChangedHandler: (Double -> Void)?
    public var displayTextFromValue: (Double -> String)?
    public var value: Double = 0
    public var tintColor: UIColor?
    public var continuous: Bool?
    public var autorepeat: Bool?
    public var wraps: Bool?
    public var minimumValue: Double?
    public var maximumValue: Double?
    public var stepValue: Double?
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    
    public var displayFont: UIFont?
    public var displayColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        stepChangedHandler: (Double -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.stepChangedHandler = stepChangedHandler
            self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? StepperFormableRow else { return }
        
        let titleLabel = cell.formerTitleLabel()
        let displayLabel = cell.formerDisplayLabel()
        let stepper = cell.formerStepper()
        
        self.observer.setObservedFormer(self)
        
        titleLabel?.text =? self.title
        titleLabel?.font =? self.titleFont
        titleLabel?.textColor =? self.titleColor
        
        stepper.value = self.value
        stepper.tintColor =? self.tintColor
        stepper.continuous =? self.continuous
        stepper.autorepeat =? self.autorepeat
        stepper.wraps =? self.wraps
        stepper.minimumValue =? self.minimumValue
        stepper.maximumValue =? self.maximumValue
        stepper.stepValue =? self.stepValue
        
        displayLabel?.text = self.displayTextFromValue?(value) ?? "\(value)"
        displayLabel?.font =? self.displayFont
        displayLabel?.textColor =? self.displayColor ?? stepper.tintColor
    }
    
    public dynamic func didChangeValue() {
        
        guard let cell = self.cell as? StepperFormableRow else { return }
        let stepper = cell.formerStepper()
        let display = cell.formerDisplayLabel()

        let value = stepper.value
        self.value = value
        display?.text = self.displayTextFromValue?(value) ?? "\(value)"
        self.stepChangedHandler?(value)
    }
}