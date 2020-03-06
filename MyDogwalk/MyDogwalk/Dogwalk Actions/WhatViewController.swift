//
//  WhatViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class WhatViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerview: UIPickerView!
    
    var selectedWhat = ""
    
    var WhatArray : [String] = [
        "Kiss",
        "Bajs",
        "Lek",
        "--------",
        "Kiss & Bajs",
        "Kiss & Lek",
        "Kiss, Bajs & Lek",
        "--------",
        "Kiss inne",
        "Bajs inne"
        ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pickerview.delegate = self
        self.pickerview.dataSource = self

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return WhatArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return WhatArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedWhat = WhatArray[row]
    }
    
    
    @IBAction func save(_ sender: Any)
    {
        self.performSegue(withIdentifier: "saveWhat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! DogwalkViewController
        
        vc.what = selectedWhat
    }
    
}
