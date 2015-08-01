//
//  SectionFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class SectionFormer {
    
    private(set) var rowFormers = [RowFormer]()
    public private(set) var headerViewFormer: ViewFormer? = ViewFormer(viewType: FormerHeaderFooterView.self, registerType: .Class)
    public private(set) var footerViewFormer: ViewFormer?
    
    public var numberOfRowFormers: Int {
        return self.rowFormers.count
    }
    
    public subscript(index: Int) -> RowFormer {
        
        return self.rowFormers[index]
    }
    
    public func addRowFormer(rowFormer: RowFormer) -> SectionFormer {
        
        return self.addRowFormers([rowFormer])
    }
    
    public func addRowFormers(rowFormers: [RowFormer]) -> SectionFormer {
        
        self.rowFormers.last?.isBottom = false
        self.rowFormers += rowFormers
        
        self.rowFormers.first?.isTop = true
        self.rowFormers.last?.isBottom = true
        return self
    }
    
    public func insertRowFormer(rowFormer: RowFormer, atIndex: Int) -> SectionFormer {
        
        return self.insertRowFormers([rowFormer], atIndex: atIndex)
    }
    
    public func insertRowFormers(rowFormers: [RowFormer], atIndex: Int) -> SectionFormer {
        
        self.rowFormers.first?.isTop = false
        self.rowFormers.last?.isBottom = false
        
        let count = self.rowFormers.count
        
        if count == 0 ||  atIndex >= count {
            self.addRowFormers(rowFormers)
        } else if atIndex == 0 {
            self.rowFormers = rowFormers + self.rowFormers
        } else {
            let last = self.rowFormers.count - 1
            self.rowFormers = self.rowFormers[0...(atIndex - 1)] + rowFormers + self.rowFormers[atIndex...last]
        }
        
        self.rowFormers.first?.isTop = true
        self.rowFormers.last?.isBottom = true
        return self
    }
    
    public func removeRowFormer(rowFormer: RowFormer) -> Int? {
        
        for (index, oldRowFormers) in self.rowFormers.enumerate() {
            
            if oldRowFormers === rowFormer {
                self.removeRowFormer(index)
                return index
            }
        }
        return nil
    }
    
    public func removeRowFormer(atIndex: Int) {
        
        self.rowFormers.removeAtIndex(atIndex)
    }
    
    public func setHeaderViewFormer(viewFormer: ViewFormer?) -> SectionFormer {
        
        self.headerViewFormer = viewFormer
        return self
    }
    
    public func setFooterViewFormer(viewFormer: ViewFormer?) -> SectionFormer {
        
        self.footerViewFormer = viewFormer
        return self
    }
}