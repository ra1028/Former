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

public class SegmentedRowFormer: RowFormer {
    
    public var segmentChangedHandler: ((Int, String) -> Void)?
    public var segmentTitles = [String]()
    public var selectedIndex: Int = 0
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var titleDisabledColor: UIColor?
    
    init<T : UITableViewCell where T : SegmentedFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        segmentTitles: [String],
        segmentChangedHandler: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.segmentChangedHandler = segmentChangedHandler
            self.segmentTitles = segmentTitles
    }
    
    public override func initializeRowFomer() {
        
        super.initializeRowFomer()
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
            titleLabel?.text = self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor = self.enabled ? self.titleColor : self.titleDisabledColor
            
            row.observer.setTargetRowFormer(self,
                control: segment,
                actionEvents: [("valueChanged:", .ValueChanged)]
            )
        }
    }
    
    public func valueChanged(segment: UISegmentedControl) {
        
        if self.enabled {
            let selectedIndex = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegmentAtIndex(selectedIndex)!
            self.selectedIndex = selectedIndex
            self.segmentChangedHandler?(selectedIndex, selectedTitle)
        }
    }
}