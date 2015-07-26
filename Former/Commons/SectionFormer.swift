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
    private(set) var headerViewFormer = ViewFormer(viewType: FormerHeaderFooterView.self)
    private(set) var footerViewFormer = ViewFormer(viewType: FormerHeaderFooterView.self)
    
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
        
        rowFormers.first?.isTop = true
        rowFormers.last?.isBottom = true
        self.rowFormers += rowFormers
        return self
    }
    
    public func setHeaderViewFormer(viewFormer: ViewFormer) -> SectionFormer {
        
        self.headerViewFormer = viewFormer
        return self
    }
    
    public func setFooterViewFormer(viewFormer: ViewFormer) -> SectionFormer {
        
        self.footerViewFormer = viewFormer
        return self
    }
}