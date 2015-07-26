//
//  RowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableRow {
    
    // Optional
    func configureWithRowFormer(rowFormer: RowFormer)
}

extension FormableRow {
    
    public func configureWithRowFormer(rowFormer: RowFormer) {}
}

public class RowFormer {
    
    public final weak var cell: UITableViewCell? {
        didSet {
            self.cellConfigreIfFormable()
        }
    }
    public private(set) var cellType: UITableViewCell.Type
    public var selectedHandler: ((indexPath: NSIndexPath) -> ())?
    public var rowHeight: CGFloat = 44.0
    public var backgroundColor = UIColor.whiteColor()
    public var accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    public var separatorColor = UIColor(red: 209/255, green: 209/255, blue: 212/255, alpha: 1)
    var isTop: Bool = false
    var isBottom: Bool = false
    
    public init<T: UITableViewCell where T: FormableRow>(cellType: T.Type, selectedHandler: (NSIndexPath -> Void)? = nil) {
        
        self.cellType = cellType
        self.selectedHandler = selectedHandler
    }
    
    public func cellConfigreIfFormable() {}
    
    public final func resignCellFirstResponder() {
        
        guard let cell = self.cell else { return }
        
        func resignSubViewsFirstResponder(view: UIView) {
            if view.isFirstResponder() {
                view.resignFirstResponder()
            }
            for subview in view.subviews {
                resignSubViewsFirstResponder(subview)
            }
        }
        resignSubViewsFirstResponder(cell)
    }
}