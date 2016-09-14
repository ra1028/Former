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

public class SegmentedRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: SegmentedFormableRow {
    
    // MARK: Public
    
    public var segmentTitles = [String]()
    public var selectedIndex: Int = 0
    public var titleDisabledColor: UIColor? = .lightGray
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    @discardableResult
    public final func onSegmentSelected(_ handler: @escaping ((Int, String) -> Void)) -> Self {
        onSegmentSelected = handler
        return self
    }
    
    public override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        cell.formSegmented().addTarget(self, action: #selector(SegmentedRowFormer.valueChanged(segment:)), for: .valueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        let segment = cell.formSegmented()
        segment.removeAllSegments()
        for (index, title) in segmentTitles.enumerated() {
            segment.insertSegment(withTitle: title, at: index, animated: false)
        }
        segment.selectedSegmentIndex = selectedIndex
        segment.isEnabled = enabled
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
        }
    }
    
    // MARK: Private
    
    private final var onSegmentSelected: ((Int, String) -> Void)?
    private final var titleColor: UIColor?
    
    private dynamic func valueChanged(segment: UISegmentedControl) {
        if enabled {
            let index = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegment(at: index)!
            selectedIndex = index
            onSegmentSelected?(selectedIndex, selectedTitle)
        }
    }
}
