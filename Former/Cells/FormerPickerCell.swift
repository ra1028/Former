//
//  FormerPickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/2/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerPickerCell: UITableViewCell, PickerFormableRow {
    
    private weak var pickerView: UIPickerView!
    
    public func formerPickerView() -> UIPickerView {
        
        return self.pickerView
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {}
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }
    
    private func configureViews() {
        
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.textLabel?.backgroundColor = .clearColor()
        
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(pickerView, atIndex: 0)
        self.pickerView = pickerView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-15-[picker]-15-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[picker]-0-|",
                options: [],
                metrics: nil,
                views: ["picker": pickerView]
            )
        ]
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}