//
//  ImageTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-09.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell
{

    @IBOutlet weak var imgViewBox: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
