//
//  CalendarTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-28.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class CalendarTableViewCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cDate: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var textView: UITextView!
    var documentId: String!
    
    func setCell(calendarArray: calendarTxt)
    {
        title.text = calendarArray.title
        cDate.text = calendarArray.date
        dogName.text = calendarArray.dogName
        person.text = calendarArray.person
        location.text = calendarArray.location
        textView.text = calendarArray.note
        documentId = calendarArray.documentID
    }
}
