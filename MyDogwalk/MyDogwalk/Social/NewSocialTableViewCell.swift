//
//  NewSocialTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-31.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class NewSocialTableViewCell: UITableViewCell
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
