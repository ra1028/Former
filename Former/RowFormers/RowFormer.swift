//
//  RowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableRow: class {
    
    func updateWithRowFormer(rowFormer: RowFormer)
}

public protocol InlineRow: class {
    
    var inlineRowFormer: RowFormer { get }
    func editingDidBegin()
    func editingDidEnd()
}

internal protocol FormerValidatable: class {
    
    func validate() -> Bool
}

public class RowFormer: NSObject {
    
    public internal(set) final weak var former: Former?
    public private(set) final var cell: UITableViewCell?
    public internal(set) final var isEditing = false
    public private(set) var instantiateType: Former.InstantiateType
    public var onSelected: ((indexPath: NSIndexPath, rowFormer: RowFormer) -> Void)?
    public var cellHeight: CGFloat = 44.0
    public var enabled = true {
        didSet {
            self.update()
        }
    }
    public var canBecomeEditing: Bool {
        return false
    }
    
    private final var cellType: UITableViewCell.Type
    private final let cellConfiguration: (UITableViewCell -> Void)
    
    public init<T: UITableViewCell where T: FormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        cellConfiguration: (T -> Void)? = nil) {
            
            self.cellType = cellType
            self.instantiateType = instantiateType
            self.cellConfiguration = {
                if let cell = $0 as? T {
                    cellConfiguration?(cell)
                } else {
                    assert(false, "Cell type is not match at creation time.")
                }
            }
            super.init()
            self.initialize()
    }
    
    public func initialize() {}
    
    final func cellConfigure() {
        
        if self.cell == nil {
            switch self.instantiateType {
            case .Class:
                self.cell = self.cellType.init(style: .Default, reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                self.cell = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewCell
                assert(self.cell != nil, "Failed to load cell \(nibName) from nib.")
            }
            _ = self.cell.map { self.cellConfiguration($0) }
        }
        
        self.update()
        
        if let formableRow = self.cell as? FormableRow {
            formableRow.updateWithRowFormer(self)
        }
    }
    
    public func update() {
        
        if let cell = self.cell {
            
            cell.userInteractionEnabled = self.enabled
            
            if let formableRow = cell as? FormableRow {
                formableRow.updateWithRowFormer(self)
            }
            
            
        }
    }
    
    public final func cellUpdate<T: UITableViewCell>(@noescape update: (T -> Void)) {
        
        if let cell = self.cell as? T {
            update(cell)
        }
    }
    
    public func cellSelected(indexPath: NSIndexPath) {
        
        if self.enabled {
            self.onSelected?(indexPath: indexPath, rowFormer: self)
        }
    }
}