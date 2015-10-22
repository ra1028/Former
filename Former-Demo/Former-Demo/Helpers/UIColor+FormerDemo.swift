//
//  UIColorExt.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/5/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func formerColor() -> UIColor {
        return UIColor(red: 35 / 255 , green: 40 / 255, blue: 55 / 255, alpha: 1)
    }
    
    class func formerSubColor() -> UIColor {
        return UIColor(red: 230 / 255, green: 140 / 255, blue: 20 / 255, alpha: 1)
    }
    
    class func formerHighlightedSubColor() -> UIColor {        
        return UIColor(red: 255 / 255, green: 180 / 255, blue: 30 / 255, alpha: 1)
    }
}