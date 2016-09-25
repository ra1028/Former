//
//  FormCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormCell: UITableViewCell, FormableRow {
    
    // MARK: Public
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open func updateWithRowFormer(_ rowFormer: RowFormer) {}
    
    open func setup() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textLabel?.backgroundColor = .clear
    }
}
