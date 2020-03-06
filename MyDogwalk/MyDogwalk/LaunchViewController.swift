//
//  LaunchViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-08.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var lbl_hey: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        lbl_hey.text = NSLocalizedString("Hej! Mitt namn är Putte", comment: "14214")
        
    }
    



}
