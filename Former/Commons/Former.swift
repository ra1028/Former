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
        case NibBundle(nibName: String, bundle: Bundle)
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
        NotificationCenter.default.removeObserver(self)
    }
    
    public subscript(index: Int) -> SectionFormer {
        return sectionFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [SectionFormer] {
        return Array<SectionFormer>(sectionFormers[range])
    }

    public subscript(range: ClosedRange<Int>) -> [SectionFormer] {
        return Array<SectionFormer>(sectionFormers[range])
    }

    public subscript(range: CountableRange<Int>) -> [SectionFormer] {
        return Array<SectionFormer>(sectionFormers[range])
    }

    public subscript(range: CountableClosedRange<Int>) -> [SectionFormer] {
        return Array<SectionFormer>(sectionFormers[range])
    }

    /// To find RowFormer from indexPath.
    public func rowFormer(indexPath: IndexPath) -> RowFormer {
        return self[indexPath.section][indexPath.row]
    }
    
    /// Call when cell has selected.
    @discardableResult
    public func onCellSelected(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        onCellSelected = handler
        return self
    }
    
    /// Call when tableView has scrolled.
    @discardableResult
    public func onScroll(_ handler: @escaping ((UIScrollView) -> Void)) -> Self {
        onScroll = handler
        return self
    }
    
    /// Call when tableView had begin dragging.
    @discardableResult
    public func onBeginDragging(_ handler: @escaping ((UIScrollView) -> Void)) -> Self {
        onBeginDragging = handler
        return self
    }
    
    /// Call just before cell is deselect.
    @discardableResult
    public func willDeselectCell(_ handler: @escaping ((IndexPath) -> IndexPath?)) -> Self {
        willDeselectCell = handler
        return self
    }
    
    /// Call just before cell is display.
    @discardableResult
    public func willDisplayCell(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        willDisplayCell = handler
        return self
    }

    /// Call just before header is display.
    @discardableResult
    public func willDisplayHeader(_ handler: @escaping ((/*section:*/Int) -> Void)) -> Self {
        willDisplayHeader = handler
        return self
    }
    
    /// Call just before cell is display.
    @discardableResult
    public func willDisplayFooter(_ handler: @escaping ((/*section:*/Int) -> Void)) -> Self {
        willDisplayFooter = handler
        return self
    }
    
    /// Call when cell has deselect.
    @discardableResult
    public func didDeselectCell(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        didDeselectCell = handler
        return self
    }
    
    /// Call when cell has Displayed.
    @discardableResult
    public func didEndDisplayingCell(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        didEndDisplayingCell = handler
        return self
    }
    
    /// Call when header has displayed.
    @discardableResult
    public func didEndDisplayingHeader(_ handler: @escaping ((/*section:*/Int) -> Void)) -> Self {
        didEndDisplayingHeader = handler
        return self
    }
    
    /// Call when footer has displayed.
    @discardableResult
    public func didEndDisplayingFooter(_ handler: @escaping ((/*section:*/Int) -> Void)) -> Self {
        didEndDisplayingFooter = handler
        return self
    }
    
    /// Call when cell has highlighted.
    @discardableResult
    public func didHighlightCell(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        didHighlightCell = handler
        return self
    }
    
    /// Call when cell has unhighlighted.
    @discardableResult
    public func didUnHighlightCell(_ handler: @escaping ((IndexPath) -> Void)) -> Self {
        didUnHighlightCell = handler
        return self
    }
    
    /// 'true' iff can edit previous row.
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
    @discardableResult
    public func becomeEditingPrevious() -> Self {
        if let tableView = tableView, canBecomeEditingPrevious() {
            
            var section = selectedIndexPath?.section ?? 0
            var row = (selectedIndexPath != nil) ? selectedIndexPath!.row - 1 : 0
            guard section < sectionFormers.count else { return self }
            if row < 0 {
                section -= 1
                guard section >= 0 else { return self }
                row = self[section].rowFormers.count - 1
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = IndexPath(row: row, section: section)
            select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (rowFormer(indexPath: indexPath) is InlineForm) ?
                IndexPath(row: row + 1, section: section) : indexPath
            tableView.scrollToRow(at: scrollIndexPath, at: .none, animated: false)
        }
        return self
    }
    
    /// Edit next row iff it can.
    @discardableResult
    public func becomeEditingNext() -> Self {
        if let tableView = tableView, canBecomeEditingNext() {
            
            var section = selectedIndexPath?.section ?? 0
            var row = (selectedIndexPath != nil) ? selectedIndexPath!.row + 1 : 0
            guard section < sectionFormers.count else { return self }
            if row >= self[section].rowFormers.count {
                section += 1
                guard section < sectionFormers.count else { return self }
                row = 0
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = IndexPath(row: row, section: section)
            select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (rowFormer(indexPath: indexPath) is InlineForm) ?
                IndexPath(row: row + 1, section: section) : indexPath
            tableView.scrollToRow(at: scrollIndexPath, at: .none, animated: false)
        }
        return self
    }

    /// To end editing of tableView.
    @discardableResult
    public func endEditing() -> Self {
        tableView?.endEditing(true)
        if let selectorRowFormer = selectorRowFormer as? SelectorForm {
            selectorRowFormer.editingDidEnd()
            self.selectorRowFormer = nil
        }
        return self
    }
    
    /// To select row from indexPath.
    @discardableResult
    public func select(indexPath: IndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition = .none) -> Self {
        if let tableView = tableView {
            tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
            _ = self.tableView(tableView, willSelectRowAt: indexPath)
            self.tableView(tableView, didSelectRowAt: indexPath)
        }
        return self
    }
    
    /// To select row from instance of RowFormer.
    @discardableResult
    public func select(rowFormer: RowFormer, animated: Bool, scrollPosition: UITableViewScrollPosition = .none) -> Self {
        for (section, sectionFormer) in sectionFormers.enumerated() {
            if let row = sectionFormer.rowFormers.index(where: { $0 === rowFormer }) {
                return select(indexPath: IndexPath(row: row, section: section), animated: animated, scrollPosition: scrollPosition)
            }
        }
        return self
    }
    
    /// To deselect current selecting cell.
    @discardableResult
    public func deselect(animated: Bool) -> Self {
        if let indexPath = selectedIndexPath {
            tableView?.deselectRow(at: indexPath, animated: animated)
        }
        return self
    }
    
    /// Reload All cells.
    @discardableResult
    public func reload() -> Self {
        tableView?.reloadData()
        removeCurrentInlineRowUpdate()
        return self
    }
    
    /// Reload sections from section indexSet.
    @discardableResult
    public func reload(sections: IndexSet, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        tableView?.reloadSections(sections, with: rowAnimation)
        return self
    }

    /// Reload sections from instance of SectionFormer.
    @discardableResult
    public func reload(sectionFormer: SectionFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        guard let section = sectionFormers.index(where: { $0 === sectionFormer }) else { return self }
      return reload(sections: IndexSet(integer: section), rowAnimation: rowAnimation)
    }
    
    /// Reload rows from indesPaths.
    @discardableResult
    public func reload(indexPaths: [IndexPath], rowAnimation: UITableViewRowAnimation = .none) -> Self {
        tableView?.reloadRows(at: indexPaths, with: rowAnimation)
        return self
    }
    
    /// Reload rows from instance of RowFormer.
    @discardableResult
    public func reload(rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        for (section, sectionFormer) in sectionFormers.enumerated() {
            if let row = sectionFormer.rowFormers.index(where: { $0 === rowFormer}) {
                return reload(indexPaths: [IndexPath(row: row, section: section)], rowAnimation: rowAnimation)
            }
        }
        return self
    }
    
    /// Append SectionFormer to last index.
    @discardableResult
    public func append(sectionFormer: SectionFormer...) -> Self {
        return add(sectionFormers: sectionFormer)
    }
    
    /// Add SectionFormers to last index.
    @discardableResult
    public func add(sectionFormers: [SectionFormer]) -> Self {
        self.sectionFormers += sectionFormers
        return self
    }
    
    /// Insert SectionFormer to index of section with NO updates.
    @discardableResult
    public func insert(sectionFormer: SectionFormer..., toSection: Int) -> Self {
        return insert(sectionFormers: sectionFormer, toSection: toSection)
    }
    
    /// Insert SectionFormers to index of section with NO updates.
    @discardableResult
    public func insert(sectionFormers: [SectionFormer], toSection: Int) -> Self {
        let count = self.sectionFormers.count
        if count == 0 ||  toSection >= count {
            add(sectionFormers: sectionFormers)
            return self
        } else if toSection >= count {
            self.sectionFormers.insert(contentsOf: sectionFormers, at: 0)
            return self
        }
        self.sectionFormers.insert(contentsOf: sectionFormers, at: toSection)
        return self
    }
    
    /// Insert SectionFormer to above other SectionFormer with NO updates.
    @discardableResult
    public func insert(sectionFormer: SectionFormer..., above: SectionFormer) -> Self {
        return insert(sectionFormers: sectionFormer, above: above)
    }
    
    /// Insert SectionFormers to above other SectionFormer with NO updates.
    @discardableResult
    public func insert(sectionFormers: [SectionFormer], above: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormer === above {
                return insert(sectionFormers: sectionFormers, toSection: section - 1)
            }
        }
        return add(sectionFormers: sectionFormers)
    }
    
    /// Insert SectionFormer to below other SectionFormer with NO updates.
    @discardableResult
    public func insert(sectionFormer: SectionFormer..., below: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormer === below {
                return insert(sectionFormers: sectionFormers, toSection: section + 1)
            }
        }
        add(sectionFormers: sectionFormers)
        return insert(sectionFormers: sectionFormer, below: below)
    }
    
    /// Insert SectionFormers to below other SectionFormer with NO updates.
    @discardableResult
    public func insert(sectionFormers: [SectionFormer], below: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormer === below {
                return insert(sectionFormers: sectionFormers, toSection: section + 1)
            }
        }
        return add(sectionFormers: sectionFormers)
    }
    
    /// Insert SectionFormer to index of section with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormer: SectionFormer..., toSection: Int, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, toSection: toSection, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to index of section with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormers: [SectionFormer], toSection: Int, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        guard !sectionFormers.isEmpty else { return self }
        removeCurrentInlineRowUpdate()
        tableView?.beginUpdates()
        insert(sectionFormers: sectionFormers, toSection: toSection)
        tableView?.insertSections(IndexSet(integer: toSection), with: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert SectionFormer to above other SectionFormer with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormer: SectionFormer..., above: SectionFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, above: above, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to above other SectionFormer with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormers: [SectionFormer], above: SectionFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormer === above {
                let indexSet = IndexSet(integersIn: section..<(section + sectionFormers.count))
                tableView?.beginUpdates()
                insert(sectionFormers: sectionFormers, toSection: section)
                tableView?.insertSections(indexSet, with: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        return self
    }
    
    /// Insert SectionFormer to below other SectionFormer with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormer: SectionFormer..., below: SectionFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(sectionFormers: sectionFormer, below: below, rowAnimation: rowAnimation)
    }
    
    /// Insert SectionFormers to below other SectionFormer with animated updates.
    @discardableResult
    public func insertUpdate(sectionFormers: [SectionFormer], below: SectionFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormer === below {
                let indexSet = IndexSet(integersIn: (section + 1)..<(section + 1 + sectionFormers.count))
                tableView?.beginUpdates()
                insert(sectionFormers: sectionFormers, toSection: section + 1)
                tableView?.insertSections(indexSet, with: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        return self
    }
    
    /// Insert RowFormer with NO updates.
    @discardableResult
    public func insert(rowFormer: RowFormer..., toIndexPath: IndexPath) -> Self {
        return insert(rowFormers: rowFormer, toIndexPath: toIndexPath)
    }
    
    /// Insert RowFormers with NO updates.
    @discardableResult
    public func insert(rowFormers: [RowFormer], toIndexPath: IndexPath) -> Self {
        self[toIndexPath.section].insert(rowFormers: rowFormers, toIndex: toIndexPath.row)
        return self
    }
    
    /// Insert RowFormer to above other RowFormer with NO updates.
    @discardableResult
    public func insert(rowFormer: RowFormer..., above: RowFormer) -> Self {
        return insert(rowFormers: rowFormer, above: above)
    }
    
    /// Insert RowFormers to above other RowFormer with NO updates.
    @discardableResult
    public func insert(rowFormers: [RowFormer], above: RowFormer) -> Self {
        guard !rowFormers.isEmpty else { return self }
        for sectionFormer in self.sectionFormers {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerated() {
                if rowFormer === above {
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row)
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormers to below other RowFormer with NO updates.
    @discardableResult
    public func insert(rowFormer: RowFormer..., below: RowFormer) -> Self {
        return insert(rowFormers: rowFormer, below: below)
    }
    
    /// Insert RowFormers to below other RowFormer with NO updates.
    @discardableResult
    public func insert(rowFormers: [RowFormer], below: RowFormer) -> Self {
        guard !rowFormers.isEmpty else { return self }
        for sectionFormer in self.sectionFormers {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerated() {
                if rowFormer === below {
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row + 1)
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormer with animated updates.
    @discardableResult
    public func insertUpdate(rowFormer: RowFormer..., toIndexPath: IndexPath, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(rowFormers: rowFormer, toIndexPath: toIndexPath, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers with animated updates.
    @discardableResult
    public func insertUpdate(rowFormers: [RowFormer], toIndexPath: IndexPath, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        insert(rowFormers: rowFormers, toIndexPath: toIndexPath)
        let insertIndexPaths = (0..<rowFormers.count).map {
            IndexPath(row: toIndexPath.row + $0, section: toIndexPath.section)
        }
        tableView?.insertRows(at: insertIndexPaths, with: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert RowFormer to above other RowFormer with animated updates.
    @discardableResult
    public func insertUpdate(rowFormer: RowFormer..., above: RowFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(rowFormers: rowFormer, above: above, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers to above other RowFormer with animated updates.
    @discardableResult
    public func insertUpdate(rowFormers: [RowFormer], above: RowFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerated() {
                if rowFormer === above {
                    let indexPaths = (row..<row + rowFormers.count).map {
                        IndexPath(row: $0, section: section)
                    }
                    tableView?.beginUpdates()
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row)
                    tableView?.insertRows(at: indexPaths, with: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        return self
    }
    
    /// Insert RowFormer to below other RowFormer with animated updates.
    @discardableResult
    public func insertUpdate(rowFormer: RowFormer..., below: RowFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return insertUpdate(rowFormers: rowFormer, below: below, rowAnimation: rowAnimation)
    }
    
    /// Insert RowFormers to below other RowFormer with animated updates.
    @discardableResult
    public func insertUpdate(rowFormers: [RowFormer], below: RowFormer, rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerated() {
                if rowFormer === below {
                    let indexPaths = (row + 1..<row + 1 + rowFormers.count).map {
                        IndexPath(row: $0, section: section)
                    }
                    tableView?.beginUpdates()
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row + 1)
                    tableView?.insertRows(at: indexPaths, with: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove All SectionFormers with NO updates.
    @discardableResult
    public func removeAll() -> Self {
        sectionFormers = []
        return self
    }
    
    /// Remove All SectionFormers with animated updates.
    @discardableResult
    public func removeAllUpdate(rowAnimation: UITableViewRowAnimation = .none) -> Self {
        let indexSet = IndexSet(integersIn: 0..<sectionFormers.count)
        sectionFormers = []
        guard indexSet.count > 0 else { return self }
        tableView?.beginUpdates()
        tableView?.deleteSections(indexSet, with: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Remove SectionFormers from section index with NO updates.
    @discardableResult
    public func remove(section: Int) -> Self {
        sectionFormers.remove(at: section)
        return self
    }
    
    /// Remove SectionFormers from instances of SectionFormer with NO updates.
    @discardableResult
    public func remove(sectionFormer: SectionFormer...) -> Self {
        return remove(sectionFormers: sectionFormer)
    }
    
    /// Remove SectionFormers from instances of SectionFormer with NO updates.
    @discardableResult
    public func remove(sectionFormers: [SectionFormer]) -> Self {
        _ = removeSectionFormers(sectionFormers)
        return self
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    @discardableResult
    public func removeUpdate(sectionFormer: SectionFormer..., rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return removeUpdate(sectionFormers: sectionFormer, rowAnimation: rowAnimation)
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    @discardableResult
    public func removeUpdate(sectionFormers: [SectionFormer], rowAnimation: UITableViewRowAnimation = .none) -> Self {
        guard !sectionFormers.isEmpty else { return self }
        let indexSet = removeSectionFormers(sectionFormers)
        guard indexSet.count > 0 else { return self }
        tableView?.beginUpdates()
        tableView?.deleteSections(indexSet, with: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Remove RowFormer with NO updates.
    @discardableResult
    public func remove(rowFormer: RowFormer...) -> Self {
        return remove(rowFormers: rowFormer)
    }
    
    /// Remove RowFormers with NO updates.
    @discardableResult
    public func remove(rowFormers: [RowFormer]) -> Self {
        _ = removeRowFormers(rowFormers)
        return self
    }
    
    /// Remove RowFormers with animated updates.
    @discardableResult
    public func removeUpdate(rowFormer: RowFormer..., rowAnimation: UITableViewRowAnimation = .none) -> Self {
        return removeUpdate(rowFormers: rowFormer, rowAnimation: rowAnimation)
    }
    
    /// Remove RowFormers with animated updates.
    @discardableResult
    public func removeUpdate(rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .none) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        let oldIndexPaths = removeRowFormers(rowFormers)
        tableView?.deleteRows(at: oldIndexPaths, with: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    // MARK: Private
    
    fileprivate var onCellSelected: ((IndexPath) -> Void)?
    fileprivate var onScroll: ((UIScrollView) -> Void)?
    fileprivate var onBeginDragging: ((UIScrollView) -> Void)?
    fileprivate var willDeselectCell: ((IndexPath) -> IndexPath?)?
    fileprivate var willDisplayCell: ((IndexPath) -> Void)?
    fileprivate var willDisplayHeader: ((Int) -> Void)?
    fileprivate var willDisplayFooter: ((Int) -> Void)?
    fileprivate var didDeselectCell: ((IndexPath) -> Void)?
    fileprivate var didEndDisplayingCell: ((IndexPath) -> Void)?
    fileprivate var didEndDisplayingHeader: ((Int) -> Void)?
    fileprivate var didEndDisplayingFooter: ((Int) -> Void)?
    fileprivate var didHighlightCell: ((IndexPath) -> Void)?
    fileprivate var didUnHighlightCell: ((IndexPath) -> Void)?
    
    fileprivate weak var tableView: UITableView?
    fileprivate weak var inlineRowFormer: RowFormer?
    fileprivate weak var selectorRowFormer: RowFormer?
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate var oldBottomContentInset: CGFloat?
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(Former.keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Former.keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeCurrentInlineRow() -> IndexPath? {
        var indexPath: IndexPath? = nil
        if let oldInlineRowFormer = (inlineRowFormer as? InlineForm)?.inlineRowFormer,
            let removedIndexPath = removeRowFormers([oldInlineRowFormer]).first {
                indexPath = removedIndexPath
                (inlineRowFormer as? InlineForm)?.editingDidEnd()
                inlineRowFormer = nil
        }
        return indexPath
    }
    
    fileprivate func removeCurrentInlineRowUpdate() {
        if let removedIndexPath = removeCurrentInlineRow() {
            tableView?.beginUpdates()
            tableView?.deleteRows(at: [removedIndexPath], with: .middle)
            tableView?.endUpdates()
        }
    }
    
    fileprivate func removeSectionFormers(_ sectionFormers: [SectionFormer]) -> IndexSet {
        var removedCount = 0
        var indexSet = IndexSet()
        for (section, sectionFormer) in self.sectionFormers.enumerated() {
            if sectionFormers.contains(where: { $0 === sectionFormer}) {
                indexSet.insert(section)
                remove(section: section)
                removedCount += 1
                if removedCount >= sectionFormers.count {
                    return indexSet
                }
            }
        }
        return indexSet
    }
    
    fileprivate func removeRowFormers(_ rowFormers: [RowFormer]) -> [IndexPath] {
        var removedCount = 0
        var removeIndexPaths = [IndexPath]()
        for (section, sectionFormer) in sectionFormers.enumerated() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerated() {
                if rowFormers.contains(where: { $0 === rowFormer }) {
                    removeIndexPaths.append(IndexPath(row: row, section: section))
                    sectionFormer.remove(rowFormers: [rowFormer])
                    if let oldInlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer {
                        removeIndexPaths.append(IndexPath(row: row + 1, section: section))
                        _ = removeRowFormers([oldInlineRowFormer])
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
    
    private func findFirstResponder(_ view: UIView?) -> UIView? {
        if view?.isFirstResponder ?? false {
            return view
        }
        for subView in view?.subviews ?? [] {
            if let firstResponder = findFirstResponder(subView) {
                return firstResponder
            }
        }
        return nil
    }
    
    private func findCellWithSubView(_ view: UIView?) -> UITableViewCell? {
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
            
            let frame = (keyboardInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
            let keyboardFrame = tableView.window!.convert(frame!, to: tableView.superview!)
            let bottomInset = tableView.frame.minY + tableView.frame.height - keyboardFrame.minY
            guard bottomInset > 0 else { return }
            
            if oldBottomContentInset == nil {
                oldBottomContentInset = tableView.contentInset.bottom
            }
            let duration = (keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue!
            let curve = (keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).integerValue!
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            tableView.contentInset.bottom = bottomInset
            tableView.scrollIndicatorInsets.bottom = bottomInset
            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
            UIView.commitAnimations()
        }
    }
    
    private dynamic func keyboardWillDisappear(notification: NSNotification) {
        guard let keyboardInfo = notification.userInfo else { return }
        
        if case let (tableView?, inset?) = (tableView, oldBottomContentInset) {
            let duration = (keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue!
            let curve = (keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).integerValue!

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
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endEditing()
        onBeginDragging?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll?(scrollView)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return willDeselectCell?(indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeader?(section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooter?(section)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectCell?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayingCell?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeader?(section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooter?(section)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightCell?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnHighlightCell?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        endEditing()
        deselect(animated: false)
        selectedIndexPath = indexPath
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowFormer = self.rowFormer(indexPath: indexPath)
        guard rowFormer.enabled else { return }

        rowFormer.cellSelected(indexPath: indexPath)
        onCellSelected?(indexPath)
        
        // InlineRow
        if let oldInlineRowFormer = (inlineRowFormer as? InlineForm)?.inlineRowFormer {
            if let currentInlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer,
                rowFormer !== inlineRowFormer {
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = removeRowFormers([oldInlineRowFormer]).first {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : IndexPath(row: indexPath.row + 1, section: indexPath.section)
                        insert(rowFormers: [currentInlineRowFormer], toIndexPath: insertIndexPath)
                        self.tableView?.deleteRows(at: [removedIndexPath], with: .middle)
                        self.tableView?.insertRows(at: [insertIndexPath], with: .middle)
                    }
                    self.tableView?.endUpdates()
                    (inlineRowFormer as? InlineForm)?.editingDidEnd()
                    (rowFormer as? InlineForm)?.editingDidBegin()
                    inlineRowFormer = rowFormer
            } else {
                removeCurrentInlineRowUpdate()
            }
        } else if let inlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer {
            let inlineIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            insertUpdate(rowFormers: [inlineRowFormer], toIndexPath: inlineIndexPath, rowAnimation: .middle)
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
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // for Cell
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].numberOfRows
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowFormer = self.rowFormer(indexPath: indexPath)
        if let dynamicRowHeight = rowFormer.dynamicRowHeight {
            rowFormer.rowHeight = dynamicRowHeight(tableView, indexPath)
        }
        return rowFormer.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowFormer = self.rowFormer(indexPath: indexPath)
        if let dynamicRowHeight = rowFormer.dynamicRowHeight {
            rowFormer.rowHeight = dynamicRowHeight(tableView, indexPath)
        }
        return rowFormer.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowFormer = self.rowFormer(indexPath: indexPath)
        if rowFormer.former == nil { rowFormer.former = self }
        rowFormer.update()
        return rowFormer.cellInstance
    }
    
    // for HeaderFooterView

    // Not implemented for iOS8 estimatedHeight bug
//    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        let headerViewFormer = self[section].headerViewFormer
//        if let dynamicViewHeight = headerViewFormer?.dynamicViewHeight {
//            headerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
//        }
//        return headerViewFormer?.viewHeight ?? 0
//    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerViewFormer = self[section].headerViewFormer
        if let dynamicViewHeight = headerViewFormer?.dynamicViewHeight {
            headerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
        }
        return headerViewFormer?.viewHeight ?? 0
    }
    
    // Not implemented for iOS8 estimatedHeight bug
//    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        let footerViewFormer = self[section].footerViewFormer
//        if let dynamicViewHeight = footerViewFormer?.dynamicViewHeight {
//            footerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
//        }
//        return footerViewFormer?.viewHeight ?? 0
//    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerViewFormer = self[section].footerViewFormer
        if let dynamicViewHeight = footerViewFormer?.dynamicViewHeight {
            footerViewFormer?.viewHeight = dynamicViewHeight(tableView, section)
        }
        return footerViewFormer?.viewHeight ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewFormer = self[section].headerViewFormer else { return nil }
        viewFormer.update()
        return viewFormer.viewInstance
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewFormer = self[section].footerViewFormer else { return nil }
        viewFormer.update()
        return viewFormer.viewInstance
    }
}
