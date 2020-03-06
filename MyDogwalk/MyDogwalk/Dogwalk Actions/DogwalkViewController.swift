//
//  DogwalkViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications
import GoogleMobileAds

class DogwalkViewController: UIViewController, GADInterstitialDelegate
{
    var premiumValue: String!
    
    var dog = ""
    var person = ""
    var what = ""
    var cDate = ""
    var cTime = ""
    var timer = ""
    var kilometers = ""
    var note = ""
    
    var documentID: String!
    
    var DogBool = false
    var PersonBool = false
    var WhatBool = false
    var DatumBool = false
    var TimeBool = false
    
    //Indicator
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    //Declare the textfields
    @IBOutlet weak var txtfield_dog: UITextField!
    @IBOutlet weak var txtfield_person: UITextField!
    @IBOutlet weak var txtfield_what: UITextField!
    @IBOutlet weak var txtfield_Datum: UITextField!
    @IBOutlet weak var txtfield_Time: UITextField!
    @IBOutlet weak var newWalk: UISegmentedControl!
    @IBOutlet weak var txtfield_timer: UITextField!
    @IBOutlet weak var txtfield_km: UITextField!
    @IBOutlet weak var saveWalk: UIBarButtonItem!
    @IBOutlet weak var noteTxt: UITextField!
    @IBOutlet weak var clearFields: UIBarButtonItem!
    
    //Declare labels
    @IBOutlet weak var lbl_chooseDog: UILabel!
    @IBOutlet weak var lbl_choosePerson: UILabel!
    @IBOutlet weak var lbl_chooseWhat: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_moreWalks: UILabel!
    
    //Translate Toolbar
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var settings: UILabel!
    
    //Making sure you can't add dublicates
    var allowSave = false
    
    //Use Firestore to save the data
    let db = Firestore.firestore()
    
    var locations: [CLLocationCoordinate2D] = []
    
    var latitudes:[Double] = []
    var longitudes:[Double] = []
    
    //Retrieving URL from ImageViewController
     var imgURLarray:[String] = []
    
    //interstitial
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        premium()
        
        print(imgURLarray)
        
        //Hide indicator
        indicator.isHidden = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        { (didAllow, error) in
            
        }
        translateCode()
        
        latitudes = locations.map({ $0.latitude })
        longitudes = locations.map({ $0.longitude })
        
        //Inserting arrow
        insertDogArrow()
        insertPersonArrow()
        insertWhatArrow()
        insertDateArrow()
        insertTimeArrow()
        
        getValues()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
        let request = GADRequest()
        
