//
//  AddViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-09.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds

class AddViewController: UIViewController, UITextFieldDelegate
{
    //Calling Firestore
    let db = Firestore.firestore()
    
    //Translate
    @IBOutlet weak var goBack: UIBarButtonItem!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    @IBOutlet weak var p6: UILabel!
    @IBOutlet weak var d1: UILabel!
    @IBOutlet weak var d2: UILabel!
    @IBOutlet weak var d3: UILabel!
    @IBOutlet weak var historik: UILabel!
    @IBOutlet weak var dogpass: UILabel!
    @IBOutlet weak var settings: UILabel!
    
    
    //Persons
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    @IBOutlet weak var person3: UITextField!
    @IBOutlet weak var person4: UITextField!
    @IBOutlet weak var person5: UITextField!
    @IBOutlet weak var person6: UITextField!
    
    //Dogs
    @IBOutlet weak var hund1: UITextField!
    @IBOutlet weak var hund2: UITextField!
    @IBOutlet weak var hund3: UITextField!
    
    //Button
    @IBOutlet weak var btn_save: UIButton!
    
    
    var interstitial: GADInterstitial!
    //-----------------------------------------------------------
    //                 ViewDidLoad
    //-----------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        loadPersonData()
        loadDogData()
        
        //Delegating to hide keyboard when return-key is tapped
        person1.delegate = self
        person2.delegate = self
        person3.delegate = self
        person4.delegate = self
        person5.delegate = self
        person6.delegate = self
        hund1.delegate = self
        hund2.delegate = self
        hund3.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
        let request = GADRequest()
        
        request.testDevices = [ kGADSimulatorID]
        interstitial.load(request)
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

    //Translate code
    func translateCode()
    {
        header.title = NSLocalizedString("addHeader", comment: "")
        historik.text = NSLocalizedString("addHistory", comment: "")
        dogpass.text = NSLocalizedString("addDogpass", comment: "")
        settings.text = NSLocalizedString("addSettings", comment: "")
        p1.text = NSLocalizedString("addperson", comment: "")
        p2.text = NSLocalizedString("addperson", comment: "")
        p3.text = NSLocalizedString("addperson", comment: "")
        p4.text = NSLocalizedString("addperson", comment: "")
        p5.text = NSLocalizedString("addperson", comment: "")
        p6.text = NSLocalizedString("addperson", comment: "")
        d1.text = NSLocalizedString("adddog", comment: "")
        d2.text = NSLocalizedString("adddog", comment: "")
        d3.text = NSLocalizedString("adddog", comment: "")
        goBack.title = NSLocalizedString("addBack", comment: "")
        btn_save.setTitle(NSLocalizedString("addSave", comment: ""), for: .normal)
    }
    
    //------------------------------------------------------------------------
    //                 Loading data and inserts into the textfields
    //------------------------------------------------------------------------
    
    var personID = ""
    var dogID = ""
    
    func loadPersonData()
    {
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("users").document(authentication!).collection("Person")
            .getDocuments()
                { (QuerySnapshot, err) in
                    if err != nil
                    {
                        print("Error getting documents: \(String(describing: err))");
                    }
                    else
                    {
                        //For-loop
                        for document in QuerySnapshot!.documents
                        {
                            let data = document.data()
                            
                            let data1 = data["Name1"] as? String
                            let data2 = data["Name2"] as? String
                            let data3 = data["Name3"] as? String
                            let data4 = data["Name4"] as? String
                            let data5 = data["Name5"] as? String
                            let data6 = data["Name6"] as? String
                            
                            //Insert data into textfields
                            self.person1.text = data1
                            self.person2.text = data2
                            self.person3.text = data3
                            self.person4.text = data4
                            self.person5.text = data5
                            self.person6.text = data6
                            
                            //Collecting the document ID
                            self.personID = document.documentID
                        }
                    }
        }
                            
                            
    }
    func loadDogData()
    {
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("users").document(authentication!).collection("Dogs")
            .getDocuments()
                { (QuerySnapshot, err) in
                    if err != nil
                    {
                        print("Error getting documents: \(String(describing: err))");
                    }
                    else
                    {
                        //For-loop
                        for document in QuerySnapshot!.documents
                        {
                            let data = document.data()
                            
                            let data1 = data["Dog1"] as? String
                            let data2 = data["Dog2"] as? String
                            let data3 = data["Dog3"] as? String
                            
                            //Insert data into textfields
                            self.hund1.text = data1
                            self.hund2.text = data2
                            self.hund3.text = data3
                            
                            //Collecting the document ID
                            self.dogID = document.documentID
                            
                            self.btn_save.isEnabled = true
                        }
                }
        }
    }
    //-----------------------------------------------------------
    //                 Saving the new data
    //-----------------------------------------------------------
    
    //Button to save the data
    @IBAction func SaveData(_ sender: Any)
    {
        let authentication = Auth.auth().currentUser?.uid
        
        //Replacing persons
        db.collection("users").document(authentication!)
        .collection("Person").document(personID).setData(
        [
           "Name1": person1.text!,
           "Name2": person2.text!,
           "Name3": person3.text!,
           "Name4": person4.text!,
           "Name5": person5.text!,
           "Name6": person6.text!
         ], completion: { (err) in
                    if err != nil
                    {
                        print("Error replacing persons!")
                        return
                    }
                    else
                    {
                        print("Succeded!")
                    }
            })
        
        //Replacing dogs
        db.collection("users").document(authentication!)
            .collection("Dogs").document(dogID).setData(
                [
                    "Dog1": hund1.text!,
                    "Dog2": hund2.text!,
                    "Dog3": hund3.text!,
                ], completion: { (err) in
                    if err != nil
                    {
                        print("Error replacing persons!")
                        return
                    }
                    else
                    {
                        if self.interstitial.isReady
                        {
                            self.interstitial.present(fromRootViewController: self)
                        }
                        else
                        {
                            print("Advertisement is not ready!")
                        }
                    }
            })
        
    }
    
    //-----------------------------------------------------------
    //                 Hide keyboard when done editing
    //-----------------------------------------------------------
    //Hiding keyboarding when touching outside text.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        person1.resignFirstResponder()
        person2.resignFirstResponder()
        person3.resignFirstResponder()
        person4.resignFirstResponder()
        person5.resignFirstResponder()
        person6.resignFirstResponder()
        hund1.resignFirstResponder()
        hund2.resignFirstResponder()
        hund3.resignFirstResponder()
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    //-----------------------------------------------------------
    //                 Buttons for navigation
    //-----------------------------------------------------------
    
    //Go back
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    //Dogwalk
    @IBAction func Dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //History
    @IBAction func history(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //Hundpass
    @IBAction func dogpass(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    


}
