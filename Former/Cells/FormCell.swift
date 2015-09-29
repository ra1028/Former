//
//  FormCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormCell: UITableViewCell, FormableRow {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    public func updateWithRowFormer(rowFormer: RowFormer) {}
    
    public func configureViews() {
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        textLabel?.backgroundColor = .clearColor()
    }
}