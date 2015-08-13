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
    
    public private(set) final weak var cell: UITableViewCell?
    final weak var former: Former?
    public internal(set) final var isTop = false
    public internal(set) final var isBottom = false
    public internal(set) final var registered = false
    public internal(set) final var isEditing = false
    public var canBecomeEditing: Bool {
        return false
    }
    
    public private(set) var cellType: UITableViewCell.Type
    public private(set) var registerType: Former.RegisterType
    public var selectedHandler: ((indexPath: NSIndexPath) -> ())?
    public var cellHeight: CGFloat = 44.0
    public var enabled = true
    public var backgroundColor: UIColor?
    public var accessoryType: UITableViewCellAccessoryType?
    public var selectionStyle: UITableViewCellSelectionStyle?
    public var separatorColor: UIColor?
    public var separatorInsets: UIEdgeInsets?
    public var tintColor: UIColor?
    
    public init<T: UITableViewCell where T: FormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        selectedHandler: (NSIndexPath -> Void)? = nil) {
            
            self.cellType = cellType
            self.registerType = registerType
            super.init()
            
            self.selectedHandler = selectedHandler
            self.initializeRowFomer()
    }
    
    public func initializeRowFomer() {
        
        self.backgroundColor = .whiteColor()
        self.separatorColor = UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
        self.separatorInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
    }
    
    final func cellConfigure(cell: UITableViewCell) {
        
        self.cell = cell
        self.update()
    }
    
    public func update() {
        
        if let cell = self.cell {
            
            cell.backgroundColor = self.backgroundColor
            cell.selectionStyle = self.enabled ?
                (self.selectionStyle ?? .Default) :
                UITableViewCellSelectionStyle.None
            cell.accessoryType =? self.accessoryType
            cell.tintColor =? self.tintColor
            
            if let row = cell as? FormableRow {
                row.configureWithRowFormer(self)
            }
        }
    }
    
    public func cellSelected(indexPath: NSIndexPath) {
        
        if self.enabled {
            self.selectedHandler?(indexPath: indexPath)
        }
    }
}