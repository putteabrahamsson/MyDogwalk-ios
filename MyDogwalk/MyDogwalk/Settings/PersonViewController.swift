//
//  PersonViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-27.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class PersonViewController: UIViewController,UITextFieldDelegate, GADInterstitialDelegate, GADBannerViewDelegate
{
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    var premiumValue: String!
    var editMode = false
    
    var nameStr = ""
    var genderStr = ""
    var dobStr = ""
    
    var failDate: String!
    
    var documentID: String!
    
    let db = Firestore.firestore()
    
    //Declaring
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var save: UIBarButtonItem!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var txtfield_name: UITextField!
    @IBOutlet weak var txtfield_dob: UITextField!
    @IBOutlet weak var segGender: UISegmentedControl!

    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getValues()
        
        translateCode()
        insertDOBArrow()
        
        txtfield_name.delegate = self

        if editMode == true
        {
            header.title = NSLocalizedString("edit-person", comment: "")
        }
        else
        {
            header.title = NSLocalizedString("add-person", comment: "")
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
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    func getValues()
    {
        //Inserting values into UserDefaults for temporary save.
        if nameStr != ""
        {
            UserDefaults.standard.set(nameStr, forKey: "pNameKey")
        }
        if genderStr != ""
        {
            UserDefaults.standard.set(genderStr, forKey: "pSexKey")
        }
        if dobStr != ""
        {
            UserDefaults.standard.set(dobStr, forKey: "pDobKey")
        }
        
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtfield_name.text = UserDefaults.standard.value(forKey:"pNameKey") as? String
        genderStr = UserDefaults.standard.value(forKey:"pSexKey") as? String ?? "2"
        txtfield_dob.text = UserDefaults.standard.value(forKey:"pDobKey") as? String
        
        if genderStr == "0"
        {
            segGender.selectedSegmentIndex = 0
        }
        else if genderStr == "1"
        {
            segGender.selectedSegmentIndex = 1
        }
        else
        {
            segGender.selectedSegmentIndex = 2
        }
    }
    
    @IBAction func save(_ sender: Any)
    {
        if segGender.selectedSegmentIndex == 0
        {
            genderStr = "0"
        }
        else if segGender.selectedSegmentIndex == 1
        {
            genderStr = "1"
        }
        else
        {
            genderStr = "2"
        }
        
        if txtfield_name.text != ""
        {
            if editMode == true
            {
                let authentication = Auth.auth().currentUser?.uid
                
                //Replacing dogs
                db.collection("users").document(authentication!)
                    .collection("person").document(documentID).setData(
                        [
                            "name": self.txtfield_name.text!,
                            "sex": self.genderStr,
                            "dob": self.txtfield_dob.text!
                        ], completion: { (err) in
                            if err != nil
                            {
                                print("Error replacing!")
                                
                                let prefs = UserDefaults.standard
                                prefs.removeObject(forKey: "pNameKey")
                                prefs.removeObject(forKey: "pSexKey")
                                prefs.removeObject(forKey: "pDobKey")
                                
                                return
                            }
                            else
                            {
                                let prefs = UserDefaults.standard
                                prefs.removeObject(forKey: "pNameKey")
                                prefs.removeObject(forKey: "pSexKey")
                                prefs.removeObject(forKey: "pDobKey")
                                
                                if self.interstitial.isReady
                                {
                                    self.interstitial.present(fromRootViewController: self)
                                }
                                else
                                {
                                    if let storyboard = self.storyboard
                                    {
                                        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                                        
                                        vc.human = true
                                        
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                    })
                }
                else
                {
                    let authentication = Auth.auth().currentUser?.uid

                    var _: DocumentReference = self.db
                        
                        .collection("users").document(authentication!)
                        .collection("person").addDocument(data:
                            [
                                "name": self.txtfield_name.text!,
                                "sex": self.genderStr,
                                "dob": self.txtfield_dob.text!
                                
                            ], completion: { (err) in
                                if err != nil
                                {
                                    print("Error adding information!")
                                    let prefs = UserDefaults.standard
                                    prefs.removeObject(forKey: "pNameKey")
                                    prefs.removeObject(forKey: "pSexKey")
                                    prefs.removeObject(forKey: "pDobKey")
                                    
                                    return
                                }
                                else
                                {
                                    let prefs = UserDefaults.standard
                                    prefs.removeObject(forKey: "pNameKey")
                                    prefs.removeObject(forKey: "pSexKey")
                                    prefs.removeObject(forKey: "pDobKey")
                                    
                                    print("Succeeded")
                                    if self.interstitial.isReady
                                    {
                                        self.interstitial.present(fromRootViewController: self)
                                    }
                                    else
                                    {
                                        if let storyboard = self.storyboard
                                        {
                                            let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                                            
                                            vc.human = true
                                            
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }
                        })
                 }
            }
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("newPerson-alert-title", comment: ""), message: NSLocalizedString("newPerson-alert-txt", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("newPerson-ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
            
            vc.human = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func dobTapped(_ sender: Any)
    {
        txtfield_dob.inputView = UIView()
        
        nameStr = txtfield_name.text!
        dobStr = txtfield_dob.text!
        
        if segGender.selectedSegmentIndex == 0
        {
            genderStr = "0"
        }
        else if segGender.selectedSegmentIndex == 1
        {
            genderStr = "1"
        }
        else if segGender.selectedSegmentIndex == 2
        {
            genderStr = "2"
        }
    
        getValues()
        
        if editMode == true
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "DobViewController") as! DobViewController
                
                vc.personBool = true
                vc.editMode = true
                vc.dogID = documentID
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "DobViewController") as! DobViewController
                
                vc.personBool = true
                
                self.present(vc, animated: true, completion: nil)
            }
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
        save.title = NSLocalizedString("newPerson-save", comment: "")
        name.text = NSLocalizedString("newPerson-name", comment: "")
        
        segGender.setTitle(NSLocalizedString("seg0Male", comment: ""), forSegmentAt: 0)
        segGender.setTitle(NSLocalizedString("seg1Female", comment: ""), forSegmentAt: 1)
        segGender.setTitle(NSLocalizedString("seg2Other", comment: ""), forSegmentAt: 2)
        
        gender.text = NSLocalizedString("newPerson-gender", comment: "")
        dob.text = NSLocalizedString("newPerson-dob", comment: "")
        
    }
    
    func insertDOBArrow()
    {
        txtfield_dob.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_dob.frame.height / 2, height: txtfield_dob.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_dob.rightView = imageView
    }
    


}
