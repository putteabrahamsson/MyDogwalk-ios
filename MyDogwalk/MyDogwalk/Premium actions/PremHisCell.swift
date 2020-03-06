//
//  PremHisCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-27.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class PremHisCell: UITableViewCell
{
    @IBOutlet weak var titleOfRow: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var dateOfAction: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var docID: UILabel!
    
    
    func setCell(contentArray: contentTxt)
    {
        titleOfRow.text = contentArray.title
        dogName.text = contentArray.dog
        who.text = contentArray.who
        dateOfAction.text = contentArray.date
        content.text = contentArray.content
        docID.text = contentArray.docID
    }
    
}
