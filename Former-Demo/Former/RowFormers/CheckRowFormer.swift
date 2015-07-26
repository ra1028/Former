//
//  CheckRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol CheckFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel
}

public class CheckRowFormer: RowFormer {
    
    public var checkChangedHandler: (Bool -> Void)?
    public var checked = false
    public var title: String?
    public var titleFont: UIFont?
    public var titleTextColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        checked: Bool = false,
        title: String? = nil,
        selectedHandler: (NSIndexPath -> Void)? = nil,
        checkChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType)
            
            self.selectedHandler = { [weak self] indexPath in
                if let strongSelf = self {
                    strongSelf.checkChangedHandler?(!strongSelf.checked)
                }
                selectedHandler?(indexPath)
            }
            
            self.checkChangedHandler = { [weak self] checked in
                if let strongSelf = self {
                    let type: UITableViewCellAccessoryType = checked ? .Checkmark : .None
                    strongSelf.cell?.accessoryType = type
                    strongSelf.accessoryType = type
                    strongSelf.checked = checked
                }
                checkChangedHandler?(checked)
            }
            self.checked = checked
            self.title = title
            self.accessoryType = self.checked ? .Checkmark : .None
    }
    
    public override func cellConfigreIfFormable() {
        
        super.cellConfigreIfFormable()
        
        guard let cell = self.cell as? CheckFormableRow else { return }
        
        let titleLabel = cell.formerTitleLabel()
        
        titleLabel.text = self.title
        titleLabel.font = self.titleFont
        titleLabel.textColor = self.titleTextColor
    }
}