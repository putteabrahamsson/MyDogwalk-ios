//
//  HistoryCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class HistoryCell: UITableViewCell
{
    
    @IBOutlet weak var DogName: UILabel!
    @IBOutlet weak var Person: UILabel!
    @IBOutlet weak var Action: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var kilometer: UILabel!
    @IBOutlet weak var documentID: UILabel!
    var latitude: [Double] = []
    var longitude: [Double] = []
    @IBOutlet weak var note: UILabel!
    var imgUrl: [String] = []
    
    //Note image
    @IBOutlet weak var noteImg: UIImageView!
    
    func setCell(list: listTxt)
    {
        DogName.text = list.dog
        Person.text = list.person
        Action.text = list.action
        Date.text = list.date
        Time.text = list.time
        timer.text = list.timer
        kilometer.text = list.kilometers
        documentID.text = list.documentID
        latitude = list.latitude
        longitude = list.longitude
        note.text = list.note
        noteImg.image = list.noteImg
        imgUrl = list.imgUrl
    }
}
