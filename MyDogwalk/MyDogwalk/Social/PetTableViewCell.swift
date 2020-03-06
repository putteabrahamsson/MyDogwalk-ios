//
//  PetTableViewCell.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-15.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessWebsite: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
