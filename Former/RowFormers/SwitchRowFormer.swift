//
//  SwitchRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/27/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol SwitchFormableRow: FormableRow {
    
    func formerTitleLabel() -> UILabel
    func formerSwitch() -> UISwitch
}

public class SwitchRowFormer: RowFormer {
    
    private let observer = FormerObserver()
    
    public var switchChangedHandler: (Bool -> Void)?
    public var switched = false
    public var title: String?
    public var titleFont: UIFont?
    public var titleTextColor: UIColor?
    public var switchWithCellSelected: Bool = true
    public var switchOnTintColor: UIColor?
    public var switchThumbTintColor: UIColor?
    public var switchTintColor: UIColor?
    
    init<T : UITableViewCell where T : FormableRow>(
        cellType: T.Type,
        switched: Bool = false,
        title: String? = nil,
        selectedHandler: (NSIndexPath -> Void)? = nil,
        switchChangedHandler: (Bool -> Void)? = nil) {
            
            super.init(cellType: cellType, selectedHandler: selectedHandler)
            self.switchChangedHandler = switchChangedHandler
            self.switched = switched
            self.title = title
    }
    
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? SwitchFormableRow else { return }
        
        let titleLabel = cell.formerTitleLabel()
        let switchButton = cell.formerSwitch()
        
        self.observer.setObservedFormer(self)
        
        titleLabel.text =? self.title
        titleLabel.font =? self.titleFont
        titleLabel.textColor =? self.titleTextColor
        
        switchButton.on = self.switched
        switchButton.onTintColor =? self.switchOnTintColor
        switchButton.thumbTintColor =? self.switchThumbTintColor
        switchButton.tintColor =? self.switchTintColor
        
        self.cell?.selectionStyle = self.switchWithCellSelected ?
            self.selectionStyle ?? .Default :
            .None
    }
    
    public override func cellSelected(indexPath: NSIndexPath) {
        
        super.cellSelected(indexPath)
        
        self.cell?.setSelected(false, animated: true)
        
        if self.switchWithCellSelected {
            
            guard let cell = self.cell as? SwitchFormableRow else { return }
            let switchButton = cell.formerSwitch()
            switchButton.setOn(!switchButton.on, animated: true)
            self.switchChanged()
        }
    }
    
    public dynamic func switchChanged() {
        
        guard let cell = self.cell as? SwitchFormableRow else { return }
        let switchButton = cell.formerSwitch()
        let switched = switchButton.on
        
        self.switched = switched
        self.switchChangedHandler?(self.switched)
    }
}