//
//  ProfileData.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class ProfileData {
    
    static let sharedInstance = ProfileData()
    
    var image: UIImage?
    var name: String?
    var gender: String?
    var birthDay: NSDate?
    var location: String?
}