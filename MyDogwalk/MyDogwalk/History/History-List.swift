//
//  History-List.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class listTxt
{
    var dog: String
    var person: String
    var action: String
    var time: String
    var date: String
    var kilometers: String
    var timer: String
    var documentID: String
    var latitude: [Double] = []
    var longitude: [Double] = []
    var note: String
    var noteImg: UIImage
    var imgUrl: [String] = []
    
    init(dog: String, person: String, action: String, time: String, date: String, kilometers: String, timer: String, documentID: String, latitude: [Double] = [], longitude: [Double] = [], note: String, imgUrl: [String] = [], noteImg: UIImage)
    {
        self.dog = dog
        self.person = person
        self.action = action
        self.time = time
        self.date = date
        self.kilometers = kilometers
        self.timer = timer
        self.documentID = documentID
        self.latitude = latitude
        self.longitude = longitude
        self.note = note
        self.noteImg = noteImg
        self.imgUrl = imgUrl
    }
}
