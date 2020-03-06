//
//  DogViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class DogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate {
    
    //Banner for advertisement
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    //Variable
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var changeHeader: UINavigationItem!
    @IBOutlet weak var save: UIButton!
    
    
    //Booleans
    var DogBool = false
    var PersonBool = false
    var WhatBool = false
    
    //Send string to original view
    var selectedData = ""
    var premiumDog = false
    
    var premiumValue: String!
    
    //Firestore connection
    let db = Firestore.firestore()
    
    //Create an array of items to insert into pickerview
    var dogsArray: [String] = []
    var personArray: [String] = []
    var WhatArray : [String] = [
        NSLocalizedString("whatKiss", comment: ""),
        NSLocalizedString("whatBajs", comment: ""),
        "----------------",
        NSLocalizedString("whatKB", comment: ""),
        NSLocalizedString("whatKL", comment: ""),
        NSLocalizedString("whatKR", comment: ""),
        NSLocalizedString("whatKBL", comment: ""),
        NSLocalizedString("whatKBR", comment: ""),
        "----------------",
        NSLocalizedString("whatKI", comment: ""),
        NSLocalizedString("whatBI", comment: ""),
        "----------------",
        NSLocalizedString("whatDB", comment: ""),
        NSLocalizedString("whatInget", comment: "")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        save.layer.cornerRadius = 5.0
        
        translateCode()
        
        //Delegate and DataSource
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        //Start function
        if DogBool == true
        {
            changeHeader.title = NSLocalizedString("dogDog", comment: "")
            getDogs()
        }
        if PersonBool == true
        {
            changeHeader.title = NSLocalizedString("dogPerson", comment: "")
            getPerson()
        }
        if WhatBool == true
        {
             changeHeader.title = NSLocalizedString("dogWhat", comment: "")
        }
        
        premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
        if premiumValue == "1"
        {
            print("No ads will be shown")
        }
        else
        {
            //Request Advertisement
            let request = GADRequest()
            
            //Set up advertisement
            advertisementBanner.adUnitID = "ca-app-pub-7225493999040026/4779408290"
            
            advertisementBanner.rootViewController = self
            advertisementBanner.delegate = self
            advertisementBanner.load(request)
        }
    }
    
    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    
    //Translating the language
    func translateCode()
    {
        save.setTitle(NSLocalizedString("dogSave", comment: ""), for: .normal)
    }
    
    //-----------------------------------------------------------
    //                 Pickerview properties
    //-----------------------------------------------------------
    
    //Number of Components
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    //Title For Row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if DogBool == true
        {
           selectedData = dogsArray.first!
           return dogsArray[row]
        }
        if PersonBool == true
        {
            selectedData = personArray.first!
            return personArray[row]
        }
        if WhatBool == true
        {
            selectedData = WhatArray.first!
            return WhatArray[row]
        }
        return ""
    }
    
    //Number of Rows in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if DogBool == true
        {
            return dogsArray.count
        }
        if PersonBool == true
        {
            return personArray.count
        }
        if WhatBool == true
        {
            return WhatArray.count
        }
        return 1
    }
    
    //Selected row. Add result to label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if DogBool == true
        {
           selectedData = dogsArray[row]
        }
        if PersonBool == true
        {
            selectedData = personArray[row]
        }
        if WhatBool == true
        {
            selectedData = WhatArray[row]
        }
    }
    
    //-----------------------------------------------------------
    //                 Get dogs and insert into pickerview
    //-----------------------------------------------------------
    var docID: String!
    
    func getDogs()
    {
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("dog").order(by: "dob", descending: false).getDocuments { (QuerySnapshot, err) in
            
            //If error is not equal to nil
            if err != nil
            {
                print("Error getting documents: \(String(describing: err))");
            }
                //Succeded
            else
            {
                //For-loop
                for elem in QuerySnapshot!.documents
                {
                    let data = elem.data()
                    
                    let dogData = data["name"] as! String?
                    self.docID = elem.documentID
                    
                    self.dogsArray.append(dogData!)
                    
                    
                }
                self.pickerView.reloadAllComponents()
                
                if self.dogsArray == []
                {
                    let alert = UIAlertController(title: NSLocalizedString("empty-title", comment: ""), message: NSLocalizedString("empty-txt", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("empty-btn", comment: ""), style: UIAlertAction.Style.default, handler:{ (err) in
                        
                        if let storyboard = self.storyboard
                        {
                            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
                            
                            vc.dog = true
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    //-----------------------------------------------------------
    //                 Get persons and insert into pickerview
    //-----------------------------------------------------------
    func getPerson()
    {
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("person").order(by: "dob", descending: false).getDocuments { (QuerySnapshot, err) in
            
            //If error is not equal to nil
            if err != nil
            {
                print("Error getting documents: \(String(describing: err))");
            }
                //Succeded
            else
            {
                
                //For-loop
                for elem in QuerySnapshot!.documents
                {
                    let data = elem.data()
                    
                    let personData = data["name"] as! String?
                    self.personArray.append(personData!)
                    
                }
                self.pickerView.reloadAllComponents()
                
                if self.personArray == []
                {
                    let alert = UIAlertController(title: NSLocalizedString("empty-title-p", comment: ""), message: NSLocalizedString("empty-txt-p", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("empty-btn-p", comment: ""), style: UIAlertAction.Style.default, handler:{ (err) in
                        
                        if let storyboard = self.storyboard
                        {
                            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //-----------------------------------------------------------
    //                 Save pickerview text and go back
    //-----------------------------------------------------------
    @IBAction func Save(_ sender: Any)
    {
        if selectedData == "----------------"
        {
            let alert = UIAlertController(title: NSLocalizedString("noDotsHeader", comment: ""), message: NSLocalizedString("noDots", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if premiumDog == true
            {
                if PersonBool == true
                {
                    if let storyboard = storyboard
                    {
                        let vc = storyboard.instantiateViewController(withIdentifier: "NewHealthViewController") as! NewHealthViewController
                        
                        vc.cPerson = selectedData
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                if DogBool == true
                {
                    if let storyboard = storyboard
                    {
                        let vc = storyboard.instantiateViewController(withIdentifier: "NewHealthViewController") as! NewHealthViewController
                        
                        vc.cDog = selectedData
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                self.performSegue(withIdentifier: "saveDog", sender: self)
            }
        }
    }
    
    //-----------------------------------------------------------
    //                 Prepare for a segue
    //-----------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if DogBool == true
        {
            let vc = segue.destination as! DogwalkViewController
            vc.dog = selectedData
            vc.documentID = docID
        }
        if PersonBool == true
        {
            let vc = segue.destination as! DogwalkViewController
            vc.person = selectedData
        }
        if WhatBool == true
        {
            let vc = segue.destination as! DogwalkViewController
            vc.what = selectedData
        }
    }
    
    
}

