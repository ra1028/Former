//
//  SegmentedRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SegmentedFormableRow: FormableRow {
    
    var observer: FormerObserver { get }
    
    func formSegmented() -> UISegmentedControl
    func formTitleLabel() -> UILabel?
}

public class SegmentedRowFormer<T: UITableViewCell where T: SegmentedFormableRow>
: CustomRowFormer<T>, FormerValidatable {
    
    // MARK: Public
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onSegmentSelected: ((Int, String) -> Void)?
    public var segmentTitles = [String]()
    public var selectedIndex: Int = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public override func update() {
        super.update()
        
        cell?.selectionStyle = .None
        if let row = cell as? SegmentedFormableRow {
            let titleLabel = row.formTitleLabel()
            let segment = row.formSegmented()
            segment.removeAllSegments()
            for (index, title) in segmentTitles.enumerate() {
                segment.insertSegmentWithTitle(title, atIndex: index, animated: false)
            }
            segment.selectedSegmentIndex = selectedIndex
            segment.enabled = enabled
            
            if enabled {
                titleLabel?.textColor =? titleColor
                titleColor = nil
            } else {
                titleColor ?= titleLabel?.textColor
                titleLabel?.textColor = titleDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: segment,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        let index = selectedIndex
        let selectedTitle = segmentTitles[selectedIndex]
        return onValidate?(index, selectedTitle) ?? true
    }
    
    // MARK: Private
    
    private var titleColor: UIColor?
    
    private dynamic func valueChanged(segment: UISegmentedControl) {
        if enabled {
            let index = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegmentAtIndex(selectedIndex)!
            selectedIndex = index
            onSegmentSelected?(selectedIndex, selectedTitle)
        }
    }
}