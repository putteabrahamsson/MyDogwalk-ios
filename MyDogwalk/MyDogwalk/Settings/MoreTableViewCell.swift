//
//  MoreTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-30.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell
{
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var buttonName: UILabel!
    
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
