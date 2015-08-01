//
//  TextRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFormableRow: FormableRow {
    
    func formerTextLabel() -> UILabel?
    func formerSubTextLabel() -> UILabel?
}

public class TextRowFormer: RowFormer {
    
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var numberOfLines: Int?
    
    public var subText: String?
    public var subTextFont: UIFont?
    public var subTextColor: UIColor?
    
    override init<T: UITableViewCell where T: TextFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        selectedHandler: (NSIndexPath -> Void)? = nil) {
        
            super.init(cellType: cellType, registerType: registerType, selectedHandler: selectedHandler)
    }
    public override func cellConfigure(cell: UITableViewCell) {
        
        super.cellConfigure(cell)
        
        if let row = self.cell as? TextFormableRow {
            
            let textLabel = row.formerTextLabel()
            textLabel?.text =? self.text
            textLabel?.font =? self.font
            textLabel?.textColor = self.textColor
            textLabel?.textAlignment =? self.textAlignment
            textLabel?.numberOfLines =? self.numberOfLines
            
            let subTextLabel = row.formerSubTextLabel()
            subTextLabel?.text =? self.subText
            subTextLabel?.font =? self.subTextFont
            subTextLabel?.textColor =? self.subTextColor
        }
    }
}