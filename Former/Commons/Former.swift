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
    
    private var sectionFormers = [SectionFormer]()
    public internal(set) var selectedCellIndexPath: NSIndexPath?
    
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
        
        self.registerCell(rowFormer.cellType, registerType: rowFormer.registerType)
    }
    
    public func registerView(viewFormer: ViewFormer) {
        
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
        self.sectionFormers += sectionFormers
        return self
    }
    
    public func reloadSectionFormer(section: Int, rowAnimation: UITableViewRowAnimation = .None) {
        
        guard self.sectionFormers.count > section && section >= 0 else { return }
        self.tableView?.reloadSections(NSIndexSet(index: section), withRowAnimation: rowAnimation)
    }
    
    public func reloadFormer() {
        
        self.tableView?.reloadData()
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
        self.tableView?.separatorStyle = .None
        self.tableView?.sectionHeaderHeight = 0
        self.tableView?.sectionFooterHeight = 0
        
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
        rowFormer.indexPath = indexPath
        rowFormer.former = self
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