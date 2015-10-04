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

public protocol FormInlinable: class {
    
    var inlineRowFormer: RowFormer { get }
    func editingDidBegin()
    func editingDidEnd()
}

public protocol FormSelectorInputable: class {
    
    var cell: UITableViewCell { get }
    func editingDidBegin()
    func editingDidEnd()
}

internal protocol FormerValidatable: class {
    
    func validate() -> Bool
}

public class RowFormer {
    
    // MARK: Public
    
    public internal(set) final weak var former: Former?
    public final lazy var cell: UITableViewCell = { [unowned self] in
        var cell: UITableViewCell?
        switch self.instantiateType {
        case .Class:
            cell = self.cellType.init(style: .Default, reuseIdentifier: nil)
        case .Nib(nibName: let nibName, bundle: let bundle):
            let bundle = bundle ?? NSBundle.mainBundle()
            cell = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewCell
            assert(cell != nil, "[Former] Failed to load cell from nib (\(nibName)).")
        }
        self.cellSetup(cell!)
        self.cellInitialized(cell!)
        return cell!
        }()
    public var cellHeight: CGFloat = 44.0
    public internal(set) final var isEditing = false
    public var enabled = true { didSet { update() } }
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
    
    public func cellInitialized(cell: UITableViewCell) {}
    
    public func update() {
        cell.userInteractionEnabled = enabled
        
        if let formableRow = cell as? FormableRow {
            formableRow.updateWithRowFormer(self)
        }
        if let inlineRow = self as? FormInlinable {
            let inlineRowFormer = inlineRow.inlineRowFormer
            inlineRowFormer.update()
            if let inlineFormableRow = inlineRowFormer.cell as? FormableRow {
                inlineFormableRow.updateWithRowFormer(inlineRowFormer)
            }
        }
    }
    
    public func cellSelected(indexPath: NSIndexPath) {
        if enabled {
           onSelected?(indexPath: indexPath, rowFormer: self)
        }
    }
    
    // MARK: Private
    
    private final let cellType: UITableViewCell.Type
    private final let instantiateType: Former.InstantiateType
    private final let cellSetup: (UITableViewCell -> Void)
}