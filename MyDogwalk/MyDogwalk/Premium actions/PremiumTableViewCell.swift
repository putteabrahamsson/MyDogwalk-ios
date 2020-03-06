//
//  PremiumTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-16.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PremiumTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var buttonName: UILabel!
    @IBOutlet weak var buttonIcon: UIImageView!
    
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
