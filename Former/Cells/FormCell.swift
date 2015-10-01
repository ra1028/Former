//
//  FormCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormCell: UITableViewCell, FormableRow {
    
    // MARK: Public
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public func updateWithRowFormer(rowFormer: RowFormer) {}
    
    public func setup() {
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        textLabel?.backgroundColor = .clearColor()
    }
}