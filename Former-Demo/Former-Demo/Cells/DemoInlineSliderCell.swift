//
//  DemoDemoInlineSliderCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 9/6/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

final class DemoDemoInlineSliderCell: UITableViewCell, DemoInlineSliderFormableRow {
    
    private var titleLabel: UILabel!
    private var colorDisplayView: UIView!
    private var displayColor: UIColor?
    
    func formerTitleLabel() -> UILabel? {
        
        return self.titleLabel
    }
    
    func formerColorDisplayView() -> UIView? {
        
        return self.colorDisplayView
    }
    
    func configureWithRowFormer(rowFormer: RowFormer) {}
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        if highlighted {
            self.displayColor = self.colorDisplayView.backgroundColor
        }
        
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.colorDisplayView.backgroundColor = self.displayColor
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        if selected {
            self.displayColor = self.colorDisplayView.backgroundColor
        }
        
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.colorDisplayView.backgroundColor = self.displayColor
        }
    }
    
    func configureViews() {
        
        self.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.textLabel?.backgroundColor = .clearColor()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(titleLabel, atIndex: 0)
        self.titleLabel = titleLabel
        
        let colorDisplayView = UIView()
        colorDisplayView.userInteractionEnabled = false
        colorDisplayView.translatesAutoresizingMaskIntoConstraints = false
        colorDisplayView.backgroundColor = .clearColor()
        colorDisplayView.layer.cornerRadius = 10.0
        self.contentView.insertSubview(colorDisplayView, atIndex: 0)
        self.colorDisplayView = colorDisplayView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[colorDisplay(20)]",
                options: [],
                metrics: nil,
                views: ["colorDisplay": colorDisplayView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-15-[colorDisplay(20)]-10-[title]",
                options: .AlignAllCenterY,
                metrics: nil,
                views: ["colorDisplay": colorDisplayView, "title": titleLabel]
            )
        ]
        
        self.contentView.addConstraints(constraints.flatMap { $0 })
    }
}