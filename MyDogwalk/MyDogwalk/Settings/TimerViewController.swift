//
//  TimerViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-15.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds

class TimerViewController: UIViewController, GADBannerViewDelegate
{
    //Calling firestore
    var db = Firestore.firestore()
    
    //Advertisement banner
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    //Declaring the textfields
    @IBOutlet weak var txtfield_dog1: UITextField!
    @IBOutlet weak var txtfield_dog2: UITextField!
    @IBOutlet weak var txtfield_dog3: UITextField!
    
    //Declaring
    @IBOutlet weak var dog1: UILabel!
    @IBOutlet weak var dog2: UILabel!
    @IBOutlet weak var dog3: UILabel!
    @IBOutlet weak var goBack: UIBarButtonItem!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var dogwalk: UILabel!
    @IBOutlet weak var social: UILabel!
    @IBOutlet weak var settings: UILabel!
    
    
    //Booleans
    var dogOne = false
    var dogTwo = false
    var dogThree = false
    
    //Retrieve the value from other view
    var selectedDog1: String!
    var selectedDog2: String!
    var selectedDog3: String!
    
    var dogID: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        //Request Advertisement
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        //Set up advertisement
        advertisementBanner.adUnitID = "ca-app-pub-7225493999040026/4779408290"
        
        advertisementBanner.rootViewController = self
        advertisementBanner.delegate = self
        advertisementBanner.load(request)
        
        loadTimer()
        loadDogData()
        