        interstitial.load(request)
        interstitial.delegate = self
    }
    
    func premium()
    {
        let authentication = Auth.auth().currentUser?.uid
        
        //Choosing collection
        db.collection("users").document(authentication!).collection("Info")
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
                            
                            let data1 = data["premium"] as? String
                            
                            if data1 == "1"
                            {
                                UserDefaults.standard.set(data1, forKey: "premium")
                            }
                            else
                            {
                                UserDefaults.standard.set(data1, forKey: "premium")
                            }
                            
                        }
                    }
        }
    }
    
    //Translating the language
    func translateCode()
    {
        saveWalk.title = NSLocalizedString("dwSave", comment: "")
        lbl_chooseDog.text = NSLocalizedString("dwDog", comment: "")
        lbl_choosePerson.text = NSLocalizedString("dwPerson", comment: "")
        lbl_chooseWhat.text = NSLocalizedString("dwWhat", comment: "")
        lbl_date.text = NSLocalizedString("dwDate", comment: "")
        lbl_time.text = NSLocalizedString("dwTime", comment: "")
        lbl_moreWalks.text = NSLocalizedString("dwMore", comment: "")
        newWalk.setTitle(NSLocalizedString("dwSeg0", comment: ""), forSegmentAt: 0)
        newWalk.setTitle(NSLocalizedString("dwSeg1", comment: ""), forSegmentAt: 1)
        history.text = NSLocalizedString("history", comment: "")
        settings.text = NSLocalizedString("settings", comment: "")
        clearFields.title = NSLocalizedString("clearBtn", comment: "")
    }
    
    //-----------------------------------------------------------------
    //                 Insert UserDefault values into textfields
    //-----------------------------------------------------------------
    
    func getValues()
    {
        //Inserting values into UserDefaults for temporary save.
        if dog != ""
        {
            UserDefaults.standard.set(dog, forKey: "dogKey")
        }
        if person != ""
        {
            UserDefaults.standard.set(person, forKey: "personKey")
        }
        if what != ""
        {
            UserDefaults.standard.set(what, forKey: "whatKey")
        }
        if cDate != ""
        {
            UserDefaults.standard.set(cDate, forKey: "dateKey")
        }
        if cTime != ""
        {
            UserDefaults.standard.set(cTime, forKey: "timeKey")
        }

        if kilometers != ""
        {
            UserDefaults.standard.set(kilometers, forKey: "kmKey")
        }
        if timer != ""
        {
            UserDefaults.standard.set(timer, forKey: "timerKey")
        }
        if latitudes != []
        {
            UserDefaults.standard.set(latitudes, forKey: "latKey")
        }
        if longitudes != []
        {
            UserDefaults.standard.set(longitudes, forKey: "longKey")
        }
        //Camera userdefault is located in ImageViewController
        
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtfield_dog.text = UserDefaults.standard.value(forKey:"dogKey") as? String
        txtfield_person.text = UserDefaults.standard.value(forKey:"personKey") as? String
        txtfield_what.text = UserDefaults.standard.value(forKey:"whatKey") as? String
        txtfield_Datum.text = UserDefaults.standard.value(forKey: "dateKey") as? String
        txtfield_Time.text = UserDefaults.standard.value(forKey: "timeKey") as? String
        txtfield_km.text = UserDefaults.standard.value(forKey: "kmKey") as? String
        txtfield_timer.text = UserDefaults.standard.value(forKey: "timerKey") as? String
        latitudes = UserDefaults.standard.array(forKey: "latKey") as? [Double] ?? []
        longitudes = UserDefaults.standard.array(forKey: "longKey") as? [Double] ?? []
        
        noteTxt.text = UserDefaults.standard.value(forKey: "noteKey") as? String
        imgURLarray = UserDefaults.standard.array(forKey: "dl-url-key") as? [String] ?? []
    }
    
    //-----------------------------------------------------------
    //                 Buttons to change textfields text.
    //-----------------------------------------------------------
    
    //Choose dog textfield
    @IBAction func ChooseDogTextField(_ sender: Any)
    {
        txtfield_dog.inputView = UIView()
        DogBool = true
        txtfield_dog.endEditing(true)
        self.performSegue(withIdentifier: "chooseDog", sender: self)
    }
    //Choose person textfield
    @IBAction func ChoosePersonTextField(_ sender: Any)
    {
        txtfield_person.inputView = UIView()
        PersonBool = true
        txtfield_person.endEditing(true)
        self.performSegue(withIdentifier: "chooseDog", sender: self)
    }
    
    //Choose what textfield
    @IBAction func ChooseWhat(_ sender: Any)
    {
        txtfield_what.inputView = UIView()
        WhatBool = true
        txtfield_what.endEditing(true)
        self.performSegue(withIdentifier: "chooseDog", sender: self)
    }
    
    //Choose Datum textfield
    @IBAction func ChooseDatum(_ sender: Any)
    {
        txtfield_Datum.inputView = UIView()
        DatumBool = true
        txtfield_Datum.endEditing(true)
        self.performSegue(withIdentifier: "timeDate", sender: self)
    }
    
    //Choose Time textfield
    @IBAction func ChooseTime(_ sender: Any)
    {
        txtfield_Time.inputView = UIView()
        TimeBool = true
        txtfield_Time.endEditing(true)
        self.performSegue(withIdentifier: "timeDate", sender: self)
    }
    
    //-----------------------------------------------------------
    //                 Prepare for a segue
    //-----------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if DogBool == true
        {
            DogBool = false
            let vc = segue.destination as! DogViewController
            
            vc.DogBool = true
        }
        else if PersonBool == true
        {
            PersonBool = false
            let vc = segue.destination as! DogViewController
            
            vc.PersonBool = true
        }
        else if WhatBool == true
        {
            WhatBool = false
            let vc = segue.destination as! DogViewController
            
            vc.WhatBool = true
        }
        else if DatumBool == true
        {
            DatumBool = false
            let vc = segue.destination as! DateTimeViewController
            
            vc.Datum = true
            
        }
        else if TimeBool == true
        {
            TimeBool = false
            let vc = segue.destination as! DateTimeViewController
            
            vc.Time = true
        }
    }
    
    //-----------------------------------------------------------
    //                 Save walk
    //-----------------------------------------------------------
    @IBAction func SaveWalkTapped(_ sender: Any)
    {
        indicator.isHidden = false
        indicator.startAnimating()
        indicator.bringSubviewToFront(view)
        
        if allowSave == false
        {
            
            allowSave = true
            
            if (txtfield_dog.text?.isEmpty == true) ||
                (txtfield_person.text?.isEmpty == true) ||
                (txtfield_what.text?.isEmpty == true) ||
                (txtfield_Datum.text?.isEmpty == true) ||
                (txtfield_Time.text?.isEmpty == true){
                
                // create the alert
                let alert = UIAlertController(title: NSLocalizedString("fled", comment: ""), message: NSLocalizedString("allFields", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                self.allowSave = false
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                if txtfield_timer.text == ""
                {
                    txtfield_timer.text = "00:00:00"
                }
                if txtfield_km.text == ""
                {
                    txtfield_km.text = "0 m"
                }
                if latitudes == []
                {
                    latitudes.append(0.0)
                    print(latitudes)
                }
                if longitudes == []
                {
                    longitudes.append(0.0)
                    print(longitudes)
                }
                
                if txtfield_what.text == NSLocalizedString("whatDB", comment: ""){
                    saveAsShower()
                }
                else{
                    saveAsNormalWalk()
                }
            }
        }
    }
    
    func saveAsNormalWalk(){
        
        //Authentication -> Getting userID to insert into Firestore
        let authentication = Auth.auth().currentUser?.uid
        
        //Document Reference properties
        var _: DocumentReference = self.db
            //Collection into Subcollection & Documents
            .collection("rastad").document(authentication!)
            .collection("promenad").addDocument(data:
                //Insert first values
                ["Dog": txtfield_dog.text!,
                 "Person": txtfield_person.text!,
                 "What": txtfield_what.text!,
                 "Date": txtfield_Datum.text!,
                 "Time": txtfield_Time.text!,
                 "Timer": txtfield_timer.text!,
                 "Kilometers": txtfield_km.text!,
                 "Note": noteTxt.text as Any,
                 "latitude": latitudes,
                 "longitude": longitudes,
                 "imgUrl": imgURLarray
                ], completion: { (err) in
                    if let err = err
                    {
                        print("Error adding info-details", err.localizedDescription)
                        self.allowSave = false
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        return
                    }
                    else
                    {
                        print("Succeded!")
                        if self.newWalk.selectedSegmentIndex == 0{
                            self.removeUserDefaults()
                        }
                        else{
                            self.removeAllUserDefaults()
                        }
                        
                        if self.newWalk.selectedSegmentIndex == 1{
                            self.checkForAdvertisement()
                        }
                    }
            })
    }
    
    func saveAsShower(){
        //Authentication -> Getting userID to insert into Firestore
        let authentication = Auth.auth().currentUser?.uid
        
        //Document Reference properties
        var _: DocumentReference = self.db
            
            //Collection into Subcollection & Documents
            .collection("rastad").document(authentication!)
            .collection("duschBad").addDocument(data:
                //Insert first values
                ["Dog": txtfield_dog.text!,
                 "Person": txtfield_person.text!,
                 "What": txtfield_what.text!,
                 "Date": txtfield_Datum.text!,
                 "Time": txtfield_Time.text!,
                 "Timer": txtfield_timer.text!,
                 "Kilometers": txtfield_km.text!,
                 "Note": noteTxt.text as Any,
                 "latitude": latitudes,
                 "longitude": longitudes,
                 "imgUrl": imgURLarray
                    
                ], completion: { (err) in
                    if err != nil
                    {
                        print("Error adding info-details")
                        self.allowSave = false
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        return
                    }
                    else
                    {
                        print("Succeded!")
                        
                        if self.newWalk.selectedSegmentIndex == 0{
                            self.removeUserDefaults()
                        }
                        else{
                            self.removeAllUserDefaults()
                        }
                        
                        if self.newWalk.selectedSegmentIndex == 1{
                            self.checkForAdvertisement()
                        }
                    }
            })
    }
    func removeUserDefaults(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "dogKey")
        prefs.removeObject(forKey: "whatKey")
        prefs.removeObject(forKey: "noteKey")
        
        self.txtfield_dog.text = ""
        self.txtfield_what.text = ""
        self.allowSave = false
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    func removeAllUserDefaults(){
        
        //Removing all but person userdefaults
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "dogKey")
        prefs.removeObject(forKey: "whatKey")
        prefs.removeObject(forKey: "dateKey")
        prefs.removeObject(forKey: "timeKey")
        prefs.removeObject(forKey: "kmKey")
        prefs.removeObject(forKey: "timerKey")
        prefs.removeObject(forKey: "latKey")
        prefs.removeObject(forKey: "longKey")
        prefs.removeObject(forKey: "noteKey")
        prefs.removeObject(forKey: "dl-url-key")
        
        //Clearing textfields
        self.txtfield_dog.text = ""
        self.txtfield_what.text = ""
        self.txtfield_Datum.text = ""
        self.txtfield_Time.text = ""
        self.txtfield_timer.text = ""
        self.txtfield_km.text = ""
        newWalk.selectedSegmentIndex = 1
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    func checkForAdvertisement(){
        
        indicator.isHidden = true
        indicator.stopAnimating()
        
        //Advertisement test
        self.premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
        
        if self.premiumValue == "1"
        {
            self.goToHistoryViewController()
        }else{
            
            if self.interstitial.isReady{
                self.interstitial.present(fromRootViewController: self)
            }
            else
            {
                print("Advertisement is not ready!")
                self.goToHistoryViewController()
            }
        }
    }
    
    func goToHistoryViewController(){
        if let storyboard = self.storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true)
        }
    }
    
    //Clear all fields
    @IBAction func clearFields(_ sender: Any)
    {
        
        let alert = UIAlertController(title: NSLocalizedString("clearTitle", comment: ""), message: NSLocalizedString("clearBody", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        //Clearing the walk
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("clearRemove", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
            //Clearing all userdefaults
            self.removeAllUserDefaults()
            
        }))
        
        //Cancel
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("clearCancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
            return
        }))
        
        //Presentating alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        self.goToHistoryViewController()
    }
    
    
    //-------------------------------------------------------------------------------------------
    //------------------------------------NOTIFICATIONS------------------------------------------
    //---------------------------------------------------------------------------------
    var dogData1: String!
    var dogTimer: String!
    
    
    func loadDogs()
    {
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("dog").getDocuments()
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
                        
                        let data1 = data["name"] as? String
                        let data2 = data["timer"] as? String
                        
                        if self.txtfield_dog.text == data1
                        {
                            self.dogTimer = data2
                            self.dogData1 = data1
                            
                            self.notificationTimer = data2!
                            self.runNotification()
                        }
                    }
                }
        }
     }

    var notificationTimer: String!
    var notiDouble: Double!
    var hoursAgo: String!
    
    func runNotification()
    {
        
        notiDouble = Double(notificationTimer)!
        
        print("----------")
        print(notiDouble!)
        print("----------")
        
        //Converting seconds to hours to display in notification
        if(notiDouble == 864000022.0)
        {
            hoursAgo = NSLocalizedString("0h", comment: "")
        }
        else if(notiDouble == 1800.0)
        {
            hoursAgo = NSLocalizedString("30m", comment: "")
        }
        else if(notiDouble == 3600.0)
        {
            hoursAgo = NSLocalizedString("1h", comment: "")
        }
        else if(notiDouble == 5400.0)
        {
            hoursAgo = NSLocalizedString("1h30m", comment: "")
        }
        else if(notiDouble == 7200.0)
        {
            hoursAgo = NSLocalizedString("2h", comment: "")
        }
        else if(notiDouble == 9000.0)
        {
            hoursAgo = NSLocalizedString("2h30m", comment: "")
        }
        else if(notiDouble == 10800.0)
        {
            hoursAgo = NSLocalizedString("3h", comment: "")
        }
        else if(notiDouble == 12600.0)
        {
            hoursAgo = NSLocalizedString("3h30m", comment: "")
        }
        else if(notiDouble == 14400.0)
        {
            hoursAgo = NSLocalizedString("4h", comment: "")
        }
        else if(notiDouble == 16200.0)
        {
            hoursAgo = NSLocalizedString("4h30m", comment: "")
        }
        else if(notiDouble == 18000.0)
        {
            hoursAgo = NSLocalizedString("5h", comment: "")
        }
        else if(notiDouble == 19800.0)
        {
            hoursAgo = NSLocalizedString("5h30m", comment: "")
        }
        else if(notiDouble == 21600.0)
        {
            hoursAgo = NSLocalizedString("6h", comment: "")
        }
        else if(notiDouble == 23400.0)
        {
            hoursAgo = NSLocalizedString("6h30m", comment: "")
        }
        else if(notiDouble == 25200.0)
        {
            hoursAgo = NSLocalizedString("7h", comment: "")
        }
        else
        {
            print("went to else :(")
            hoursAgo = NSLocalizedString("0h", comment: "")
        }

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("TimeForNewWalk", comment: "")
       
        content.body = String(format: NSLocalizedString("Notkey", comment: ""), hoursAgo!, txtfield_dog.text!)
        
        print(content.body)

        content.badge = 1;
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notiDouble, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //-----------------------------------------------------------
    //                 Buttons for navigation
    //-----------------------------------------------------------
    
    @IBAction func addNoteTapped(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraView(_ sender: Any)
    {
        if imgURLarray != []
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                
                //Passing URL over to ImageViewController
                vc.downloadURL = imgURLarray
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func MapView(_ sender: Any)
    {
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    //Settings button tapped
    @IBAction func SettingsButtonTapped(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //History button tapped
    @IBAction func HistoryButtonTapped(_ sender: Any)
    {
        removeAllUserDefaults()
        self.goToHistoryViewController()
    }
    
    //---------------------------------------------------------------------------------
    //                 Add images into textfields. (In the buttom due to lots of code)
    //---------------------------------------------------------------------------------
    
    func insertDogArrow()
    {
        txtfield_dog.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_dog.frame.height / 2, height: txtfield_dog.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_dog.rightView = imageView
    }
    
    func insertPersonArrow()
    {
        txtfield_person.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_person.frame.height / 2, height: txtfield_person.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_person.rightView = imageView
    }
    
    func insertWhatArrow()
    {
        txtfield_what.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_what.frame.height / 2, height: txtfield_what.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_what.rightView = imageView
    }
    
    func insertDateArrow()
    {
        txtfield_Datum.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_Datum.frame.height / 2, height: txtfield_Datum.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_Datum.rightView = imageView
    }
    
    func insertTimeArrow()
    {
        txtfield_Time.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_Time.frame.height / 2, height: txtfield_Time.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_Time.rightView = imageView
    }
    
}
