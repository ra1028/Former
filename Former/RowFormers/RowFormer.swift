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

public protocol InlinePickableRow {
    
    var pickerRowFormer: RowFormer { get }
    
    // Optional
    func editingDidBegin()
    func editingDidEnd()
}

extension InlinePickableRow {
    
    func editingDidBegin() {}
    func editingDidEnd() {}
}

public class RowFormer: NSObject {
    
    public internal(set) final weak var cell: UITableViewCell? {
        didSet {
            if let cell = cell {
                self.cellConfigure(cell)
            }
        }
    }
    public internal(set) final var isTop: Bool = false
    public internal(set) final var isBottom: Bool = false
    public internal(set) final var registered: Bool = false
    
    public private(set) var cellType: UITableViewCell.Type
    public private(set) var registerType: Former.RegisterType
    public var selectedHandler: ((indexPath: NSIndexPath) -> ())?
    public var cellHeight: CGFloat = 44.0
    public var backgroundColor: UIColor?
    public var accessoryType: UITableViewCellAccessoryType?
    public var selectionStyle: UITableViewCellSelectionStyle?
    public var separatorColor: UIColor = UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
    public var separatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
    
    public init<T: UITableViewCell where T: FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        selectedHandler: (NSIndexPath -> Void)? = nil) {
        
        self.cellType = cellType
        self.registerType = registerType
        self.selectedHandler = selectedHandler
    }
    
    public func cellConfigure(cell: UITableViewCell) {
        
        cell.backgroundColor =? self.backgroundColor
        cell.selectionStyle =? self.selectionStyle
        cell.accessoryType =? self.accessoryType
    }
    
    public func didSelectCell(indexPath: NSIndexPath) {
        
        self.selectedHandler?(indexPath: indexPath)
    }
}