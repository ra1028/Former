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
    
    /** Dynamic height row for iOS 7
     override func layoutSubviews() {
         super.layoutSubviews()
         titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
         bodyLabel.preferredMaxLayoutWidth = bodyLabel.bounds.width
     }
     **/

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        titleLabel.textColor = .formerColor()
    }
    
    // MARK: Private
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
}