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
    
    public var numberOfSectionFormers: Int {
        return self.sectionFormers.count
    }
    
    public internal(set) var selectedCellIndexPath: NSIndexPath?
    
    private var sectionFormers = [SectionFormer]()
    private weak var inlinePickerRowFormer: RowFormer?
    
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
    
    public func registerCell(cellType: UITableViewCell.Type, registerType: RegisterType) {
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: cellType.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func registerView(viewType: UITableViewHeaderFooterView.Type, registerType: RegisterType) {
        
        self.tableView?.registerClass(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        
        switch registerType {
            
        case .Nib(let nibName, let bundle):
            self.tableView?.registerNib(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        case .Class:
            self.tableView?.registerClass(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        }
    }
    
    public func registerCell(rowFormer: RowFormer) {
        
        if rowFormer.registered { return }
        rowFormer.registered = true
        self.registerCell(rowFormer.cellType, registerType: rowFormer.registerType)
    }
    
    public func registerView(viewFormer: ViewFormer) {
        
        if viewFormer.registered { return }
        viewFormer.registered = true
        self.registerView(viewFormer.viewType, registerType: viewFormer.registerType)
    }
    
    public func rowFormer(indexPath: NSIndexPath) -> RowFormer {
        
        return self[indexPath.section][indexPath.row]
    }
    
    public func addSectionFormer(sectionFormer: SectionFormer, autoRegister: Bool = true) -> Former {
        
        self.addSectionFormers([sectionFormer], autoRegister: autoRegister)
        return self
    }
    
    public func addSectionFormers(sectionFormers: [SectionFormer], autoRegister: Bool = true) -> Former {
        
        if autoRegister {
            self.registerSectionAllCells(sectionFormers)
        }
        self.sectionFormers += sectionFormers
        return self
    }
    
    public func registerSectionAllCells(sectionFormers: [SectionFormer]) {
        
        let register: (SectionFormer -> Void) = { sectionFormer in
            if let header = sectionFormer.headerViewFormer { self.registerView(header) }
            if let footer = sectionFormer.footerViewFormer { self.registerView(footer) }
            sectionFormer.rowFormers.map {
                self.registerCell($0)
            }
        }
        sectionFormers.map {
            register($0)
        }
    }
    
    public func reloadFormer() {
        
        self.tableView?.reloadData()
    }
    
    public func reloadSectionFormer(section: Int, rowAnimation: UITableViewRowAnimation = .None) {
        
        guard self.sectionFormers.count > section && section >= 0 else { return }
        self.tableView?.reloadSections(NSIndexSet(index: section), withRowAnimation: rowAnimation)
    }
    
    public func reloadRow(indexPaths: [NSIndexPath], rowAnimation: UITableViewRowAnimation) {
        
        self.tableView?.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
    }
    
    public func reloadRowFormer(rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation) {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            for (row, oldRowFormer) in sectionFormer.rowFormers.enumerate() {
                if rowFormer === oldRowFormer {
                    self.reloadRow(
                        [NSIndexPath(forRow: row, inSection: section)],
                        rowAnimation: rowAnimation
                    )
                    return
                }
            }
        }
    }
    
    public func insertRowFormer(rowFormer: RowFormer, toIndexPath: NSIndexPath) {
        
        self.registerCell(rowFormer)
        self[toIndexPath.section].insertRowFormer(rowFormer, toIndex: toIndexPath.row)
    }
    
    public func removeRowFormer(rowFormer: RowFormer) -> NSIndexPath? {
        
        for (section, sectionFormer) in self.sectionFormers.enumerate() {
            if let row = sectionFormer.removeRowFormer(rowFormer) {
                return NSIndexPath(forRow: row, inSection: section)
            }
        }
        return nil
    }
    
    public func removeRowFormerAndUpdate(rowFormer: RowFormer, rowAnimation: UITableViewRowAnimation = .None) {
        
        self.tableView?.beginUpdates()
        if let oldIndexPath = self.removeRowFormer(rowFormer) {
            self.tableView?.deleteRowsAtIndexPaths([oldIndexPath], withRowAnimation: rowAnimation)
        }
        self.tableView?.endUpdates()
    }
    
    public func insertRowFormerAndUpdate(rowFormer: RowFormer, toIndexPath: NSIndexPath, rowAnimation: UITableViewRowAnimation = .None) {
        
        self.registerCell(rowFormer)
        self.tableView?.beginUpdates()
        self[toIndexPath.section].insertRowFormer(rowFormer, toIndex: toIndexPath.row)
        self.tableView?.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: rowAnimation)
        self.tableView?.endUpdates()
    }
    
    public func deselectSelectedCell(animated: Bool) {
        
        if let indexPath = self.selectedCellIndexPath {
            self.tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        self.selectedCellIndexPath = nil
    }
    
    // MARK: Private
    
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
    
    private func findRowFormer(view: UIView?) -> UITableViewCell? {
        
        if let view = view {
            if let cell = view as? UITableViewCell {
                return cell
            }
            return self.findRowFormer(view.superview)
        }
        return nil
    }
    
    private dynamic func keyboardWillAppear(notification: NSNotification) {
        
        guard let keyboardInfo = notification.userInfo else { return }
        
        if case let (tableView?, cell?) = (self.tableView, self.findRowFormer(self.findFirstResponder(self.tableView))) where !self.contentInsetAdjusted {
            
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
        self.selectedCellIndexPath = nil
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.tableView?.endEditing(true)
        self.selectedCellIndexPath = indexPath
        return indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowFormer = self.rowFormer(indexPath)
        rowFormer.didSelectCell(indexPath)
        
        if let oldPickerRowFormer = (self.inlinePickerRowFormer as? InlinePickableRow)?.pickerRowFormer {
            
            if let currentPickerRowFormer = (rowFormer as? InlinePickableRow)?.pickerRowFormer
                where rowFormer !== self.inlinePickerRowFormer {
                    
                    self.tableView?.beginUpdates()
                    if let removedIndexPath = self.removeRowFormer(oldPickerRowFormer) {
                        let insertIndexPath =
                        (removedIndexPath.section == indexPath.section && removedIndexPath.row < indexPath.row)
                            ? indexPath : NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                        self.insertRowFormer(currentPickerRowFormer, toIndexPath: insertIndexPath)
                        self.tableView?.deleteRowsAtIndexPaths([removedIndexPath], withRowAnimation: .Middle)
                        self.tableView?.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: .Middle)
                    }
                    self.tableView?.endUpdates()
                    (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
                    (rowFormer as? InlinePickableRow)?.editingDidBegin()
                    self.inlinePickerRowFormer = rowFormer
            } else {
                self.removeRowFormerAndUpdate(oldPickerRowFormer, rowAnimation: .Middle)
                (self.inlinePickerRowFormer as? InlinePickableRow)?.editingDidEnd()
                self.inlinePickerRowFormer = nil
            }
        } else if let inlinePickerRowFormer = rowFormer as? InlinePickableRow {
            
            let pickerRowFormer = inlinePickerRowFormer.pickerRowFormer
            let pickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            self.insertRowFormerAndUpdate(pickerRowFormer, toIndexPath: pickerIndexPath, rowAnimation: .Middle)
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
        
        return self.numberOfSectionFormers
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self[section].numberOfRowFormers
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.rowFormer(indexPath).cellHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let rowFormer = self.rowFormer(indexPath)
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