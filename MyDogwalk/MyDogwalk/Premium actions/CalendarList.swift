//
//  CalendarList.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-28.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class calendarTxt
{
    var title: String!
    var date: String!
    var dogName: String!
    var person: String!
    var location: String!
    var note: String!
    var documentID: String!
    
    init(title: String, date: String, dogName: String, person: String, location: String, note: String, documentID: String!)
    {
        self.title = title
        self.date = date
        self.dogName = dogName
        self.person = person
        self.location = location
        self.note = note
        self.documentID = documentID
    }
}   
