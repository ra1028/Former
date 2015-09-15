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
    
    func formerSegmented() -> UISegmentedControl
    func formerTitleLabel() -> UILabel?
}

public class SegmentedRowFormer: RowFormer, FormerValidatable {
    
    public var onValidate: ((Int, String) -> Bool)?
    
    public var onSegmentSelected: ((Int, String) -> Void)?
    public var segmentTitles = [String]()
    public var selectedIndex: Int = 0
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    public init<T : UITableViewCell where T : SegmentedFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        segmentTitles: [String],
        onSegmentSelected: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.onSegmentSelected = onSegmentSelected
            self.segmentTitles = segmentTitles
    }
    
    public override func initialize() {
        
        super.initialize()
        self.titleDisabledColor = .lightGrayColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func update() {
        
        super.update()
        
        if let row = self.cell as? SegmentedFormableRow {
            
            let segment = row.formerSegmented()
            segment.removeAllSegments()
            for (index, title) in self.segmentTitles.enumerate() {
                segment.insertSegmentWithTitle(title, atIndex: index, animated: false)
            }
            segment.selectedSegmentIndex = self.selectedIndex
            segment.enabled = self.enabled
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.titleFont
            
            if self.enabled {
                titleLabel?.textColor =? self.titleColor
            } else {
                titleLabel?.textColor =? self.titleDisabledColor
            }
            
            row.observer.setTargetRowFormer(self,
                control: segment,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func validate() -> Bool {
        
        let selectedIndex = self.selectedIndex
        let selectedTitle = self.segmentTitles[selectedIndex]
        return self.onValidate?(selectedIndex, selectedTitle) ?? true
    }
    
    public dynamic func valueChanged(segment: UISegmentedControl) {
        
        if self.enabled {
            let selectedIndex = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegmentAtIndex(selectedIndex)!
            self.selectedIndex = selectedIndex
            self.onSegmentSelected?(selectedIndex, selectedTitle)
        }
    }
}