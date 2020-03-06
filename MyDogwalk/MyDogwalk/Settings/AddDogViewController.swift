//
//  AddDogViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class AddDogViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate, GADBannerViewDelegate
{
    var nameStr = ""
    var breedStr = ""
    var sexStr = ""
    var documentID = ""
    var timerStr = ""
    var DoB = ""
    var gender = ""
    
    var premiumValue: String!
    var rowID: Int!
    var editMode: Bool!
    var addNew = true
    var failDate: String!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var breed: UITextField!
    @IBOutlet weak var dob: UITextField!
    
    //Declaring for translation
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_breed: UILabel!
    @IBOutlet weak var lbl_sex: UILabel!
    @IBOutlet weak var lbl_dateOfBirth: UILabel!
    @IBOutlet weak var segGender: UISegmentedControl!
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var more: UILabel!
    
    let db = Firestore.firestore()
    
    var timerValue: String!
    
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getValues()
        
        translateCode()
        insertDOBArrow()
        
        name.delegate = self
        breed.delegate = self
        
        if editMode == true
        {
            header.title = NSLocalizedString("editMode", comment: "")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
        if premiumValue == "1"
        {
            print("No ads will be shown")
        }
        else
        {
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
            let request = GADRequest()
            
            interstitial.load(request)
            interstitial.delegate = self
            
            //Request Advertisement
            let gRequest = GADRequest()
            
            //Set up advertisement
            advertisementBanner.adUnitID = "ca-app-pub-7225493999040026/4779408290"
            
            advertisementBanner.rootViewController = self
            advertisementBanner.delegate = self
            advertisementBanner.load(gRequest)
        }
    }

    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    
    @IBAction func saveNewDog(_ sender: Any)
    {
        if addNew == true
        {
            addNew = false
            
            if segGender.selectedSegmentIndex == 0
            {
                gender = "0"
            }
            else if segGender.selectedSegmentIndex == 1
            {
                gender = "1"
            }
            else
            {
                gender = "2"
            }
            
            if name.text != ""
            {
                if timerStr == ""
                {
                    timerStr = "864000022.0"
                }
                if editMode == true
                {
                    let authentication = Auth.auth().currentUser?.uid
                    
                    //Replacing dogs
                    db.collection("users").document(authentication!)
                        .collection("dog").document(documentID).setData(
                            [
                                "name": self.name.text!,
                                "breed": self.breed.text!,
                                "sex": gender,
                                "dob": self.dob.text!,
                                "timer": timerStr
                            ], completion: { (err) in
                                if err != nil
                                {
                                    print("Error replacing!")
                                    return
                                }
                                else
                                {
                                    let prefs = UserDefaults.standard
                                    prefs.removeObject(forKey: "nameKey")
                                    prefs.removeObject(forKey: "breedKey")
                                    prefs.removeObject(forKey: "sexKey")
                                    prefs.removeObject(forKey: "dobKey")
                                    prefs.removeObject(forKey: "addTimerKey")
                                    
                                    if self.interstitial.isReady
                                    {
                                        self.interstitial.present(fromRootViewController: self)
                                    }
                                    else
                                    {
                                        if let storyboard = self.storyboard
                                        {
                                            let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                                            
                                            vc.dog = true
                                            
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }
                        })
                }
                else
                {
                    let authentication = Auth.auth().currentUser?.uid
                    
                    //Equal to above, but for "Person"
                    var _: DocumentReference = self.db
                        
                        .collection("users").document(authentication!)
                        .collection("dog").addDocument(data:
                            ["name": self.name.text!,
                             "breed": self.breed.text!,
                             "sex": gender,
                             "dob": self.dob.text!,
                             "timer": timerStr
                                
                            ], completion: { (err) in
                                if err != nil
                                {
                                    print("Error adding information!")
                                    return
                                }
                                else
                                {
                                    let prefs = UserDefaults.standard
                                    prefs.removeObject(forKey: "nameKey")
                                    prefs.removeObject(forKey: "breedKey")
                                    prefs.removeObject(forKey: "sexKey")
                                    prefs.removeObject(forKey: "dobKey")
                                    prefs.removeObject(forKey: "addTimerKey")
                                    
                                    if self.interstitial.isReady
                                    {
                                        self.interstitial.present(fromRootViewController: self)
                                    }
                                    else
                                    {
                                        if let storyboard = self.storyboard
                                        {
                                            let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                                            
                                            vc.dog = true
                                            
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                    print("Succeded!")
                                }
                        })
                }
                
            }
            else
            {
                let alert = UIAlertController(title: NSLocalizedString("newDog-alert-title", comment: ""), message: NSLocalizedString("newDog-alert-txt", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("newDog-ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        self.performSegue(withIdentifier: "tableDog", sender: self)
    }
    
    //---------------------------------------------BUTTONS TAPPED -----------------------
    @IBAction func timerTapped(_ sender: Any)
    {
        nameStr = name.text!
        breedStr = breed.text!
        DoB = dob.text!
        
        if segGender.selectedSegmentIndex == 0
        {
            gender = "0"
        }
        else if segGender.selectedSegmentIndex == 1
        {
            gender = "1"
        }
        else if segGender.selectedSegmentIndex == 2
        {
            gender = "2"
        }

        getValues()
        
        if editMode == true
        {
            getRowID()
            print(rowID!)
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ChooseTimerViewController") as! ChooseTimerViewController
                
                vc.editMode = true
                vc.dogID = documentID
                vc.rowID = rowID
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ChooseTimerViewController") as! ChooseTimerViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //Date of Birth tapped
    @IBAction func dob(_ sender: Any)
    {
        dob.inputView = UIView()
        
        nameStr = name.text!
        breedStr = breed.text!
        
        if segGender.selectedSegmentIndex == 0
        {
            gender = "0"
        }
        else if segGender.selectedSegmentIndex == 1
        {
            gender = "1"
        }
        else if segGender.selectedSegmentIndex == 2
        {
            gender = "2"
        }
        
        getValues()
    
        
        if editMode == true
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "DobViewController") as! DobViewController
                
                vc.editMode = true
                vc.dogID = documentID
                vc.dogBool = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "DobViewController") as! DobViewController
                
                vc.dogBool = true

                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func premiumTapped(_ sender: Any)
    {
        getValues()
        
        let premiumData = UserDefaults.standard.value(forKey: "premium") as! String
        
        if premiumData == "1"
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
                
                vc.editMode = false
                
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("no-prem-title", comment: ""), message: NSLocalizedString("no-prem-body", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("no-prem-ok", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                //none
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            print("You don't have premium!")
        }
    }
    
    
    //-----------------------------------------------------------------
    //                 Insert UserDefault values into textfields
    //-----------------------------------------------------------------
    
    func getValues()
    {
        //Inserting values into UserDefaults for temporary save.
        if editMode == true
        {
            UserDefaults.standard.set(editMode, forKey: "editModeKey")
        }
        if nameStr != ""
        {
            UserDefaults.standard.set(nameStr, forKey: "nameKey")
        }
        if breedStr != ""
        {
            UserDefaults.standard.set(breedStr, forKey: "breedKey")
        }
        if gender != ""
        {
            UserDefaults.standard.set(gender, forKey: "sexKey")
        }
        if DoB != ""
        {
            UserDefaults.standard.set(DoB, forKey: "dobKey")
        }
        if timerStr != ""
        {
            UserDefaults.standard.set(timerStr, forKey: "addTimerKey")
        }

        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        editMode = UserDefaults.standard.value(forKey: "editModeKey") as? Bool
        name.text = UserDefaults.standard.value(forKey:"nameKey") as? String
        breed.text = UserDefaults.standard.value(forKey:"breedKey") as? String
        gender = UserDefaults.standard.value(forKey:"sexKey") as? String ?? "2"
        dob.text = UserDefaults.standard.value(forKey: "dobKey") as? String
        timerStr = UserDefaults.standard.value(forKey: "addTimerKey") as? String ?? "864000022.0"

        if gender == "0"
        {
            segGender.selectedSegmentIndex = 0
        }
        else if gender == "1"
        {
            segGender.selectedSegmentIndex = 1
        }
        else
        {
            segGender.selectedSegmentIndex = 2
        }
    }

    
    //Get rowID
    func getRowID()
    {
        if timerStr == "864000022.0"
        {
           rowID = 0
        }
        else if timerStr == "1800.0"
        {
            rowID = 1
        }
        else if timerStr == "3600.0"
        {
            rowID = 2
        }
        else if timerStr == "5400.0"
        {
            rowID = 3
        }
        else if timerStr == "7200.0"
        {
            rowID = 4
        }
        else if timerStr == "9000.0"
        {
            rowID = 5
        }
        else if timerStr == "10800.0"
        {
            rowID = 6
        }
        else if timerStr == "12600.0"
        {
            rowID = 7
        }
        else if timerStr == "14400.0"
        {
            rowID = 8
        }
        else if timerStr == "16200.0"
        {
            rowID = 9
        }
        else if timerStr == "18000.0"
        {
            rowID = 10
        }
        else if timerStr == "19800.0"
        {
            rowID = 11
        }
        else if timerStr == "21600.0"
        {
            rowID = 12
        }
        else if timerStr == "23400.0"
        {
            rowID = 13
        }
        else if timerStr == "25200.0"
        {
            rowID = 14
        }
        else
        {
            rowID = 0
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if self.view.frame.origin.y != 0
        {
            self.view.frame.origin.y = 0
        }
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("newDog-header", comment: "")
        save.title = NSLocalizedString("newDog-save", comment: "")
        
        lbl_name.text = NSLocalizedString("newDog-name", comment: "")
        lbl_breed.text = NSLocalizedString("newDog-breed", comment: "")
        lbl_sex.text = NSLocalizedString("newDog-sex", comment: "")
        lbl_dateOfBirth.text = NSLocalizedString("newDog-dob", comment: "")
        
        segGender.setTitle(NSLocalizedString("seg0", comment: ""), forSegmentAt: 0)
        segGender.setTitle(NSLocalizedString("seg1", comment: ""), forSegmentAt: 1)
        segGender.setTitle(NSLocalizedString("seg2", comment: ""), forSegmentAt: 2)
        
        info.text = NSLocalizedString("newDog-info", comment: "")
        timer.text = NSLocalizedString("newDog-timer", comment: "")
        more.text = NSLocalizedString("newDog-premium", comment: "")

    }
    
    func insertDOBArrow()
    {
        dob.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: dob.frame.height / 2, height: dob.frame.height / 2)
        view.addSubview(imageView)
        
        dob.rightView = imageView
    }
    
    

}
