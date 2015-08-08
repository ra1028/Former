//
//  SectionFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class SectionFormer: NSObject {
    
    // MARK: Public
    
    public private(set) var rowFormers = [RowFormer]()
    public private(set) var headerViewFormer: ViewFormer? = ViewFormer(viewType: FormerHeaderFooterView.self, registerType: .Class)
    public private(set) var footerViewFormer: ViewFormer?
    
    public var numberOfRows: Int {
        
        return self.rowFormers.count
    }
    
    public subscript(index: Int) -> RowFormer {
        
        return self.rowFormers[index]
    }
    
    public func add(rowFormers rowFormers: [RowFormer]) -> SectionFormer {
        
        self.rowFormers.last?.isBottom = false
        self.rowFormers += rowFormers
        
        self.rowFormers.first?.isTop = true
        self.rowFormers.last?.isBottom = true
        return self
    }
    
    public func insert(rowFormers rowFormers: [RowFormer], toIndex: Int) -> SectionFormer {
        
        self.rowFormers.first?.isTop = false
        self.rowFormers.last?.isBottom = false
        
        let count = self.rowFormers.count
        
        if count == 0 ||  toIndex >= count {
            self.add(rowFormers: rowFormers)
        } else if toIndex == 0 {
            self.rowFormers = rowFormers + self.rowFormers
        } else {
            let last = self.rowFormers.count - 1
            self.rowFormers = self.rowFormers[0...(toIndex - 1)] + rowFormers + self.rowFormers[toIndex...last]
        }
        
        self.rowFormers.first?.isTop = true
        self.rowFormers.last?.isBottom = true
        return self
    }
    
    public func remove(rowFormers rowFormers: [RowFormer]) {
        
        for (index, rowFormer) in self.rowFormers.enumerate() {
            if rowFormers.contains(rowFormer) {
                self.removeRowFormer(index)
            }
        }
    }
    
    public func removeRowFormer(atIndex: Int) {

        self.rowFormers.removeAtIndex(atIndex)
    }
    
    public func removeRowFormer(range: Range<Int>) {
        
        self.rowFormers.removeRange(range)
    }
    
    public func set(headerViewFormer viewFormer: ViewFormer?) -> SectionFormer {
        
        self.headerViewFormer = viewFormer
        return self
    }
    
    public func set(footerViewFormer viewFormer: ViewFormer?) -> SectionFormer {
        
        self.footerViewFormer = viewFormer
        return self
    }
}