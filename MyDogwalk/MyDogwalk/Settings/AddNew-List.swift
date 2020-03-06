//
//  AddNew-List.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class addNewTxt
{
    var FullName: String
    var sex: String
    var breed: String
    var timer: String
    var dob: String
    
    var identity: String
    
    init(FullName: String, sex: String, breed: String, identity: String, timer: String, dob: String)
    {
        self.FullName = FullName
        self.sex = sex
        self.breed = breed
        self.identity = identity
        self.timer = timer
        self.dob = dob
    }
}
