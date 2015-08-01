//
//  FormerHeaderFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerHeaderFooterView: UITableViewHeaderFooterView, FormableView {
    
    public private(set) var baseView: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    public func configureWithViewFormer(viewFormer: ViewFormer) {}
    
    public func setup() {
        
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .groupTableViewBackgroundColor()
        
        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseView)
        self.baseView = baseView
        
        let constraints = [
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": baseView]
            ),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view": baseView]
            )
        ]
        self.addConstraints(constraints.flatMap{ $0 })
    }
}