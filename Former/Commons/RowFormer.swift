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

public class RowFormer {
    
    // MARK: Public
    
    public internal(set) final weak var former: Former?
    public private(set) final var cell: UITableViewCell?
    public var cellHeight: CGFloat = 44.0
    public internal(set) final var isEditing = false
    public var enabled = true {
        didSet { update() }
    }
    public var canBecomeEditing: Bool {
        return false
    }
    public var onSelected: ((indexPath: NSIndexPath, rowFormer: RowFormer) -> Void)?
    
    public init<T: UITableViewCell>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        cellSetup: (T -> Void)? = nil) {
            self.cellType = cellType
            self.instantiateType = instantiateType
            self.cellSetup = { cellSetup?(($0 as! T)) }
            initialized()
    }
    
    public func initialized() {}
    
    public func update() {
        if let cell = cell {
            cell.userInteractionEnabled = enabled
            if let formableRow = cell as? FormableRow {
                formableRow.updateWithRowFormer(self)
            }
        }
    }
    
    public func cellSelected(indexPath: NSIndexPath) {
        if enabled {
           onSelected?(indexPath: indexPath, rowFormer: self)
        }
    }
    
    // MARK: Internal
    
    final func cellConfigure() {
        let instantiateCell: (RowFormer -> Void) = { rowFormer in
            switch rowFormer.instantiateType {
            case .Class:
                rowFormer.cell = rowFormer.cellType.init(style: .Default, reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                rowFormer.cell = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewCell
                assert(rowFormer.cell != nil, "[Former] Failed to load cell from nib (\(nibName)).")
            }
            _ = rowFormer.cell.map {
                rowFormer.cellSetup($0)
            }
        }
        
        if cell == nil {
            instantiateCell(self)
        }
        update()
        
        if let formableRow = cell as? FormableRow {
            formableRow.updateWithRowFormer(self)
        }
        if let inlineRow = self as? InlineRow {
            let inlineRowFormer = inlineRow.inlineRowFormer
            if inlineRowFormer.cell == nil {
                instantiateCell(inlineRowFormer)
            }
            inlineRowFormer.update()
            if let inlineFormableRow = inlineRowFormer.cell as? FormableRow {
                inlineFormableRow.updateWithRowFormer(inlineRowFormer)
            }
        }
    }
    
    // MARK: Private
    
    private final let cellType: UITableViewCell.Type
    private final let instantiateType: Former.InstantiateType
    private final let cellSetup: (UITableViewCell -> Void)
}