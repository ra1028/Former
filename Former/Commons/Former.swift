//
//  Former.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class Former: NSObject {
    
    // MARK: Public
    
    /**
    InstantiateType is type of instantiate of Cell or HeaderFooterView.
    If the cell or HeaderFooterView to instantiate from the nib of mainBudnle , use the case 'Nib(nibName: String)'.
    Using the '.NibBundle(nibName: String, bundle: NSBundle)' If also using the custom bundle.
    Or if without xib, use '.Class'.
    **/
    public enum InstantiateType {
        case Class
        case Nib(nibName: String)
        case NibBundle(nibName: String, bundle: NSBundle)
    }
    
    /// All SectionFormers. Default is empty.
    public private(set) var sectionFormers = [SectionFormer]()
    
    /// Return all RowFormers. Compute each time of called.
    public var rowFormers: [RowFormer] {
        return sectionFormers.flatMap { $0.rowFormers }
    }
    
    /// Number of all sections.
    public var numberOfSections: Int {
        return sectionFormers.count
    }
    
    /// Number of all rows.
    public var numberOfRows: Int {        
        return rowFormers.count
    }
    
    /// Returns the first element of all SectionFormers, or `nil` if `self.sectionFormers` is empty.
    public var firstSectionFormer: SectionFormer? {
        return sectionFormers.first
    }
    
    /// Returns the first element of all RowFormers, or `nil` if `self.rowFormers` is empty.
    public var firstRowFormer: RowFormer? {
        return rowFormers.first
    }
    
    /// Returns the last element of all SectionFormers, or `nil` if `self.sectionFormers` is empty.
    public var lastSectionFormer: SectionFormer? {
        return sectionFormers.last
    }
    
    /// Returns the last element of all RowFormers, or `nil` if `self.rowFormers` is empty.
    public var lastRowFormer: RowFormer? {
        return rowFormers.last
    }
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        setupTableView()
    }
    
    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public subscript(index: Int) -> SectionFormer {
        return sectionFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [SectionFormer] {
        return Array<SectionFormer>(sectionFormers[range])
    }
    
    /// To find RowFormer from indexPath.
    @warn_unused_result
    public func rowFormer(indexPath: NSIndexPath) -> RowFormer {
        return self[indexPath.section][indexPath.row]
    }
    
    /// Call when cell has selected.
    public func onCellSelected(handler: (NSIndexPath -> Void)) -> Self {
        onCellSelected = handler
        return self
    }
    
    /// Call when tableView has scrolled.
    public func onScroll(handler: ((scrollView: UIScrollView) -> Void)) -> Self {
        onScroll = handler
        return self
    }
    
    /// Call when tableView had begin dragging.
    public func onBeginDragging(handler: (UIScrollView -> Void)) -> Self {
        onBeginDragging = handler
        return self
    }
    
    /// Call just before cell is deselect.
    public func willDeselectCell(handler: (NSIndexPath -> NSIndexPath?)) -> Self {
        willDeselectCell = handler
        return self
    }
    
    /// Call just before cell is display.
    public func willDisplayCell(handler: (NSIndexPath -> Void)) -> Self {
        willDisplayCell = handler
        return self
    }

    /// Call just before header is display.
    public func willDisplayHeader(handler: (/*section:*/Int -> Void)) -> Self {
        willDisplayHeader = handler
        return self
    }
    
    /// Call just before cell is display.
    public func willDisplayFooter(handler: (/*section:*/Int -> Void)) -> Self {
        willDisplayFooter = handler
        return self
    }
    
    /// Call when cell has deselect.
    public func didDeselectCell(handler: (NSIndexPath -> Void)) -> Self {
        didDeselectCell = handler
        return self
    }
    
    /// Call when cell has Displayed.
    public func didEndDisplayingCell(handler: (NSIndexPath -> Void)) -> Self {
        didEndDisplayingCell = handler
        return self
    }
    
    /// Call when header has displayed.
    public func didEndDisplayingHeader(handler: (/*section:*/Int -> Void)) -> Self {
        didEndDisplayingHeader = handler
        return self
    }
    
    /// Call when footer has displayed.
    public func didEndDisplayingFooter(handler: (/*section:*/Int -> Void)) -> Self {
        didEndDisplayingFooter = handler
        return self
    }
    
    /// Call when cell has highlighted.
    public func didHighlightCell(handler: (NSIndexPath -> Void)) -> Self {
        didHighlightCell = handler
        return self
    }
    
    /// Call when cell has unhighlighted.
    public func didUnHighlightCell(handler: (NSIndexPath -> Void)) -> Self {
        didUnHighlightCell = handler
        return self
    }
    
    /// 'true' iff can edit previous row.
    @warn_unused_result
    public func canBecomeEditingPrevious() -> Bool {
        var section = selectedIndexPath?.section ?? 0
        var row = (selectedIndexPath != nil) ? selectedIndexPath!.row - 1 : 0
        
        guard section < sectionFormers.count else { return false }
        if row < 0 {
            section -= 1
            guard section >= 0 else { return false }
            row = self[section].rowFormers.count - 1
        }
        guard row < self[section].rowFormers.count else { return false }
        
        return self[section][row].canBecomeEditing
    }
    
    /// 'true' iff can edit next row.
    @warn_unused_result
    public func canBecomeEditingNext() -> Bool {
        var section = selectedIndexPath?.section ?? 0
        var row = (selectedIndexPath != nil) ? selectedIndexPath!.row + 1 : 0
        
        guard section < sectionFormers.count else { return false }
        if row >= self[section].rowFormers.count {
            section += 1
            guard section < sectionFormers.count else { return false }
            row = 0
        }
        guard row < self[section].rowFormers.count else { return false }
        
        return self[section][row].canBecomeEditing
    }
    
    /// Edit previous row iff it can.
    public func becomeEditingPrevious() -> Self {
        if let tableView = tableView where canBecomeEditingPrevious() {
            
            var section = selectedIndexPath?.section ?? 0
            var row = (selectedIndexPath != nil) ? selectedIndexPath!.row - 1 : 0
            guard section < sectionFormers.count else { return self }
            if row < 0 {
                section -= 1
                guard section >= 0 else { return self }
                row = self[section].rowFormers.count - 1
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (rowFormer(indexPath) is InlineForm) ?
                NSIndexPath(forRow: row + 1, inSection: section) : indexPath
            tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .None, animated: false)
        }
        return self
    }
    
    /// Edit next row iff it can.
    public func becomeEditingNext() -> Self {
        if let tableView = tableView where canBecomeEditingNext() {
            
            var section = selectedIndexPath?.section ?? 0
            var row = (selectedIndexPath != nil) ? selectedIndexPath!.row + 1 : 0
            guard section < sectionFormers.count else { return self }
            if row >= self[section].rowFormers.count {
                section += 1
                guard section < sectionFormers.count else { return self }
                row = 0
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (rowFormer(indexPath) is InlineForm) ?
                NSIndexPath(forRow: row + 1, inSection: section) : indexPath
            tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .None, animated: false)
        }
        return self
    }
    
    /// To end editing of tableView.
    public func endEditing() -> Self {
        tableView?.endEditing(true)
        if let selectorRowFormer = selectorRowFormer as? SelectorForm {
            selectorRowFormer.editingDidEnd()
            self.selectorRowFormer = nil
        }
        return self
    }
    
    /// To select row from indexPath.
    public func select(indexPath indexPath: NSIndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        if let tableView = tableView {
            tableView.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
            self.tableView(tableView, willSelectRowAtIndexPath: indexPath)
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
        return self
    }
    
    /// To select row from instance of RowFormer.
    public func select(rowFormer rowFormer: RowFormer, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        for (section, sectionFormer) in sectionFormers.enumerate() {
            if let row = sectionFormer.rowFormers.indexOf({ $0 === rowFormer }) {
                return select(indexPath: NSIndexPath(forRow: row, inSection: section), animated: animated, scrollPosition: scrollPosition)
            }
        }
        return self
    }
    
    /// To deselect current selecting cell.
    public func deselect(animated: Bool) -> Self {
        if let indexPath = selectedIndexPath {
            tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        return self
    }
    
    /// Reload All cells.
    public func reload() -> Self {
        tableView?.reloadData()
        removeCurrentInlineRowUpdate()
        return self
    }
    
    /// Reload sections from section indexSet.
    public func reload(sections sections: NSIndexSet, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        tableView?.reloadSections(sections, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload sections from instance of SectionFormer.
    public func reload(sectionFormer sectionFormer: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        guard let section = sectionFormers.indexOf({ $0 === sectionFormer }) else { return self }
        return reload(sections: NSIndexSet(index: section), rowAnimation: rowAnimation)
    }
    
    /// Reload rows from indesPaths.
    public func reload(indexPaths indexPaths: [NSIndexPath], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload rows from instance of RowFormer.
    public func reload(rowFormer rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        for (section, sectionFormer) in sectionFormers.enumerate() {
            if let row = sectionFormer.rowFormers.indexOf({ $0 === rowFormer}) {
                return reload(indexPaths: [NSIndexPath(forRow: row, inSection: section)], rowAnimation: rowAnimation)
            }
        }
        return self
    }
    
    /// Append SectionFormer to last index.
    public func append(sectionFormer sectionFormer: SectionFormer...) -> Self {
        return add(sectionFormers: sectionFormer)
    }
    
    /// Add SectionFormers to last index.
    public func add(sectionFormers sectionFormers: [SectionFormer]) -> Self {
        self.sectionFormers += sectionFormers
        return self
    }
    
    /// Insert SectionFormer to index of section with NO updates.
    public func insert(sectionFormer sectionFormer: SectionFormer..., toSection: Int) -> Self {
        return insert(sectionFormers: sectionFormer, toSection: toSection)
    }
    
    /// Insert SectionFormers to index of section with NO updates.
    public func insert(sectionFormers sectionFormers: [SectionFormer], toSection: Int) -> Self {
        let count = self.sectionFormers.count
        if count == 0 ||  toSection >= count {
            add(sectionFormers: sectionFormers)
            return self
        } else if toSection >= count {
            self.sectionFormers.insertContentsOf(sectionFormers, at: 0)
            return self
        }
        self.sectionFormers.insertContentsOf(sectionFormers, at: toSection)
        return self
    }
    
    /// Insert SectionFormer to above other SectionFormer with NO updates.
    public func insert(sectionFormer sectionFormer: SectionFormer..., above: SectionFormer) -> Self {
        return insert(sectionFormers: sectionFormer, above: above)
    }
    
    /// Insert SectionFormers to above other SectionFormer with NO updates.
    public func insert(sectionFormers sectionFormers: [SectionFormer], above: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === above {
                return insert(sectionFormers: sectionFormers, toSection: section - 1)
            }
        }
        return add(sectionFormers: sectionFormers)
    }
    
    /// Insert SectionFormer to below other SectionFormer with NO updates.
    public func insert(sectionFormer sectionFormer: SectionFormer..., below: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === below {
                return insert(sectionFormers: sectionFormers, toSection: section + 1)
            }
        }
        add(sectionFormers: sectionFormers)
        return insert(sectionFormers: sectionFormer, below: below)
    }
    
    /// Insert SectionFormers to below other SectionFormer with NO updates.
    public func insert(sectionFormers sectionFormers: [SectionFormer], below: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === below {
                return insert(sectionFormers: sectionFormers, toSection: section + 1)
            }
        }
        return add(sectionFormers: sectionFormers)
    }
    
    /// Insert SectionFormer to index of section with animated updates.
    public func insertUpdate(sectionFormer sectionFormer: SectionFormer..., toSection: Int, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, toSection: toSection, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to index of section with animated updates.
    public func insertUpdate(sectionFormers sectionFormers: [SectionFormer], toSection: Int, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        guard !sectionFormers.isEmpty else { return self }
        removeCurrentInlineRowUpdate()
        tableView?.beginUpdates()
        insert(sectionFormers: sectionFormers, toSection: toSection)
        tableView?.insertSections(NSIndexSet(index: toSection), withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert SectionFormer to above other SectionFormer with animated updates.
    public func insertUpdate(sectionFormer sectionFormer: SectionFormer..., above: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, above: above, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to above other SectionFormer with animated updates.
    public func insertUpdate(sectionFormers sectionFormers: [SectionFormer], above: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === above {
                let indexSet = NSIndexSet(indexesInRange: NSMakeRange(section, sectionFormers.count))
                tableView?.beginUpdates()
                insert(sectionFormers: sectionFormers, toSection: section)
                tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        return self
    }
    
    /// Insert SectionFormer to below other SectionFormer with animated updates.
    public func insertUpdate(sectionFormer sectionFormer: SectionFormer..., below: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, below: below, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to below other SectionFormer with animated updates.
    public func insertUpdate(sectionFormers sectionFormers: [SectionFormer], below: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === below {
                let indexSet = NSIndexSet(indexesInRange: NSMakeRange(section + 1, sectionFormers.count))
                tableView?.beginUpdates()
                insert(sectionFormers: sectionFormers, toSection: section + 1)
                tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        return self
    }
    
    /// Insert RowFormer with NO updates.
    public func insert(rowFormer rowFormer: RowFormer..., toIndexPath: NSIndexPath) -> Self {
        return insert(rowFormers: rowFormer, toIndexPath: toIndexPath)
    }
    
    /// Insert RowFormers with NO updates.
    public func insert(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath) -> Self {
        self[toIndexPath.section].insert(rowFormers: rowFormers, toIndex: toIndexPath.row)
        return self
    }
    
    /// Insert RowFormer to above other RowFormer with NO updates.
    public func insert(rowFormer rowFormer: RowFormer..., above: RowFormer) -> Self {
        return insert(rowFormers: rowFormer, above: above)
    }
    
    /// Insert RowFormers to above other RowFormer with NO updates.
    public func insert(rowFormers rowFormers: [RowFormer], above: RowFormer) -> Self {
        guard !rowFormers.isEmpty else { return self }
        for sectionFormer in self.sectionFormers {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === above {
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row)
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormers to below other RowFormer with NO updates.
    public func insert(rowFormer rowFormer: RowFormer..., below: RowFormer) -> Self {
        return insert(rowFormers: rowFormer, below: below)
    }
    
    /// Insert RowFormers to below other RowFormer with NO updates.
    public func insert(rowFormers rowFormers: [RowFormer], below: RowFormer) -> Self {
        guard !rowFormers.isEmpty else { return self }
        for sectionFormer in self.sectionFormers {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === below {
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row + 1)
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormer with animated updates.
    public func insertUpdate(rowFormer rowFormer: RowFormer..., toIndexPath: NSIndexPath, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(rowFormers: rowFormer, toIndexPath: toIndexPath, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers with animated updates.
    public func insertUpdate(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        insert(rowFormers: rowFormers, toIndexPath: toIndexPath)
        let insertIndexPaths = (0..<rowFormers.count).map {
            NSIndexPath(forRow: toIndexPath.row + $0, inSection: toIndexPath.section)
        }
        tableView?.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert RowFormer to above other RowFormer with animated updates.
    public func insertUpdate(rowFormer rowFormer: RowFormer..., above: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(rowFormers: rowFormer, above: above, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers to above other RowFormer with animated updates.
    public func insertUpdate(rowFormers rowFormers: [RowFormer], above: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === above {
                    let indexPaths = (row..<row + rowFormers.count).map {
                        NSIndexPath(forRow: $0, inSection: section)
                    }
                    tableView?.beginUpdates()
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row)
                    tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormer to below other RowFormer with animated updates.
    public func insertUpdate(rowFormer rowFormer: RowFormer..., below: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return insertUpdate(rowFormers: rowFormer, below: below, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers to below other RowFormer with animated updates.
    public func insertUpdate(rowFormers rowFormers: [RowFormer], below: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === below {
                    let indexPaths = (row + 1..<row + 1 + rowFormers.count).map {
                        NSIndexPath(forRow: $0, inSection: section)
                    }
                    tableView?.beginUpdates()
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row + 1)
                    tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove All SectionFormers with NO updates.
    public func removeAll() -> Self {
        sectionFormers = []
        return self
    }
    
    /// Remove All SectionFormers with animated updates.
    public func removeAllUpdate(rowAnimation: UITableViewRowAnimation = .None) -> Self {
        let indexSet = NSIndexSet(indexesInRange: NSMakeRange(0, sectionFormers.count))
        sectionFormers = []
        guard indexSet.count > 0 else { return self }
        tableView?.beginUpdates()
        tableView?.deleteSections(indexSet, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Remove SectionFormers from section index with NO updates.
    public func remove(section section: Int) -> Self {
        sectionFormers.removeAtIndex(section)
        return self
    }
    
    /// Remove SectionFormers from instances of SectionFormer with NO updates.
    public func remove(sectionFormer sectionFormer: SectionFormer...) -> Self {
        return remove(sectionFormers: sectionFormer)
    }
    
    /// Remove SectionFormers from instances of SectionFormer with NO updates.
    public func remove(sectionFormers sectionFormers: [SectionFormer]) -> Self {
        removeSectionFormers(sectionFormers)
        return self
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    public func removeUpdate(sectionFormer sectionFormer: SectionFormer..., rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return removeUpdate(sectionFormers: sectionFormer, rowAnimation: rowAnimation)
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    public func removeUpdate(sectionFormers sectionFormers: [SectionFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        guard !sectionFormers.isEmpty else { return self }
        let indexSet = removeSectionFormers(sectionFormers)
        guard indexSet.count > 0 else { return self }
        tableView?.beginUpdates()
        tableView?.deleteSections(indexSet, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Remove RowFormer with NO updates.
    public func remove(rowFormer rowFormer: RowFormer...) -> Self {
        return remove(rowFormers: rowFormer)
    }
    
    /// Remove RowFormers with NO updates.
    public func remove(rowFormers rowFormers: [RowFormer]) -> Self {
        removeRowFormers(rowFormers)
        return self
    }
    
    /// Remove RowFormers with animated updates.
    public func removeUpdate(rowFormer rowFormer: RowFormer..., rowAnimation: UITableViewRowAnimation = .None) -> Self {
        return removeUpdate(rowFormers: rowFormer, rowAnimation: rowAnimation)
    }
    
    /// Remove RowFormers with animated updates.
    public func removeUpdate(rowFormers rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        let oldIndexPaths = removeRowFormers(rowFormers)
        tableView?.deleteRowsAtIndexPaths(oldIndexPaths, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    // MARK: Private
    
    private var onCellSelected: ((indexPath: NSIndexPath) -> Void)?
    private var onScroll: ((scrollView: UIScrollView) -> Void)?
    private var onBeginDragging: ((scrollView: UIScrollView) -> Void)?
    private var willDeselectCell: ((indexPath: NSIndexPath) -> NSIndexPath?)?
    private var willDisplayCell: ((indexPath: NSIndexPath) -> Void)?
    private var willDisplayHeader: ((section: Int) -> Void)?
    private var willDisplayFooter: ((section: Int) -> Void)?
    private var didDeselectCell: ((indexPath: NSIndexPath) -> Void)?
    private var didEndDisplayingCell: ((indexPath: NSIndexPath) -> Void)?
    private var didEndDisplayingHeader: ((section: Int) -> Void)?
    private var didEndDisplayingFooter: ((section: Int) -> Void)?
    private var didHighlightCell: ((indexPath: NSIndexPath) -> Void)?
    private var didUnHighlightCell: ((indexPath: NSIndexPath) -> Void)?
    
    private weak var tableView: UITableView?
    private weak var inlineRowFormer: RowFormer?
    private weak var selectorRowFormer: RowFormer?
    private var selectedIndexPath: NSIndexPath?
    private var oldBottomContentInset: CGFloat?
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Former.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Former.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeCurrentInlineRow() -> NSIndexPath? {
        var indexPath: NSIndexPath? = nil
        if let oldInlineRowFormer = (inlineRowFormer as? InlineForm)?.inlineRowFormer,
            let removedIndexPath = removeRowFormers([oldInlineRowFormer]).first {
                indexPath = removedIndexPath
                (inlineRowFormer as? InlineForm)?.editingDidEnd()
                inlineRowFormer = nil
        }
        return indexPath
    }
    
    private func removeCurrentInlineRowUpdate() {
        if let removedIndexPath = removeCurrentInlineRow() {
            tableView?.beginUpdates()
            tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
            tableView?.endUpdates()
        }
    }
    
    private func removeSectionFormers(sectionFormers: [SectionFormer]) -> NSIndexSet {
        var removedCount = 0
        let indexSet = NSMutableIndexSet()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormers.contains({ $0 === sectionFormer}) {
                indexSet.addIndex(section)
                remove(section: section)
                removedCount += 1
                if removedCount >= sectionFormers.count {
                    return indexSet
                }
            }
        }
        return indexSet
    }
    
    private func removeRowFormers(rowFormers: [RowFormer]) -> [NSIndexPath] {
        var removedCount = 0
        var removeIndexPaths = [NSIndexPath]()
        for (section, sectionFormer) in sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormers.contains({ $0 === rowFormer }) {
                    removeIndexPaths.append(NSIndexPath(forRow: row, inSection: section))
                    sectionFormer.remove(rowFormers: [rowFormer])
                    if let oldInlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer {
                        removeIndexPaths.append(NSIndexPath(forRow: row + 1, inSection: section))
                        removeRowFormers([oldInlineRowFormer])
                        (inlineRowFormer as? InlineForm)?.editingDidEnd()
                        inlineRowFormer = nil
                    }
                    removedCount += 1
                    if removedCount >= rowFormers.count {
                        return removeIndexPaths
                    }
                }
            }
        }
        return removeIndexPaths
    }
    
    private func findFirstResponder(view: UIView?) -> UIView? {
        if view?.isFirstResponder() ?? false {
            return view
        }
        for subView in view?.subviews ?? [] {
            if let firstResponder = findFirstResponder(subView) {
                return firstResponder
            }
        }
        return nil
    }
    
    private func findCellWithSubView(view: UIView?) -> UITableViewCell? {
        if let view = view {
            if let cell = view as? UITableViewCell {
                return cell
            }
            return findCellWithSubView(view.superview)
        }
        return nil
    }
    
    private dynamic func keyboardWillAppear(notification: NSNotification) {
        guard let keyboardInfo = notification.userInfo else { return }
        
        if case let (tableView?, cell?) = (tableView, findCellWithSubView(findFirstResponder(tableView))) {
            
            let frame = keyboardInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let keyboardFrame = tableView.window!.convertRect(frame, toView: tableView.superview!)
            let bottomInset = CGRectGetMinY(tableView.frame) + CGRectGetHeight(tableView.frame) - CGRectGetMinY(keyboardFrame)
            guard bottomInset > 0 else { return }
            
            if oldBottomContentInset == nil {
                oldBottomContentInset = tableView.contentInset.bottom
            }
            let duration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
            let curve = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]!.integerValue
            guard let indexPath = tableView.indexPathForCell(cell) else { return }
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            tableView.contentInset.bottom = bottomInset
            tableView.scrollIndicatorInsets.bottom = bottomInset
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
            UIView.commitAnimations()
        }
    }
    
    private dynamic func keyboardWillDisappear(notification: NSNotification) {
        guard let keyboardInfo = notification.userInfo else { return }
        
        if case let (tableView?, inset?) = (tableView, oldBottomContentInset) {
            let duration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
            let curve = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]!.integerValue
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            tableView.contentInset.bottom = inset
            tableView.scrollIndicatorInsets.bottom = inset
            UIView.commitAnimations()
            oldBottomContentInset = nil
        }
    }
}

extension Former: UITableViewDelegate, UITableViewDataSource {
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        endEditing()
        onBeginDragging?(scrollView: scrollView)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        onScroll?(scrollView: scrollView)
    }
    
    public func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return willDeselectCell?(indexPath: indexPath) ?? indexPath
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        willDisplayCell?(indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeader?(section: section)
    }
    
    public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooter?(section: section)
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        didDeselectCell?(indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        didEndDisplayingCell?(indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeader?(section: section)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooter?(section: section)
    }
    
    public func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        didHighlightCell?(indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        didUnHighlightCell?(indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        endEditing()
        deselect(false)
        selectedIndexPath = indexPath
        return indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowFormer = self.rowFormer(indexPath)
        guard rowFormer.enabled else { return }
        
        rowFormer.cellSelected(indexPath)
        onCellSelected?(indexPath: indexPath)
        
        // InlineRow
        if let oldInlineRowFormer = (inlineRowFormer as? InlineForm)?.inlineRowFormer {
            if let currentInlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer
                where rowFormer !== inlineRowFormer {
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = removeRowFormers([oldInlineRowFormer]).first {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        insert(rowFormers: [currentInlineRowFormer], toIndexPath: insertIndexPath)
                        self.tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
                        self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Middle)
                    }
                    self.tableView?.endUpdates()
                    (inlineRowFormer as? InlineForm)?.editingDidEnd()
                    (rowFormer as? InlineForm)?.editingDidBegin()
                    inlineRowFormer = rowFormer
            } else {
                removeCurrentInlineRowUpdate()
            }
        } else if let inlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer {
            let inlineIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            insertUpdate(rowFormers: [inlineRowFormer], toIndexPath: inlineIndexPath, rowAnimation: .Middle)
            (rowFormer as? InlineForm)?.editingDidBegin()
            self.inlineRowFormer = rowFormer
        }
        
        // SelectorRow
        if let selectorRow = rowFormer as? SelectorForm {
            if let selectorRowFormer = selectorRowFormer {
                if !(selectorRowFormer === rowFormer) {
                    selectorRow.editingDidBegin()
                }
            } else {
                selectorRow.editingDidBegin()
            }
            selectorRowFormer = rowFormer
            rowFormer.cellInstance.becomeFirstResponder()
        }
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // for Cell
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].numberOfRows
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowFormer = self.rowFormer(indexPath)
        if let dynamicRowHeight = rowFormer.dynamicRowHeight {
            rowFormer.rowHeight = dynamicRowHeight(tableView, indexPath)
        }
        return rowFormer.rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowFormer = self.rowFormer(indexPath)
        if let dynamicRowHeight = rowFormer.dynamicRowHeight {
            rowFormer.rowHeight = dynamicRowHeight(tableView, indexPath)
        }
        return rowFormer.rowHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowFormer = self.rowFormer(indexPath)
        if rowFormer.former == nil { rowFormer.former = self }
        rowFormer.update()
        return rowFormer.cellInstance
    }
    
    // for HeaderFooterView

    // Not implemented for iOS8 estimatedHeight bug
//    public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        let headerViewFormer = self[section].headerViewFormer
//        if let dynamicViewHeight = headerViewFormer?.dynamicViewHeight {
//            headerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
//        }
//        return headerViewFormer?.viewHeight ?? 0
//    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerViewFormer = self[section].headerViewFormer
        if let dynamicViewHeight = headerViewFormer?.dynamicViewHeight {
            headerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
        }
        return headerViewFormer?.viewHeight ?? 0
    }
    
    // Not implemented for iOS8 estimatedHeight bug
//    public func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        let footerViewFormer = self[section].footerViewFormer
//        if let dynamicViewHeight = footerViewFormer?.dynamicViewHeight {
//            footerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
//        }
//        return footerViewFormer?.viewHeight ?? 0
//    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerViewFormer = self[section].footerViewFormer
        if let dynamicViewHeight = footerViewFormer?.dynamicViewHeight {
            footerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
        }
        return footerViewFormer?.viewHeight ?? 0
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewFormer = self[section].headerViewFormer else { return nil }
        viewFormer.update()
        return viewFormer.viewInstance
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        
        guard let viewFormer = self[section].footerViewFormer else { return nil }
        viewFormer.update()
        return viewFormer.viewInstance
    }
}