//
//  FormerHeaderFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public class FormerHeaderFooterView: UITableViewHeaderFooterView, FormableView {
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    public func configureWithViewFormer(viewFormer: ViewFormer) {
        
        self.backgroundView?.backgroundColor = viewFormer.backgroundColor
    }
    
    public func setup() {
        
        self.backgroundView = UIView()
    }
}