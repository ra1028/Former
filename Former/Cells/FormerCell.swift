//
//  FormerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerCell: UITableViewCell, FormableRow {
    
    private weak var topSeparatorView: UIView!
    private weak var bottomSeparatorView: UIView!
    private weak var bottomSeparatorLeftConst: NSLayoutConstraint!
    private var separatorColor = UIColor(red: 209/255, green: 209/255, blue: 212/255, alpha: 1)
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.configure()
        self.configureViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
        self.configureViews()
    }
    
    public func configureWithRowFormer(rowFormer: RowFormer) {
        
        self.separatorColor =? rowFormer.separatorColor
        self.topSeparatorView.backgroundColor = rowFormer.isTop ? self.separatorColor : nil
        self.bottomSeparatorView.backgroundColor = self.separatorColor
        self.bottomSeparatorLeftConst.constant = rowFormer.isBottom ? 0 : 10.0
    }
    
    public func configure() {
        
        self.textLabel?.backgroundColor = .clearColor()
    }
    
    public func configureViews() {
        
        let topSeparatorView = UIView()
        topSeparatorView.userInteractionEnabled = false
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(topSeparatorView, atIndex: 0)
        self.topSeparatorView = topSeparatorView
        
        let bottomSeparatorView = UIView()
        bottomSeparatorView.userInteractionEnabled = false
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(bottomSeparatorView, atIndex: 0)
        self.bottomSeparatorView = bottomSeparatorView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[separator(0.5)]",
                options: [],
                metrics: nil,
                views: ["separator": topSeparatorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[separator(0.5)]-0-|",
                options: [],
                metrics: nil,
                views: ["separator": bottomSeparatorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[separator]-0-|",
                options: [],
                metrics: nil,
                views: ["separator": topSeparatorView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[separator]-0-|",
                options: [],
                metrics: nil,
                views: ["separator": bottomSeparatorView]
            )
        ]
        let bottomSeparatorLeftConst = NSLayoutConstraint(
            item: bottomSeparatorView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 10.0
        )
        self.addConstraint(bottomSeparatorLeftConst)
        self.bottomSeparatorLeftConst = bottomSeparatorLeftConst
        self.addConstraints(constraints.flatMap { $0 })
    }
}