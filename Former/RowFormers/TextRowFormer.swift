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
}

public class TextRowFormer: RowFormer {
    
    public var text: String?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var textNumberOfLines: Int?
    
    init<T: UITableViewCell where T: TextFormableRow>(
        cellType: T.Type,
        registerType: Former.RegisterType,
        text: String? = nil,
        selectedHandler: (NSIndexPath -> Void)? = nil) {
        
            super.init(cellType: cellType, registerType: registerType, selectedHandler: selectedHandler)
            self.text = text
    }
    public override func cellConfigure() {
        
        super.cellConfigure()
        
        guard let cell = self.cell as? TextFormableRow else { return }
        
        let textLabel = cell.formerTextLabel()
        textLabel?.text = self.text
        textLabel?.font = self.font
        textLabel?.textColor = self.textColor
        textLabel?.textAlignment =? self.textAlignment
        textLabel?.numberOfLines =? self.textNumberOfLines
    }
}