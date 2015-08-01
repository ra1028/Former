//
//  SegmentedRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SegmentedFormableRow: FormableRow {
    
    func formerSegmented() -> UISegmentedControl
    func formerTitleLabel() -> UILabel?
}

public class SegmentedRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var segmentChangedHandler: ((Int, String) -> Void)?
    public var segmentTitles = [String]()
    public var tintColor: UIColor?
    public var selectedIndex: Int = 0
    
    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    
    init<T : UITableViewCell where T : SegmentedFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        segmentTitles: [String],
        segmentChangedHandler: ((Int, String) -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.segmentChangedHandler = segmentChangedHandler
            self.segmentTitles = segmentTitles
            self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        self.observer.setObservedFormer(self)
        
        if let row = self.cell as? SegmentedFormableRow {
            
            let segmented = row.formerSegmented()
            segmented.removeAllSegments()
            for (index, title) in self.segmentTitles.enumerate() {
                segmented.insertSegmentWithTitle(title, atIndex: index, animated: false)
            }
            segmented.tintColor =? self.tintColor
            segmented.selectedSegmentIndex = self.selectedIndex
            
            let titleLabel = row.formerTitleLabel()
            titleLabel?.text =? self.title
            titleLabel?.font =? self.titleFont
            titleLabel?.textColor =? self.titleColor
        }
    }
    
    public dynamic func didChangeValue() {
        
        if let cell = self.cell as? SegmentedFormableRow {
            let segment = cell.formerSegmented()
            let selectedIndex = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegmentAtIndex(selectedIndex)!
            self.selectedIndex = selectedIndex
            self.segmentChangedHandler?(selectedIndex, selectedTitle)
        }
    }
}