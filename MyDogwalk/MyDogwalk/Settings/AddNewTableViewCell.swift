//
//  AddNewTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class AddNewTableViewCell: UITableViewCell
{
    @IBOutlet weak var FullName: UILabel! //Name of dog/person
    @IBOutlet weak var sex: UILabel! //Gender
    @IBOutlet weak var breed: UILabel! //Breed (ex. Pomeranian)
    @IBOutlet weak var timer: UILabel! //Timer
    @IBOutlet weak var identity: UILabel! //ID
    var dob: String! //Date of Birth
    
    func setCell(list: addNewTxt)
    {
        FullName.text = list.FullName
        sex.text = list.sex
        breed.text = list.breed
        identity.text = list.identity
        timer.text = list.timer
        dob = list.dob
    }

}
