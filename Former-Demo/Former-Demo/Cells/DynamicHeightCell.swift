//
//  DynamicHeightCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 11/7/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DynamicHeightCell: UITableViewCell {
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var body: String? {
        get { return bodyLabel.text }
        set { bodyLabel.text = newValue }
    }
    var bodyColor: UIColor? {
        get { return bodyLabel.textColor }
        set { bodyLabel.textColor = newValue }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.textColor = .formerColor()
    }
    
    // MARK: Private
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
}
