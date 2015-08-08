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
    
    public enum RegisterType {
        
        case Nib(nibName: String, bundle: NSBundle?)
        case Class
    }
    
    public weak var tableView: UITableView? {
        didSet {
            self.setupTableView()
        }
    }
    
    public var numberOfSections: Int {
        
        return self.sectionFormers.count
    }
    
    public var rowFormers: [RowFormer] {
        
        return self.sectionFormers.map { $0.rowFormers }.flatMap { $0 }
    }
    
    public private(set) var sectionFormers = [SectionFormer]()
    
    public var autoRegisterEnabled = true
    
    public init(tableView: UITableView) {
        
        super.init()
        self.tableView = tableView
        self.setupTableView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public subscript(index: Int) -> SectionFormer {
        
        return self.sectionFormers[index]
    }
    
    public func register(cellType type: UITableViewCell.Type, registerType: RegisterType) {
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: type.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(type, forCellReuseIdentifier: type.reuseIdentifier)
        }
    }
    
    public func register(viewType type: UITableViewHeaderFooterView.Type, registerType: RegisterType) {
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
        }
    }
    
    public func register(rowFormer rowFormer: RowFormer) {
        
        if rowFormer.registered { return }
        rowFormer.registered = true
        self.register(cellType: rowFormer.cellType, registerType: rowFormer.registerType)
    }
    
    public func register(viewFormer viewFormer: ViewFormer) {
        
        if viewFormer.registered { return }
        viewFormer.registered = true
        self.register(viewType: viewFormer.viewType, registerType: viewFormer.registerType)
    }
    
    public func rowFormer(indexPath: NSIndexPath) -> RowFormer {
        
        return self[indexPath.section][indexPath.row]
    }
    
    public func add(sectionFormers sectionFormers: [SectionFormer]) -> Former {
        
        self.sectionFormers += sectionFormers
        return self
    }
    
    public func select(indexPath indexPath: NSIndexPath, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) {
        
        self.tableView?.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: scrollPosition)
    }
    
    public func select(rowFormer rowFormer: RowFormer, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, oldRowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === oldRowFormer {
                    self.select(indexPath: NSIndexPath(forRow: row, inSection: section), animated: animated, scrollPosition: scrollPosition)
                    return
                }
            }
        }
    }
    
    public func reloadFormer() {
        
        self.tableView?.reloadData()
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            
            self.removeAndUpdate(rowFormers: [oldPickerRowFormer], rowAnimation: .Middle)
            (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
            self.inlinePickerRowFormer = nil
        }
    }
    
    public func reload(section section: Int, rowAnimation: UITableViewRowAnimation = .None) {
        
        guard self.sectionFormers.count > section && section >= 0 else { return }
        self.tableView?.reloadSections(NSIndexSet(index: section), withRowAnimation: rowAnimation)
    }
    
    public func reload(indexPaths indexPaths: [NSIndexPath], rowAnimation: UITableViewRowAnimation) {
        
        self.tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
    }
    
    public func reload(rowFormer rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation) {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, oldRowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === oldRowFormer {
                    self.reload(indexPaths: [NSIndexPath(forRow: row, inSection: section)], rowAnimation: rowAnimation)
                    return
                }
            }
        }
    }
    
    public func insert(rowFormer rowFormer: RowFormer, toIndexPath: NSIndexPath) {
        
        self[toIndexPath.section].insert(rowFormers: [rowFormer], toIndex: toIndexPath.row)
    }
    
    public func insertAndUpdate(rowFormers rowFormers: [RowFormer], toIndexPath: NSIndexPath, rowAnimation: UITableViewRowAnimation = .None) {
        
        self.tableView?.beginUpdates()
        self[toIndexPath.section].insert(rowFormers: rowFormers, toIndex: toIndexPath.row)
        let insertIndexPaths = (0..<rowFormers.count).map {
            NSIndexPath(forRow: toIndexPath.row + $0, inSection: toIndexPath.section)
        }
        self.tableView?.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
    }
    
    public func remove(rowFormers rowFormers: [RowFormer]) -> [NSIndexPath] {
        
        var removeIndexPaths = [NSIndexPath]()
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, rowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormers.contains(rowFormer) {
                    removeIndexPaths += [NSIndexPath(forRow: row, inSection: section)]
                    sectionFormer.remove(rowFormers: [rowFormer])
                }
            }
        }
        return removeIndexPaths
    }
    
    public func removeAndUpdate(rowFormers rowFormers: [RowFormer], rowAnimation: UITableViewRowAnimation = .None) {
        
        self.tableView?.beginUpdates()
        let oldIndexPaths = self.remove(rowFormers: rowFormers)
        self.tableView?.deleteRowsAtIndexPaths(oldIndexPaths, withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
    }
    
    public func deselect(animated: Bool) {
        
        if let indexPath = self.selectedIndexPath {
            self.tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        self.selectedIndexPath = nil
    }
    
    // MARK: Private
    
    private weak var inlinePickerRowFormer: RowFormer?
    private var selectedIndexPath: NSIndexPath?
    private var oldBottomContentInset: CGFloat?
    private var contentInsetAdjusted = false
    
    private func setupTableView() {
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
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
        
        self.tableView?.endEditing(true)
        self.selectedIndexPath = nil
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.tableView?.endEditing(true)
        self.selectedIndexPath = indexPath
        return indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowFormer = self.rowFormer(indexPath)
        guard rowFormer.enabled else { return }
        
        rowFormer.didSelectCell(indexPath)
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            
            if let currentPickerRowFormer = (rowFormer as? InlinePickableRow)?.pickerRowFormer
                where rowFormer !== self.inlinePickerRowFormer {
                    
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = self.remove(rowFormers: [oldPickerRowFormer]).first {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        self.insert(rowFormer: currentPickerRowFormer, toIndexPath: insertIndexPath)
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
        if let FormableRow = cell as? FormableRow {
            FormableRow.configureWithRowFormer(rowFormer)
        }
        rowFormer.cell = cell
        return cell
    }
    
    // MARK: HeaderFooterVeiw
    
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
        viewFormer.view = headerView
        return headerView
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let viewFormer = self[section].footerViewFormer else { return nil }
        let viewType = viewFormer.viewType
        let footerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(
            viewType.reuseIdentifier
        )
        if let formableFooterView = footerView as? FormableView {
            formableFooterView.configureWithViewFormer(viewFormer)
        }
        viewFormer.view = footerView
        return footerView
    }
}