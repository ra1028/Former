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
    Choose 'InstantiateType.Nib(nibName: String, bundle: NSBundle?)' if Cell or HeaderFooterView is instantiate from xib.
    Or if without xib, choose 'InstantiateType.Class'.
    **/
    public enum InstantiateType {
        case Class
        case Nib(nibName: String, bundle: NSBundle?)
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
    
    /// 'true' iff can edit previous row.
    public func canBecomeEditingPrevious() -> Bool {
        var section = selectedIndexPath?.section ?? 0
        var row = (selectedIndexPath != nil) ? selectedIndexPath!.row - 1 : 0
        
        guard section < sectionFormers.count else { return false }
        if row < 0 {
            section--
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
            guard ++section < sectionFormers.count else { return false }
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
                section--
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
                guard ++section < sectionFormers.count else { return self }
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
    
    /// Add SectionFormers to last index.
    public func add(sectionFormers sectionFormers: [SectionFormer]) -> Self {
        self.sectionFormers += sectionFormers
        return self
    }
    
    /// Insert SectionFormer to index of section with NO updates.
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
    public func insert(sectionFormers sectionFormers: [SectionFormer], above: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === above {
                insert(sectionFormers: sectionFormers, toSection: section - 1)
                return self
            }
        }
        add(sectionFormers: sectionFormers)
        return self
    }
    
    /// Insert SectionFormer to below other SectionFormer with NO updates.
    public func insert(sectionFormers sectionFormers: [SectionFormer], below: SectionFormer) -> Self {
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === below {
                insert(sectionFormers: sectionFormers, toSection: section + 1)
                return self
            }
        }
        add(sectionFormers: sectionFormers)
        return self
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
    
    /// Insert SectionFormers to above other SectionFormer with animated updates.
    public func insertUpdate(sectionFormers sectionFormers: [SectionFormer], above: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !sectionFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === above {
                let indexSet = NSIndexSet(indexesInRange: NSMakeRange(section, sectionFormers.count))
                insert(sectionFormers: sectionFormers, toSection: section)
                tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        let indexSet = NSIndexSet(indexesInRange: NSMakeRange(self.sectionFormers.count - 1, sectionFormers.count))
        add(sectionFormers: sectionFormers)
        tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert SectionFormers to below other SectionFormer with animated updates.
    public func insertUpdate(sectionFormers sectionFormers: [SectionFormer], below: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        tableView?.beginUpdates()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === below {
                let indexSet = NSIndexSet(indexesInRange: NSMakeRange(section + 1, sectionFormers.count))
                insert(sectionFormers: sectionFormers, toSection: section + 1)
                tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
                tableView?.endUpdates()
                return self
            }
        }
        let indexSet = NSIndexSet(indexesInRange: NSMakeRange(0, sectionFormers.count))
        insert(sectionFormers: sectionFormers, toSection: 0)
        tableView?.insertSections(indexSet, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert RowFormers with NO updates.
    public func insert(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath) -> Self {
        self[toIndexPath.section].insert(rowFormers: rowFormers, toIndex: toIndexPath.row)
        return self
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
    
    /// Insert RowFormers to above other RowFormer with animated updates.
    public func insertUpdate(rowFormers rowFormers: [RowFormer], above: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === above {
                    let indexPaths = (row..<row + rowFormers.count).map {
                        NSIndexPath(forRow: $0, inSection: section)
                    }
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row)
                    tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        let sectionFormer = SectionFormer(rowFormers: rowFormers)
        add(sectionFormers: [sectionFormer])
        tableView?.insertSections(NSIndexSet(index: self.sectionFormers.count), withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Insert RowFormers to below other RowFormer with animated updates.
    public func insertUpdate(rowFormers rowFormers: [RowFormer], below: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === below {
                    let indexPaths = (row + 1..<row + 1 + rowFormers.count).map {
                        NSIndexPath(forRow: $0, inSection: section)
                    }
                    sectionFormer.insert(rowFormers: rowFormers, toIndex: row + 1)
                    tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
                    tableView?.endUpdates()
                    return self
                }
            }
        }
        let sectionFormer = SectionFormer(rowFormers: rowFormers)
        insert(sectionFormers: [sectionFormer], toSection: 0)
        tableView?.insertSections(NSIndexSet(index: 0), withRowAnimation: rowAnimation)
        tableView?.endUpdates()
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
    public func remove(sectionFormers sectionFormers: [SectionFormer]) -> NSIndexSet {
        var removedCount = 0
        let indexSet = NSMutableIndexSet()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormers.contains({ $0 === sectionFormer}) {
                indexSet.addIndex(section)
                remove(section: section)
                if ++removedCount >= sectionFormers.count {
                    return indexSet
                }
            }
        }
        return indexSet
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    public func removeUpdate(sectionFormers sectionFormers: [SectionFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        guard !sectionFormers.isEmpty else { return self }
        let indexSet = remove(sectionFormers: sectionFormers)
        guard indexSet.count > 0 else { return self }
        tableView?.beginUpdates()
        tableView?.deleteSections(indexSet, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    /// Remove RowFormers with NO updates.
    public func remove(rowFormers rowFormers: [RowFormer]) -> [NSIndexPath] {
        var removedCount = 0
        var removeIndexPaths = [NSIndexPath]()
        for (section, sectionFormer) in sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormers.contains({ $0 === rowFormer }) {
                    removeIndexPaths.append(NSIndexPath(forRow: row, inSection: section))
                    sectionFormer.remove(rowFormers: [rowFormer])
                    if let oldInlineRowFormer = (rowFormer as? InlineForm)?.inlineRowFormer {
                        removeIndexPaths.append(NSIndexPath(forRow: row + 1, inSection: section))
                        remove(rowFormers: [oldInlineRowFormer])
                        (inlineRowFormer as? InlineForm)?.editingDidEnd()
                        inlineRowFormer = nil
                    }
                    if ++removedCount >= rowFormers.count {
                        return removeIndexPaths
                    }
                }
            }
        }
        return removeIndexPaths
    }
    
    /// Remove RowFormers with animated updates.
    public func removeUpdate(rowFormers rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        removeCurrentInlineRowUpdate()
        guard !rowFormers.isEmpty else { return self }
        tableView?.beginUpdates()
        let oldIndexPaths = remove(rowFormers: rowFormers)
        tableView?.deleteRowsAtIndexPaths(oldIndexPaths, withRowAnimation: rowAnimation)
        tableView?.endUpdates()
        return self
    }
    
    // MARK: Private
    
    private weak var tableView: UITableView?
    private var onCellSelected: ((indexPath: NSIndexPath) -> Void)?
    private var onScroll: ((scrollView: UIScrollView) -> Void)?
    private var onBeginDragging: ((scrollView: UIScrollView) -> Void)?
    private weak var inlineRowFormer: RowFormer?
    private weak var selectorRowFormer: RowFormer?
    private var selectedIndexPath: NSIndexPath?
    private var oldBottomContentInset: CGFloat?
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeCurrentInlineRow() -> NSIndexPath? {
        var indexPath: NSIndexPath? = nil
        if let oldInlineRowFormer = (inlineRowFormer as? InlineForm)?.inlineRowFormer,
            let removedIndexPath = remove(rowFormers: [oldInlineRowFormer]).first {
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
                    if let removedIndexPath = remove(rowFormers: [oldInlineRowFormer]).first {
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
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowFormer(indexPath).cellHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowFormer = self.rowFormer(indexPath)
        if rowFormer.former == nil { rowFormer.former = self }
        rowFormer.update()
        return rowFormer.cellInstance
    }
    
    // for HeaderFooterView
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self[section].headerViewFormer?.viewHeight ?? 0
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self[section].footerViewFormer?.viewHeight ?? 0
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