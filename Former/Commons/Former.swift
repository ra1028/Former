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
    
    // RegisterType is type to register Cell or HeaderFooterView.
    // Choose 'Nib(nibName: String, bundle: NSBundle?)' if Cell or HeaderFooterView is instantiate from xib.
    public enum RegisterType {
        
        case Nib(nibName: String, bundle: NSBundle?)
        case Class
    }
    
    public private(set) var sectionFormers = [SectionFormer]() // All SectionFormers. Default is empty.
    
    // Return all RowFormers. Compute each time of called.
    public var rowFormers: [RowFormer] {
        
        return self.sectionFormers.flatMap { $0.rowFormers }
    }
    
    public var numberOfSections: Int {
        
        return self.sectionFormers.count
    }
    
    public var numberOfRows: Int {
        
        return self.rowFormers.count
    }
    
    public var onCellSelected: ((indexPath: NSIndexPath) -> Void)?
    public var onScroll: ((scrollView: UIScrollView) -> Void)?
    public var onBeginDragging: ((scrollView: UIScrollView) -> Void)?
    
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
            section++
            guard section < self.sectionFormers.count else { return false }
            row = 0
        }
        guard row < self[section].rowFormers.count else { return false }
        
        return self[section][row].canBecomeEditing
    }
    
    /// Edit previous row iff it can.
    
    public func becomeEditingPrevious() -> Self {
        
        if let tableView = self.tableView where self.canBecomeEditingPrevious() {
            tableView.becomeFirstResponder()
            let section = self.selectedIndexPath?.section ?? 0
            let row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row - 1 : 0
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            self.select(indexPath: indexPath, animated: false)
            self.tableView(tableView, willSelectRowAtIndexPath: indexPath)
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
            let scrollIndexPath = (self.rowFormer(indexPath) is InlinePickableRow) ?
                NSIndexPath(forRow: row + 1, inSection: section) : indexPath
            tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .None, animated: false)
        }
        return self
    }
    
    /// Edit next row iff it can.
    
    public func becomeEditingNext() -> Self {
        
        if let tableView = self.tableView where self.canBecomeEditingNext() {
            
            let section = self.selectedIndexPath?.section ?? 0
            let row = (self.selectedIndexPath != nil) ? self.selectedIndexPath!.row + 1 : 0
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            self.select(indexPath: indexPath, animated: false)
            self.tableView(tableView, willSelectRowAtIndexPath: indexPath)
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
            let scrollIndexPath = (self.rowFormer(indexPath) is InlinePickableRow) ?
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
    
    /// To select row from indexPath.
    
    public func select(indexPath indexPath: NSIndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        
        self.tableView?.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
        return self
    }
    
    /// To select row from rowFormer.
    
    public func select(rowFormer rowFormer: RowFormer, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) -> Self {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, oldRowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === oldRowFormer {
                    return self.select(indexPath: NSIndexPath(forRow: row, inSection: section), animated: animated, scrollPosition: scrollPosition)
                }
            }
        }
        return self
    }
    
    /// To deselect current selecting cell.
    
    public func deselect(animated: Bool) -> Self {
        
        if let indexPath = self.selectedIndexPath {
            self.tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        self.selectedIndexPath = nil
        return self
    }
    
    /// Reload All cells.
    
    public func reloadFormer() -> Self {
        
        self.tableView?.reloadData()
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            
            self.removeAndUpdate(rowFormers: [oldPickerRowFormer], rowAnimation: .Middle)
            (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
            self.inlinePickerRowFormer = nil
        }
        return self
    }
    
    /// Reload sections from section indexSet.
    
    public func reload(sections sections: NSIndexSet, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.tableView?.reloadSections(sections, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload sections from SectionFormer.
    
    public func reload(sectionFormer sectionFormer: SectionFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        for (section, oldSectionFormer) in self.sectionFormers.enumerate() {
            if sectionFormer === oldSectionFormer {
                return self.reload(sections: NSIndexSet(index: section), rowAnimation: rowAnimation)
            }
        }
        return self
    }
    
    /// Reload rows from indesPaths.
    
    public func reload(indexPaths indexPaths: [NSIndexPath], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        return self
    }
    
    /// Reload rows from rowFormer.
    
    public func reload(rowFormer rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, oldRowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === oldRowFormer {
                    return self.reload(indexPaths: [NSIndexPath(forRow: row, inSection: section)], rowAnimation: rowAnimation)
                }
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
        
        self.tableView?.beginUpdates()
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            let removedIndexPaths = self.remove(rowFormers: [oldPickerRowFormer])
            self.tableView?.deleteRowsAtIndexPaths(removedIndexPaths, withRowAnimation: .Middle)
            (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
            self.inlinePickerRowFormer = nil
        }
        
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
        
        self.tableView?.beginUpdates()
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            let removedIndexPaths = self.remove(rowFormers: [oldPickerRowFormer])
            self.tableView?.deleteRowsAtIndexPaths(removedIndexPaths, withRowAnimation: .Middle)
            (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
            self.inlinePickerRowFormer = nil
        }
        
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
    
    /// Remove SectionFormers from sectionFormers with NO updates.
    
    public func remove(sectionFormers sectionFormers: [SectionFormer]) -> NSIndexSet {
        
        let indexSet = NSMutableIndexSet()
        self.sectionFormers.enumerate().forEach {
            if sectionFormers.contains($1) {
                indexSet.addIndex($0)
                self.remove(section: $0)
            }
        }
        return indexSet
    }
    
    /// Remove SectionFormers from sectionFormers with animated updates.
    
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
        
        var removeIndexPaths = [NSIndexPath]()
        self.sectionFormers.enumerate().forEach { section, sectionFormer in
            sectionFormer.rowFormers.enumerate().forEach { row, rowFormer in
                
                if rowFormers.contains(rowFormer) {
                    removeIndexPaths += [NSIndexPath(forRow: row, inSection: section)]
                    sectionFormer.remove(rowFormers: [rowFormer])
                    
                    if let oldPickerRowFormer = (rowFormer as? InlinePickableRow)?.pickerRowFormer {
                        removeIndexPaths += [NSIndexPath(forRow: row + 1, inSection: section)]
                        self.remove(rowFormers: [oldPickerRowFormer])
                        (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
                        self.inlinePickerRowFormer = nil
                    }
                }
            }
        }
        return removeIndexPaths
    }
    
    /// Remove RowFormers with animated updates.
    
    public func removeAndUpdate(rowFormers rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .None) -> Self {
        
        self.tableView?.beginUpdates()
        var oldIndexPaths = self.remove(rowFormers: rowFormers)
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            oldIndexPaths += self.remove(rowFormers: [oldPickerRowFormer])
            (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
            self.inlinePickerRowFormer = nil
        }
        self.tableView?.deleteRowsAtIndexPaths(oldIndexPaths, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
        return self
    }
    
    // MARK: Private
    
    private weak var tableView: UITableView?
    private weak var inlinePickerRowFormer: RowFormer?
    private var selectedIndexPath: NSIndexPath?
    private var oldBottomContentInset: CGFloat?
    private var contentInsetAdjusted = false
    
    private func setupTableView() {
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
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
        
        if case let (tableView?, cell?) = (self.tableView, self.findCellWithSubView(self.findFirstResponder(self.tableView))) where !self.contentInsetAdjusted {
            
            let frame = keyboardInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let keyboardFrame = tableView.window!.convertRect(frame, toView: tableView.superview!)
            let bottomInset = CGRectGetMinY(tableView.frame) + CGRectGetHeight(tableView.frame) - CGRectGetMinY(keyboardFrame)
            guard bottomInset > 0 else { return }
            
            self.oldBottomContentInset = tableView.contentInset.bottom
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
            self.contentInsetAdjusted = true
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
            self.contentInsetAdjusted = false
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
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            
            if let currentPickerRowFormer = (rowFormer as? InlinePickableRow)?.pickerRowFormer
                where rowFormer !== self.inlinePickerRowFormer {
                    
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = self.remove(rowFormers: [oldPickerRowFormer]).first {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        self.insert(rowFormers: [currentPickerRowFormer], toIndexPath: insertIndexPath)
                        self.tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
                        self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Middle)
                    }
                    self.tableView?.endUpdates()
                    (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
                    (rowFormer as? InlinePickableRow)?.editingDidBegin()
                    self.inlinePickerRowFormer = rowFormer
            } else {
                self.removeAndUpdate(rowFormers: [oldPickerRowFormer], rowAnimation: .Middle)
                (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
                self.inlinePickerRowFormer = nil
            }
        } else if let inlinePickerRowFormer = rowFormer as? InlinePickableRow {
            
            let pickerRowFormer = inlinePickerRowFormer.pickerRowFormer
            let pickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            self.insertAndUpdate(rowFormers: [pickerRowFormer], toIndexPath: pickerIndexPath, rowAnimation: .Middle)
            (rowFormer as? InlinePickableRow)?.editingDidBegin()
            self.inlinePickerRowFormer = rowFormer
        }
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    // MARK: Cell
    
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
        if rowFormer.former == nil { rowFormer.former = self }
        rowFormer.cellConfigure(cell)
        return cell
    }
    
    // MARK: HeaderFooterView
    
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