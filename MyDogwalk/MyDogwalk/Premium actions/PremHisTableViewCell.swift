//
//  PremHisTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-27.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PremHisTableViewCell: UITableViewCell
{

    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var dateOfAction: UILabel!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var dog: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
