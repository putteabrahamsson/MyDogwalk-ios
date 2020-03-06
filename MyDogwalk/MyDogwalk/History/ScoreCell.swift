//
//  ScoreCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-10.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class ScoreCell: UITableViewCell
{
    
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var points: UILabel!
    
    
    func setCell(list: pointsTxt)
    {
        person.text = list.person
        points.text = list.points
    }
}
