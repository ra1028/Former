//
//  Profile.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

final class Profile {
    
    static let sharedInstance = Profile()
    
    var image: UIImage?
    var name: String?
    var gender: String?
    var birthDay: NSDate?
    var introduction: String?
    var moreInformation = false
    var nickname: String?
    var location: String?
    var phoneNumber: String?
    var job: String?
}