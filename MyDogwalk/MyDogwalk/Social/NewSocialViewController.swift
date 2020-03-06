//
//  NewSocialViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-31.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewSocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, GADInterstitialDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var dogwalk: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var social: UILabel!
    @IBOutlet weak var more: UILabel!
    
    //Booleans
    var petstore = false
    var blog = false
    var profiles = false
    var channels = false
    var course = false
    var dogschoolBool = false
    var tipsNtricksBool = false
    
    var premiumValue: String!
    
    //Sections in the tableview
    var sections = [NSLocalizedString("social-partner", comment: ""), NSLocalizedString("social-links", comment: "")]
    
    //Images inside the sections
    var buttonImage =
        [
            [UIImage(named: "partnership")!],
            [UIImage(named: "shop")!, UIImage(named: "profiles")!, UIImage(named: "blog")!, UIImage(named: "channels")!, UIImage(named: "course")!, UIImage(named: "tips")!]
    ]
    //Titles inside the sections
    var buttonName =
        [
            [NSLocalizedString("social-partner", comment: "")],
            [NSLocalizedString("social-petstore", comment: ""), NSLocalizedString("social-profiles", comment: ""),  NSLocalizedString("social-blogs", comment: ""), NSLocalizedString("social-channels", comment: ""), NSLocalizedString("social-courses", comment: ""), NSLocalizedString("social-tipsTricks", comment: ""),]
    ]
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        translateCode()
        
        
        //Play-advertisement
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
        let interRequest = GADRequest()
        
        interRequest.testDevices = [ kGADSimulatorID]
        interstitial.load(interRequest)
        
        interstitial.delegate = self
        
        premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
        if premiumValue == "1"
        {
            print("No ads will be shown")
        }
        else
        {
            //Request Advertisement
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            
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
        topConstraint.constant = 0
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        topConstraint.constant = 100
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    
   func translateCode()
    {
        header.title = NSLocalizedString("socialHdr", comment: "")
        dogwalk.text = NSLocalizedString("dogwalk", comment: "")
        history.text = NSLocalizedString("history", comment: "")
        social.text = NSLocalizedString("social", comment: "")
        more.text = NSLocalizedString("settings", comment: "")
    }
    
    //------------------------------------------------------------------------
    //                        TABLEVIEW PROPORTIES
    //------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
            return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return buttonName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell", for: indexPath) as! NewSocialTableViewCell
        
        cell.buttonName.text = buttonName[indexPath.section][indexPath.row]
        cell.buttonImage.image = buttonImage[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Request about partnership
        if indexPath == [0, 0]
        {
            print("Partnership button tapped")
            let url = URL(string:NSLocalizedString("partnerLink", comment: ""))
            UIApplication.shared.open(url!, options: [:])
        }
        //Petstores
        if indexPath == [1, 0]
        {
            print("Petstores button tapped")
            
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                print("No ads will be shown")
                
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.petshop = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    petstore = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.petshop = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        //Profiles
        if indexPath == [1, 1]
        {
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                print("No ads will be shown")
                
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.profiles = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    profiles = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.profiles = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        //Blogs
        if indexPath == [1, 2]
        {
            print("Blogs button tapped")
            
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                print("No ads will be shown")
                
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.blog = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    blog = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.blog = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        
        //Channels
        if indexPath == [1, 3]
        {
            print("Youtube button tapped")
            
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                print("No ads will be shown")
                
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.channels = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    channels = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.channels = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        //Courses
        if indexPath == [1, 4]
        {
            print("Courses button tapped")
            
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.course = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    course = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.course = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        //Tips and Tricks
        if indexPath == [1, 5]
        {
            print("Tips and Tricks button tapped")
            
            premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
            if premiumValue == "1"
            {
                print("No ads will be shown")
                
                if let storyboard = storyboard
                {
                    print("Advertisement is not ready")
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                    
                    vc.dogSchool = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                if self.interstitial.isReady
                {
                    dogschoolBool = true
                    self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    if let storyboard = storyboard
                    {
                        print("Advertisement is not ready")
                        
                        let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                        
                        vc.dogSchool = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        if (petstore == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.petshop = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (blog == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.blog = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (profiles == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.profiles = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (channels == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.channels = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (dogschoolBool == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.dogSchool = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (course == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.course = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func history(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func more(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
