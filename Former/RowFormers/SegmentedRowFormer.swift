//
//  SegmentedRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SegmentedFormableRow: FormableRow {
        
    func formSegmented() -> UISegmentedControl
    func formTitleLabel() -> UILabel?
}

public class SegmentedRowFormer<T: UITableViewCell where T: SegmentedFormableRow>
: BaseRowFormer<T>, Formable {
    
    // MARK: Public
    
    public var segmentTitles = [String]()
    public var selectedIndex: Int = 0
    public var titleDisabledColor: UIColor? = .lightGrayColor()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onSegmentSelected(handler: ((Int, String) -> Void)) -> Self {
        onSegmentSelected = handler
        return self
    }
    
    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formSegmented().addTarget(self, action: #selector(SegmentedRowFormer.valueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let titleLabel = cell.formTitleLabel()
        let segment = cell.formSegmented()
        segment.removeAllSegments()
        for (index, title) in segmentTitles.enumerate() {
            segment.insertSegmentWithTitle(title, atIndex: index, animated: false)
        }
        segment.selectedSegmentIndex = selectedIndex
        segment.enabled = enabled
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .blackColor() }
            titleLabel?.textColor = titleDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onSegmentSelected: ((Int, String) -> Void)?
    private final var titleColor: UIColor?
    
    private dynamic func valueChanged(segment: UISegmentedControl) {
        if enabled {
            let index = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegmentAtIndex(index)!
            selectedIndex = index
            onSegmentSelected?(selectedIndex, selectedTitle)
        }
    }
}