        //Adding arrows on the rightside of textfield
        insertDog1()
        insertDog2()
        insertDog3()
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("timerHeader", comment: "")
        dogwalk.text = NSLocalizedString("timerDogwalk", comment: "")
        history.text = NSLocalizedString("timerHistory", comment: "")
        social.text = NSLocalizedString("timerSocial", comment: "")
        settings.text = NSLocalizedString("timerSettings", comment: "")
        goBack.title = NSLocalizedString("timerGoBack", comment: "")
        dog1.text = NSLocalizedString("timerDog1", comment: "")
        dog2.text = NSLocalizedString("timerDog2", comment: "")
        dog3.text = NSLocalizedString("timerDog3", comment: "")
    }
    
    func loadTimer()
    {
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("timerCol").document(authentication!).collection("timer")
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
                            self.txtfield_dog1.text = data1
                            self.txtfield_dog2.text = data2
                            self.txtfield_dog3.text = data3
                            
                            self.convertTimer1IntoHours()
                            self.convertTimer2IntoHours()
                            self.convertTimer3IntoHours()
                            
                            //Collecting the document ID
                            self.dogID = document.documentID
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
                            self.dog1.text = data1
                            self.dog2.text = data2
                            self.dog3.text = data3

                        }
                    }
        }
    }
    
    //Navigate when pressing on textfield
    @IBAction func dog1Tapped(_ sender: Any)
    {
        txtfield_dog1.inputView = UIView()
        dogOne = true
        self.performSegue(withIdentifier: "chooseTimer", sender: self)
    }
    
    @IBAction func dog2Tapped(_ sender: Any)
    {
        txtfield_dog2.inputView = UIView()
        dogTwo = true
        self.performSegue(withIdentifier: "chooseTimer", sender: self)
    }
    
    @IBAction func dog3Tapped(_ sender: Any)
    {
        txtfield_dog3.inputView = UIView()
        dogThree = true
        self.performSegue(withIdentifier: "chooseTimer", sender: self)
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

    }
    
    //-------------------Buttons for navigation----------------
    @IBAction func dismissView(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func Dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func History(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func Social(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    
    //Insert arrows
    func insertDog1()
    {
        txtfield_dog1.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_dog1.frame.height / 2, height: txtfield_dog1.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_dog1.rightView = imageView
    }
    func insertDog2()
    {
        txtfield_dog2.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_dog2.frame.height / 2, height: txtfield_dog2.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_dog2.rightView = imageView
    }
    func insertDog3()
    {
        txtfield_dog3.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_dog3.frame.height / 2, height: txtfield_dog3.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_dog3.rightView = imageView
    }
    
    
    //CONVERT INTO HOURS
    
    //CONVERT TIMER 1 INTO HOURS
    func convertTimer1IntoHours()
    {
        if txtfield_dog1.text == "864000022.0"
        {
            txtfield_dog1.text = NSLocalizedString("0h", comment: "")
        }
        if txtfield_dog1.text == "1800.0"
        {
            txtfield_dog1.text = NSLocalizedString("30m", comment: "")
        }
        if txtfield_dog1.text == "3600.0"
        {
            txtfield_dog1.text = NSLocalizedString("1h", comment: "")
        }
        if txtfield_dog1.text == "5400.0"
        {
            txtfield_dog1.text = NSLocalizedString("1h30m", comment: "")
        }
        if txtfield_dog1.text == "7200.0"
        {
            txtfield_dog1.text = NSLocalizedString("2h", comment: "")
        }
        if txtfield_dog1.text == "9000.0"
        {
            txtfield_dog1.text = NSLocalizedString("2h30m", comment: "")
        }
        if txtfield_dog1.text == "10800.0"
        {
            txtfield_dog1.text = NSLocalizedString("3h", comment: "")
        }
        if txtfield_dog1.text == "12600.0"
        {
            txtfield_dog1.text = NSLocalizedString("3h30m", comment: "")
        }
        if txtfield_dog1.text == "14400.0"
        {
            txtfield_dog1.text = NSLocalizedString("4h", comment: "")
        }
        if txtfield_dog1.text == "16200.0"
        {
            txtfield_dog1.text = NSLocalizedString("4h30m", comment: "")
        }
        if txtfield_dog1.text == "18000.0"
        {
            txtfield_dog1.text = NSLocalizedString("5h", comment: "")
        }
        if txtfield_dog1.text == "19800.0"
        {
            txtfield_dog1.text = NSLocalizedString("5h30m", comment: "")
        }
        if txtfield_dog1.text == "21600.0"
        {
            txtfield_dog1.text = NSLocalizedString("6h", comment: "")
        }
        if txtfield_dog1.text == "23400.0"
        {
            txtfield_dog1.text = NSLocalizedString("6h30m", comment: "")
        }
        if txtfield_dog1.text == "25200.0"
        {
            txtfield_dog1.text = NSLocalizedString("7h", comment: "")
        }
    }
    
    
    //CONVERT TIMER 2 INTO HOURS
    func convertTimer2IntoHours()
    {
        if txtfield_dog2.text == "864000022.0"
        {
            txtfield_dog2.text = NSLocalizedString("0h", comment: "")
        }
        if txtfield_dog2.text == "1800.0"
        {
            txtfield_dog2.text = NSLocalizedString("30m", comment: "")
        }
        if txtfield_dog2.text == "3600.0"
        {
            txtfield_dog2.text = NSLocalizedString("1h", comment: "")
        }
        if txtfield_dog2.text == "5400.0"
        {
            txtfield_dog2.text = NSLocalizedString("1h30m", comment: "")
        }
        if txtfield_dog2.text == "7200.0"
        {
            txtfield_dog2.text = NSLocalizedString("2h", comment: "")
        }
        if txtfield_dog2.text == "9000.0"
        {
            txtfield_dog2.text = NSLocalizedString("2h30m", comment: "")
        }
        if txtfield_dog2.text == "10800.0"
        {
            txtfield_dog2.text = NSLocalizedString("3h", comment: "")
        }
        if txtfield_dog2.text == "12600.0"
        {
            txtfield_dog2.text = NSLocalizedString("3h30m", comment: "")
        }
        if txtfield_dog2.text == "14400.0"
        {
            txtfield_dog2.text = NSLocalizedString("4h", comment: "")
        }
        if txtfield_dog2.text == "16200.0"
        {
            txtfield_dog2.text = NSLocalizedString("4h30m", comment: "")
        }
        if txtfield_dog2.text == "18000.0"
        {
            txtfield_dog2.text = NSLocalizedString("5h", comment: "")
        }
        if txtfield_dog2.text == "19800.0"
        {
            txtfield_dog2.text = NSLocalizedString("5h30m", comment: "")
        }
        if txtfield_dog2.text == "21600.0"
        {
            txtfield_dog2.text = NSLocalizedString("6h", comment: "")
        }
        if txtfield_dog2.text == "23400.0"
        {
            txtfield_dog2.text = NSLocalizedString("6h30m", comment: "")
        }
        if txtfield_dog2.text == "25200.0"
        {
            txtfield_dog2.text = NSLocalizedString("7h", comment: "")
        }
    }
    
    //CONVERT TIMER 3INTO HOURS
    func convertTimer3IntoHours()
    {
        if txtfield_dog3.text == "864000022.0"
        {
            txtfield_dog3.text = NSLocalizedString("0h", comment: "")
        }
        if txtfield_dog3.text == "1800.0"
        {
            txtfield_dog3.text = NSLocalizedString("30m", comment: "")
        }
        if txtfield_dog3.text == "3600.0"
        {
            txtfield_dog3.text = NSLocalizedString("1h", comment: "")
        }
        if txtfield_dog3.text == "5400.0"
        {
            txtfield_dog3.text = NSLocalizedString("1h30m", comment: "")
        }
        if txtfield_dog3.text == "7200.0"
        {
            txtfield_dog3.text = NSLocalizedString("2h", comment: "")
        }
        if txtfield_dog3.text == "9000.0"
        {
            txtfield_dog3.text = NSLocalizedString("2h30m", comment: "")
        }
        if txtfield_dog3.text == "10800.0"
        {
            txtfield_dog3.text = NSLocalizedString("3h", comment: "")
        }
        if txtfield_dog3.text == "12600.0"
        {
            txtfield_dog3.text = NSLocalizedString("3h30m", comment: "")
        }
        if txtfield_dog3.text == "14400.0"
        {
            txtfield_dog3.text = NSLocalizedString("4h", comment: "")
        }
        if txtfield_dog3.text == "16200.0"
        {
            txtfield_dog3.text = NSLocalizedString("4h30m", comment: "")
        }
        if txtfield_dog3.text == "18000.0"
        {
            txtfield_dog3.text = NSLocalizedString("5h", comment: "")
        }
        if txtfield_dog3.text == "19800.0"
        {
            txtfield_dog3.text = NSLocalizedString("5h30m", comment: "")
        }
        if txtfield_dog3.text == "21600.0"
        {
            txtfield_dog3.text = NSLocalizedString("6h", comment: "")
        }
        if txtfield_dog3.text == "23400.0"
        {
            txtfield_dog3.text = NSLocalizedString("6h30m", comment: "")
        }
        if txtfield_dog3.text == "25200.0"
        {
            txtfield_dog3.text = NSLocalizedString("7h", comment: "")
        }
    }
    
}
