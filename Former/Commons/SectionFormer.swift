//
//  SectionFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class SectionFormer {
    
    // MARK: Public
    
    public init(rowFormer: RowFormer...) {
        self.rowFormers = rowFormer
    }
    
    public init(rowFormers: [RowFormer] = []) {
        self.rowFormers = rowFormers
    }
    
    /// All RowFormers. Default is empty.
    public private(set) var rowFormers = [RowFormer]()
    
    /// ViewFormer of applying section header. Default is applying simply 10px spacing section header.
    public private(set) var headerViewFormer: ViewFormer? = ViewFormer(viewType: FormHeaderFooterView.self, instantiateType: .Class)
    
    /// ViewFormer of applying section footer. Default is nil.
    public private(set) var footerViewFormer: ViewFormer?
    
    /// Return all row count.
    public var numberOfRows: Int {
        return rowFormers.count
    }
    
    /// Returns the first element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var firstRowFormer: RowFormer? {
        return rowFormers.first
    }
    
    /// Returns the last element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var lastRowFormer: RowFormer? {
        return rowFormers.last
    }
    
    public subscript(index: Int) -> RowFormer {
        return rowFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [RowFormer] {
        return Array<RowFormer>(rowFormers[range])
    }
    
    /// Append RowFormer to last index.
    public func append(rowFormer rowFormer: RowFormer...) -> Self {
        add(rowFormers: rowFormer)
        return self
    }
    
    /// Add RowFormers to last index.
    public func add(rowFormers rowFormers: [RowFormer]) -> Self {
        self.rowFormers += rowFormers
        return self
    }
    
    /// Insert RowFormer to any index.
    public func insert(rowFormer rowFormer: RowFormer..., toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            add(rowFormers: rowFormers)
            return self
        }
        self.rowFormers.insertContentsOf(rowFormers, at: toIndex)
        return self
    }
    
    /// Insert RowFormers to any index.
    public func insert(rowFormers rowFormers: [RowFormer], toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            add(rowFormers: rowFormers)
            return self
        }
        self.rowFormers.insertContentsOf(rowFormers, at: toIndex)
        return self
    }
    
    /// Insert RowFormer to above other SectionFormer.
    public func insert(rowFormer rowFormer: RowFormer..., above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerate() {
            if rowFormer === above {
                insert(rowFormers: [rowFormer], toIndex: row)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormers to above other SectionFormer.
    public func insert(rowFormers rowFormers: [RowFormer], above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerate() {
            if rowFormer === above {
                insert(rowFormers: [rowFormer], toIndex: row)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormer to below other SectionFormer.
    public func insert(rowFormer rowFormer: RowFormer..., below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerate() {
            if rowFormer === below {
                insert(rowFormers: [rowFormer], toIndex: row + 1)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormers to below other SectionFormer.
    public func insert(rowFormers rowFormers: [RowFormer], below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerate() {
            if rowFormer === below {
                insert(rowFormers: [rowFormer], toIndex: row + 1)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Remove RowFormers from instances of RowFormer.
    public func remove(rowFormer rowFormer: RowFormer...) -> Self {
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerate() {
            if rowFormers.contains({ $0 === rowFormer }) {
                remove(index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove RowFormers from instances of RowFormer.
    public func remove(rowFormers rowFormers: [RowFormer]) -> Self {
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerate() {
            if rowFormers.contains({ $0 === rowFormer }) {
                remove(index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove RowFormer from index.
    public func remove(atIndex: Int) -> Self {
        rowFormers.removeAtIndex(atIndex)
        return self
    }
    
    /// Remove RowFormers from range.
    public func remove(range: Range<Int>) -> Self{
        rowFormers.removeRange(range)
        return self
    }
    
    /// Set ViewFormer to apply section header.
    public func set(headerViewFormer viewFormer: ViewFormer?) -> Self {
        headerViewFormer = viewFormer
        return self
    }
    
    /// Set ViewFormer to apply section footer.
    public func set(footerViewFormer viewFormer: ViewFormer?) -> Self {
        footerViewFormer = viewFormer
        return self
    }
}