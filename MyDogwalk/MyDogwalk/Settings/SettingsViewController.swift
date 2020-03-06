//
//  SettingsViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-26.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMobileAds

class SettingsViewController: UIViewController, GADBannerViewDelegate
{
    //Banner for advertisement
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    //Translate
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var cpBtn: UIButton!
    @IBOutlet weak var btn_logout: UIButton!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var dogpass: UILabel!
    @IBOutlet weak var settings: UILabel!
    @IBOutlet weak var news: UIBarButtonItem!
    @IBOutlet weak var rateUs: UIButton!
    
    @IBOutlet weak var addPerson: UIButton!
    @IBOutlet weak var addDog: UIButton!
    
    var person = false
    var dog = false
    
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
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("settingsHeader", comment: "")
        history.text = NSLocalizedString("history", comment: "")
        dogpass.text = NSLocalizedString("social", comment: "")
        settings.text = NSLocalizedString("settings", comment: "")
        profileBtn.setTitle(NSLocalizedString("profile1", comment: ""), for: .normal)
        cpBtn.setTitle(NSLocalizedString("changePass1", comment: ""), for: .normal)
        addPerson.setTitle(NSLocalizedString("addPersonX", comment: ""), for: .normal)
        addDog.setTitle(NSLocalizedString("addDogX", comment: ""), for: .normal)
        btn_logout.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        news.title = NSLocalizedString("settingsNews", comment: "")
        rateUs.setTitle(NSLocalizedString("rateUs", comment: ""), for: .normal)
    }
    
    
    //-----------------------------------------------------------
    //                 Settings navigation menu
    //-----------------------------------------------------------
    
    
    @IBAction func NewsTapped(_ sender: Any)
    {
        let url = URL(string: NSLocalizedString("newsLink", comment: ""))
        UIApplication.shared.open(url!, options: [:])
    }
    
    @IBAction func myProfile(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    

    
    //Change password button tapped
    @IBAction func ChangePassword(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }

    
    @IBAction func dogsTapped(_ sender: Any)
    {
        dog = true
        self.performSegue(withIdentifier: "personDog", sender: self)
    }
    
    @IBAction func personTapped(_ sender: Any)
    {
        person = true
        self.performSegue(withIdentifier: "personDog", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if dog == true
        {
            let vc = segue.destination as! AddNewViewController
            vc.dog = true
        }
        if person == true
        {
            let vc = segue.destination as! AddNewViewController
            vc.human = true
        }
    }
    
    //Rate our application on App Store
    @IBAction func rateUsTapped(_ sender: Any)
    {
        let url = URL(string: "https://itunes.apple.com/se/app/mydogwalk/id1464139139?mt=8")
        UIApplication.shared.open(url!, options: [:])
    }
    
    
    
    //-----------------------------------------------------------
    //                 Logout button tapped
    //-----------------------------------------------------------
    @IBAction func LogoutButtonTapped(_ sender: Any)
    {
        //Creating an alert message function, to check weather the user wanna logout or not.
        let alert = UIAlertController(title: NSLocalizedString("logme", comment: ""), message: NSLocalizedString("logSure", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        //Adding button "Logga ut"
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout", comment: ""), style: UIAlertAction.Style.default, handler:
            { (UIAlertAction) in
            
                //If button tapped -> Using authentication to logout user.
                try! Auth.auth().signOut()
                
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! ViewController
                    
                    self.present(vc, animated: false, completion: nil)
                }
        }))
        
        //Adding button "Avbryt"
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel, handler:
            { (UIAlertAction) in
                
            //If user press button "Avbryt", keep user logged in
            print("Cancelled logout")
        }))
        
        //Presentating the alert-message
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //-----------------------------------------------------------
    //                 Buttons for navigation
    //-----------------------------------------------------------
    
    //Take user to homepage (Dogwalk)
    @IBAction func MyDogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //Take user to history (Historik)
    @IBAction func Historik(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    //Take user to Hundpass
    @IBAction func Dogpass(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
}
