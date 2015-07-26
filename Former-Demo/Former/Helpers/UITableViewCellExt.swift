//
//  UITableViewCellExt.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    private static var className: String {
        
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    static var reuseIdentifier: String {
        
        return self.className
    }
}