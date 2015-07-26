//
//  UITableViewHeaderFooterView.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
    
    private static var className: String {
        
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    static var reuseIdentifier: String {
        
        return self.className
    }
}