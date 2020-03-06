//
//  HistoryCell.swift
//  MyDogwalk
//
//  Created by Putte on 2018-12-28.
//  Copyright © 2018 Putte. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell
{

    @IBOutlet weak var DogName: UILabel!
    @IBOutlet weak var Person: UILabel!
    @IBOutlet weak var Action: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    func setCell(list: listTxt)
    {
        DogName.text = list.dog
        Person.text = list.person
        Action.text = list.action
        Date.text = list.date
        Time.text = list.time 
    }
}
