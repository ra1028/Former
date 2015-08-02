//
//  FormerObserver.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerObserver: NSObject {
    
    private weak var observedRowFormer: RowFormer?
    private weak var observedObject: NSObject?
    
    override init() {
        super.init()
    }
    
    convenience init(rowFormer: RowFormer) {
        
        self.init()
        self.observedRowFormer = rowFormer
    }
    
    deinit {
        self.removeSuitableObserver()
    }
    
    public func setObservedFormer(rowFormer: RowFormer) {
        self.removeSuitableObserver()
        self.observedRowFormer = rowFormer
        self.addSuitableObserver()
    }
    
    public func removeSuitableObserver() {
        
        (self.observedObject as? UIControl)?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.observedRowFormer = nil
        self.observedObject = nil
    }
    
    private func addSuitableObserver() {
        
        guard let rowFormer = self.observedRowFormer else { return }
        
        var targetComponents = [(Selector, UIControlEvents)]()
        switch rowFormer {
            
        case let rowFormer as TextFieldRowFormer:
            guard let cell = rowFormer.cell as? TextFieldFormableRow else { break }
            self.observedObject = cell.formerTextField()
            targetComponents = [
                ("didChangeText", .EditingChanged),
                ("editingDidBegin", .EditingDidBegin),
                ("editingDidEnd", .EditingDidEnd)
            ]
        case let rowFormer as SwitchRowFormer:
            guard let cell = rowFormer.cell as? SwitchFormableRow else { break }
            self.observedObject = cell.formerSwitch()
            targetComponents = [("didChangeSwitch", .ValueChanged)]
        case let rowFormer as StepperRowFormer:
            guard let cell = rowFormer.cell as? StepperFormableRow else { break }
            self.observedObject = cell.formerStepper()
            targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as SegmentedRowFormer:
            guard let cell = rowFormer.cell as? SegmentedFormableRow else { break }
            self.observedObject = cell.formerSegmented()
            targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as SliderRowFormer:
            guard let cell = rowFormer.cell as? SliderFormableRow else { break }
            self.observedObject = cell.formerSlider()
            targetComponents = [("didChangeValue", .ValueChanged)]
        case let rowFormer as DatePickerRowFormer:
            guard let cell = rowFormer.cell as? DatePickerFormableRow else { break }
            self.observedObject = cell.formerDatePicker()
            targetComponents = [("didChangeDate", .ValueChanged)]
        default: break
        }

        targetComponents.map {
            (self.observedObject as? UIControl)?.addTarget(rowFormer, action: $0.0, forControlEvents: $0.1)
        }
    }
}