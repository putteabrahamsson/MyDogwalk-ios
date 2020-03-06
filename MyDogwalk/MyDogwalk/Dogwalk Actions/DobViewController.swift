//
//  DobViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-03.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class DobViewController: UIViewController
{
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var choose: UIButton!
    
    var cDatum: String!
    var editMode: Bool!
    var dogID: String!
    
    var dogBool = false
    var personBool = false
    
    //Keep the data from AddDogwalkViewController
    var name: String!
    var breed: String!
    var dob: String!
    var gender: String!
    var timer: String!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        choose.layer.cornerRadius = 5.0
        
        translateCode()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        cDatum = formatter.string(from: datePicker.date)
        datePicker.datePickerMode = .date
        
        if dogBool == true
        {
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())
            datePicker.maximumDate = Date()
        }
        else
        {
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -119, to: Date())
            datePicker.maximumDate = Date()
        }

    }
    
    func translateCode()
    {
        header.title = NSLocalizedString("dobHeader", comment: "")
        datePicker.locale = NSLocale.init(localeIdentifier: NSLocalizedString("dateLocale", comment: "")) as Locale
        choose.setTitle(NSLocalizedString("dobChoose", comment: ""), for: .normal)
    }
    
    @IBAction func valueChanged(_ sender: Any)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        cDatum = formatter.string(from: datePicker.date)
    }
    
    @IBAction func choose(_ sender: Any)
    {
        if dogBool == true
        {
            if editMode == true
            {
                if let storyboard = storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
                    
                    vc.editMode = true
                    vc.DoB = cDatum
                    vc.documentID = dogID
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if let storyboard = storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
                    
                    vc.DoB = cDatum
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
            
        else if personBool == true
        {
            if editMode == true
            {
                if let storyboard = storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "PersonViewController") as! PersonViewController
                    
                    vc.editMode = true
                    vc.dobStr = cDatum
                    vc.documentID = dogID
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if let storyboard = storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "PersonViewController") as! PersonViewController
                    
                    vc.dobStr = cDatum
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
