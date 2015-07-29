//
//  SegmentedRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/30/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SegmentedFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel?
    func formerSegmented() -> UISegmentedControl
}

public class SegmentedRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var segmentChangedHandler: (Int -> Void)?
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
        segmentChangedHandler: (Int -> Void)? = nil) {
            
            super.init(cellType: cellType, registerType: registerType)
            self.segmentChangedHandler = segmentChangedHandler
            self.segmentTitles = segmentTitles
            self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? SegmentedFormableRow else { return }
        
        let titleLabel = cell.formerTitleLabel()
        let segmented = cell.formerSegmented()
        
        self.observer.setObservedFormer(self)
        
        titleLabel?.text =? self.title
        titleLabel?.font =? self.titleFont
        titleLabel?.textColor =? self.titleColor
        
        segmented.removeAllSegments()
        for (index, title) in self.segmentTitles.enumerate() {
            segmented.insertSegmentWithTitle(title, atIndex: index, animated: false)
        }
        segmented.tintColor =? self.tintColor
        segmented.selectedSegmentIndex = self.selectedIndex
    }
    
    public dynamic func didChangeValue() {
        
        guard let cell = self.cell as? SegmentedFormableRow else { return }
        let segment = cell.formerSegmented()
        
        let selectedIndex = segment.selectedSegmentIndex
        self.selectedIndex = selectedIndex
        self.segmentChangedHandler?(selectedIndex)
    }
}