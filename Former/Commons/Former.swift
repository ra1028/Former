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
    RegisterType is type of registering Cell or HeaderFooterView.
    Choose 'RegisterType.Nib(nibName: String, bundle: NSBundle?)' if Cell or HeaderFooterView is instantiate from xib.
    Or if without xib, choose 'RegisterType.Class'.
    **/
    public enum RegisterType {
        
        case Class
        case Nib(nibName: String, bundle: NSBundle?)
    }
    
    /// All SectionFormers. Default is empty.
    public private(set) var sectionFormers = [SectionFormer]()
    
    /// Return all RowFormers. Compute each time of called.
    public var rowFormers: [RowFormer] {
        
        return self.sectionFormers.flatMap { $0.rowFormers }
    }
    
    /// Number of all sections.
    public var numberOfSections: Int {
        
        return self.sectionFormers.count
    }
    
    /// Number of all rows.
    public var numberOfRows: Int {
        
        return self.rowFormers.count
    }
    
    /// Call when cell has selected.
    public var onCellSelected: ((indexPath: NSIndexPath) -> Void)?
    
    /// Call when tableView has scrolled.
    public var onScroll: ((scrollView: UIScrollView) -> Void)?
    
    /// Call when tableView had begin dragging.
    public var onBeginDragging: ((scrollView: UIScrollView) -> Void)?
    
    /// If set 'true', automatically register cell and headerFooterView.
    public var autoRegisterEnabled = true
    
    public init(tableView: UITableView) {
        
        super.init()
        self.tableView = tableView
        self.setupTableView()
    }
    
    deinit {
        self.tableView?.delegate = nil
        self.tableView?.dataSource = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public subscript(index: Int) -> SectionFormer {
        
        return self.sectionFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [SectionFormer] {
        
        return Array<SectionFormer>(self.sectionFormers[range])
    }
    
    /// To register Cell from class. Use if you set 'false' to autoRegisterEnabled.
    public func register(cellType type: UITableViewCell.Type, registerType: RegisterType) -> Self {
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: type.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(type, forCellReuseIdentifier: type.reuseIdentifier)
        }
        return self
    }
    
    /// To register HeaderFooterView from class. Use if you set 'false' to autoRegisterEnabled.
    public func register(viewType type: UITableViewHeaderFooterView.Type, registerType: RegisterType) -> Self {
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
        }
        return self
    }
    
    /// To register Cell from RowFormer. Use if you set 'false' to autoRegisterEnabled.
    public func register(rowFormer rowFormer: RowFormer) -> Self {
        
        if rowFormer.registered { return self }
        rowFormer.registered = true
        return self.register(cellType: rowFormer.cellType, registerType: rowFormer.registerType)
    }
    
    /// To register HeaderFooterView from ViewFormer. Use if you set 'false' to autoRegisterEnabled.
    public func register(viewFormer viewFormer: ViewFormer) -> Self {
        
        if viewFormer.registered { return self }
        viewFormer.registered = true
        return self.register(viewType: viewFormer.viewType, registerType: viewFormer.registerType)
    }
    
    /// To find RowFormer from indexPath.
    public func rowFormer(indexPath: NSIndexPath) -> RowFormer {
        
        return self[indexPath.section][indexPath.row]
    }
    
    /// 'true' iff can edit previous row.
    public func canBecomeEditingPrevious() -> Bool {
        
        var section = self.selectedIndexPath?.section ?? 0
        var row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row - 1 : 0
        
        guard section < self.sectionFormers.count else { return false }
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
        
        var section = self.selectedIndexPath?.section ?? 0
        var row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row + 1 : 0
        
        guard section < self.sectionFormers.count else { return false }
        if row >= self[section].rowFormers.count {
            guard ++section < self.sectionFormers.count else { return false }
            row = 0
        }
        guard row < self[section].rowFormers.count else { return false }
        
        return self[section][row].canBecomeEditing
    }
    
    /// Edit previous row iff it can.
    public func becomeEditingPrevious() -> Self {
        
        if let tableView = self.tableView where self.canBecomeEditingPrevious() {
            
            var section = self.selectedIndexPath?.section ?? 0
            var row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row - 1 : 0
            guard section < self.sectionFormers.count else { return self }
            if row < 0 {
                section--
                guard section >= 0 else { return self }
                row = self[section].rowFormers.count - 1
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            self.select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (self.rowFormer(indexPath) is InlineRow) ?
                NSIndexPath(forRow: row + 1, inSection: section) : indexPath
            tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .None, animated: false)
        }
        return self
    }
    
    /// Edit next row iff it can.
    public func becomeEditingNext() -> Self {
        
        if let tableView = self.tableView where self.canBecomeEditingNext() {
            
            var section = self.selectedIndexPath?.section ?? 0
            var row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row + 1 : 0
            guard section < self.sectionFormers.count else { return self }
            if row >= self[section].rowFormers.count {
                guard ++section < self.sectionFormers.count else { return self }
                row = 0
            }
            guard row < self[section].rowFormers.count else { return self }
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            self.select(indexPath: indexPath, animated: false)
            
            let scrollIndexPath = (self.rowFormer(indexPath) is InlineRow) ?
                NSIndexPath(forRow: row + 1, inSection: section) : indexPath
            tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .None, animated: false)
        }
        return self
    }
    
    /// To end editing of tableView.
    public func endEditing() -> Self {
        
        self.tableView?.endEditing(true)
        return self
    }
    
    /// Validate RowFormer
    public func validate(rowFormer rowFormer: RowFormer) -> Bool {
        
        if let validatable = rowFormer as? FormerValidatable {
            
            return validatable.validate()
        }
        return true
    }
    
    /// Validate RowFormer from indexPath
    public func validate(indexPath indexPath: NSIndexPath) -> Bool {
        
        guard indexPath.section < self.numberOfSections else { return true }
        guard indexPath.row < self.sectionFormers[indexPath.section].numberOfRows else { return true }
        
        if let validatable = self[indexPath.section][indexPath.row] as? FormerValidatable {
            
            return validatable.validate()
        }
        return true
    }
    
    /// Validate all RowFormers. Return 'false' RowFormers. So, return empty array iff all 'true'.
    public func validateAll() -> [RowFormer] {
        
        var invalidRowFormers = [RowFormer]()
        self.rowFormers.forEach {
            if let validatable = $0 as? FormerValidatable where !validatable.validate() {
                invalidRowFormers.append($0)
            }
        }
        return invalidRowFormers
    }
    
    /// To select row from indexPath.
    public func select(indexPath indexPath: NSIndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        
        if let tableView = self.tableView {
            tableView.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
            self.tableView(tableView, willSelectRowAtIndexPath: indexPath)
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
        return self
    }
    
    /// To select row from instance of RowFormer.
    public func select(rowFormer rowFormer: RowFormer, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if let row = sectionFormer.rowFormers.indexOf(rowFormer) {
                return self.select(indexPath: NSIndexPath(forRow: row, inSection: section), animated: animated, scrollPosition: scrollPosition)
            }
        }
        return self
    }
    
    /// To deselect current selecting cell.
    public func deselect(animated: Bool) -> Self {
        
        if let indexPath = self.selectedIndexPath {
            self.tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        return self
    }
    
    /// Reload All cells.
    public func reloadFormer() -> Self {
        
        self.tableView?.reloadData()
        self.removeCurrentInlineRowAndUpdate()
        return self
    }
    
    /// Reload sections from section indexSet.
    public func reload(sections sections: NSIndexSet, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.tableView?.reloadSections(sections, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload sections from instance of SectionFormer.
    public func reload(sectionFormer sectionFormer: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        guard let section = self.sectionFormers.indexOf(sectionFormer) else { return self }
        return self.reload(sections: NSIndexSet(index: section), rowAnimation: rowAnimation)
    }
    
    /// Reload rows from indesPaths.
    public func reload(indexPaths indexPaths: [NSIndexPath], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload rows from instance of RowFormer.
    public func reload(rowFormer rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if let row = sectionFormer.rowFormers.indexOf(rowFormer) {
                return self.reload(indexPaths: [NSIndexPath(forRow: row, inSection: section)], rowAnimation: rowAnimation)
            }
        }
        return self
    }
    
    /// Add SectionFormers to last index.
    public func add(sectionFormers sectionFormers: [SectionFormer]) -> Self {
        
        self.sectionFormers += sectionFormers
        return self
    }
    
    /// Insert SectionFormer with NO updates.
    public func insert(sectionFormers sectionFormers: [SectionFormer], toSection: Int) -> Self {
        
        let count = self.sectionFormers.count
        
        if count == 0 ||  toSection >= count {
            self.add(sectionFormers: sectionFormers)
        } else if toSection == 0 {
            self.sectionFormers = sectionFormers + self.sectionFormers
        } else {
            let last = self.sectionFormers.count - 1
            self.sectionFormers = self.sectionFormers[0...(toSection - 1)] + sectionFormers + self.sectionFormers[toSection...last]
        }
        return self
    }
    
    /// Insert SectionFormers with animated updates.
    public func insertAndUpdate(sectionFormers sectionFormers: [SectionFormer], toSection: Int, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.removeCurrentInlineRowAndUpdate()
        
        self.tableView?.beginUpdates()
        self.insert(sectionFormers: sectionFormers, toSection: toSection)
        self.tableView?.insertSections(NSIndexSet(index: toSection), withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    /// Insert RowFormers with NO updates.
    public func insert(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath) -> Self {
        
        self[toIndexPath.section].insert(rowFormers: rowFormers, toIndex: toIndexPath.row)
        return self
    }
    
    /// Insert RowFormers with animated updates.
    public func insertAndUpdate(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.removeCurrentInlineRowAndUpdate()
        
        self.tableView?.beginUpdates()
        
        self.insert(rowFormers: rowFormers, toIndexPath: toIndexPath)
        let insertIndexPaths = (0..<rowFormers.count).map {
            NSIndexPath(forRow: toIndexPath.row + $0, inSection: toIndexPath.section)
        }
        self.tableView?.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    /// Remove All SectionFormers with NO updates.
    public func removeAll() -> Self {
        
        self.sectionFormers = []
        return self
    }
    
    /// Remove All SectionFormers with animated updates.
    public func removeAllAndUpdate(rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        let indexSet = NSIndexSet(indexesInRange: NSMakeRange(0, self.sectionFormers.count))
        self.sectionFormers = []
        guard indexSet.count > 0 else { return self }
        
        self.tableView?.beginUpdates()
        self.tableView?.deleteSections(indexSet, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    /// Remove SectionFormers from section index with NO updates.
    public func remove(section section: Int) -> Self {
        
        self.sectionFormers.removeAtIndex(section)
        return self
    }
    
    /// Remove SectionFormers from instances of SectionFormer with NO updates.
    public func remove(sectionFormers sectionFormers: [SectionFormer]) -> NSIndexSet {
        
        var removedCount = 0
        let indexSet = NSMutableIndexSet()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormers.contains(sectionFormer) {
                indexSet.addIndex(section)
                self.remove(section: section)
                
                if ++removedCount >= sectionFormers.count {
                    return indexSet
                }
            }
        }
        return indexSet
    }
    
    /// Remove SectionFormers from instances of SectionFormer with animated updates.
    public func removeAndUpdate(sectionFormers sectionFormers: [SectionFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        let indexSet = self.remove(sectionFormers: sectionFormers)
        guard indexSet.count > 0 else { return self }
        
        self.tableView?.beginUpdates()
        self.tableView?.deleteSections(indexSet, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    /// Remove RowFormers with NO updates.
    public func remove(rowFormers rowFormers: [RowFormer]) -> [NSIndexPath] {
        
        var removedCount = 0
        var removeIndexPaths = [NSIndexPath]()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                
                if rowFormers.contains(rowFormer) {
                    removeIndexPaths.append(NSIndexPath(forRow: row, inSection: section))
                    sectionFormer.remove(rowFormers: [rowFormer])
                    
                    if let oldInlineRowFormer = (rowFormer as? InlineRow)?.inlineRowFormer {
                        removeIndexPaths.append(NSIndexPath(forRow: row + 1, inSection: section))
                        self.remove(rowFormers: [oldInlineRowFormer])
                        (self.inlineRowFormer as? InlineRow)?.editingDidEnd()
                        self.inlineRowFormer = nil
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
    public func removeAndUpdate(rowFormers rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.removeCurrentInlineRowAndUpdate()
        
        self.tableView?.beginUpdates()
        let oldIndexPaths = self.remove(rowFormers: rowFormers)
        self.tableView?.deleteRowsAtIndexPaths(oldIndexPaths, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    // MARK: Private
    
    private weak var tableView: UITableView?
    private weak var inlineRowFormer: RowFormer?
    private var selectedIndexPath: NSIndexPath?
    private var oldBottomContentInset: CGFloat?
    
    private func setupTableView() {
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeCurrentInlineRow() -> NSIndexPath? {
        
        var indexPath: NSIndexPath? = nil
        if let oldInlineRowFormer = (self.inlineRowFormer as? InlineRow)?.inlineRowFormer,
            let removedIndexPath = self.remove(rowFormers: [oldInlineRowFormer]).first {
            
                indexPath = removedIndexPath
                (self.inlineRowFormer as? InlineRow)?.editingDidEnd()
                self.inlineRowFormer = nil
        }
        return indexPath
    }
    
    private func removeCurrentInlineRowAndUpdate() {
        
        if let removedIndexPath = self.removeCurrentInlineRow() {
            
            self.tableView?.beginUpdates()
            self.tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
            self.tableView?.endUpdates()
        }
    }
    
    private func findFirstResponder(view: UIView?) -> UIView? {
        
        if view?.isFirstResponder() ?? false {
            return view
        }
        for subView in view?.subviews ?? [] {
            if let firstResponder = self.findFirstResponder(subView) {
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
            return self.findCellWithSubView(view.superview)
        }
        return nil
    }
    
    private dynamic func keyboardWillAppear(notification: NSNotification) {
        
        guard let keyboardInfo = notification.userInfo else { return }
        
        if case let (tableView?, cell?) = (self.tableView, self.findCellWithSubView(self.findFirstResponder(self.tableView))) {
            
            let frame = keyboardInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let keyboardFrame = tableView.window!.convertRect(frame, toView: tableView.superview!)
            let bottomInset = CGRectGetMinY(tableView.frame) + CGRectGetHeight(tableView.frame) - CGRectGetMinY(keyboardFrame)
            guard bottomInset > 0 else { return }
            
            self.oldBottomContentInset ?= tableView.contentInset.bottom
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
        
        if case let (tableView?, inset?) = (self.tableView, self.oldBottomContentInset) {
            
            let duration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue!
            let curve = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]!.integerValue
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            tableView.contentInset.bottom = inset
            tableView.scrollIndicatorInsets.bottom = inset
            UIView.commitAnimations()
            self.oldBottomContentInset = nil
        }
    }
}

extension Former: UITableViewDelegate, UITableViewDataSource {
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.endEditing()
        self.onBeginDragging?(scrollView: scrollView)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.onScroll?(scrollView: scrollView)
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.endEditing()
        self.deselect(false)
        self.selectedIndexPath = indexPath
        return indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowFormer = self.rowFormer(indexPath)
        guard rowFormer.enabled else { return }
        
        rowFormer.cellSelected(indexPath)
        self.onCellSelected?(indexPath: indexPath)
        
        if let oldInlineRowFormer = (self.inlineRowFormer as? InlineRow)?.inlineRowFormer {
            
            if let currentInlineRowFormer = (rowFormer as? InlineRow)?.inlineRowFormer
                where rowFormer !== self.inlineRowFormer {
                    
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = self.remove(rowFormers: [oldInlineRowFormer]).first {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        self.insert(rowFormers: [currentInlineRowFormer], toIndexPath: insertIndexPath)
                        self.tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
                        self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Middle)
                    }
                    self.tableView?.endUpdates()
                    (self.inlineRowFormer as? InlineRow)?.editingDidEnd()
                    (rowFormer as? InlineRow)?.editingDidBegin()
                    self.inlineRowFormer = rowFormer
            } else {
                
                self.removeCurrentInlineRowAndUpdate()
            }
        } else if let inlineRowFormer = (rowFormer as? InlineRow)?.inlineRowFormer {
            
            let inlineIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            self.insertAndUpdate(rowFormers: [inlineRowFormer], toIndexPath: inlineIndexPath, rowAnimation: .Middle)
            (rowFormer as? InlineRow)?.editingDidBegin()
            self.inlineRowFormer = rowFormer
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
        
        return self.numberOfSections
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self[section].numberOfRows
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.rowFormer(indexPath).cellHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let rowFormer = self.rowFormer(indexPath)
        if self.autoRegisterEnabled { self.register(rowFormer: rowFormer) }
        let cellType = rowFormer.cellType
        let cell = tableView.dequeueReusableCellWithIdentifier(
            cellType.reuseIdentifier,
            forIndexPath: indexPath
        )
        if let formableRow = cell as? FormableRow {
            formableRow.configureWithRowFormer(rowFormer)
        }
        rowFormer.former ?= self
        rowFormer.cellConfigure(cell)
        return cell
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
        if self.autoRegisterEnabled { self.register(viewFormer: viewFormer) }
        let viewType = viewFormer.viewType
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(viewType.reuseIdentifier)
        if let formableHeaderView = headerView as? FormableView {
            formableHeaderView.configureWithViewFormer(viewFormer)
        }
        if let headerView = headerView {
            viewFormer.viewConfigure(headerView)
        }
        return headerView
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let viewFormer = self[section].footerViewFormer else { return nil }
        if self.autoRegisterEnabled { self.register(viewFormer: viewFormer) }
        let viewType = viewFormer.viewType
        let footerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(viewType.reuseIdentifier)
        if let formableFooterView = footerView as? FormableView {
            formableFooterView.configureWithViewFormer(viewFormer)
        }
        if let footerView = footerView {
            viewFormer.viewConfigure(footerView)
        }
        return footerView
    }
}