//
//  SocialViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-15.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SocialViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate
{
    //Translate
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var animalstore: UIButton!
    @IBOutlet weak var blogs: UIButton!
    @IBOutlet weak var insta: UIButton!
    @IBOutlet weak var face: UIButton!
    @IBOutlet weak var you: UIButton!
    @IBOutlet weak var dogschool: UIButton!
    @IBOutlet weak var lbl_history: UILabel!
    @IBOutlet weak var lbl_dogpass: UILabel!
    @IBOutlet weak var lbl_settings: UILabel!
    @IBOutlet weak var courses: UIButton!
    @IBOutlet weak var partner: UIBarButtonItem!
    
    
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    
    var petshop = false
    var blog = false
    var instagram = false
    var facebook = false
    var youtube = false
    var course = false
    var dogschoolBool = false
    var tipsNtricksBool = false
    
    //interstitial
    var interstitial: GADInterstitial!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        translateCode()
        
        //Play-advertisement
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
        let interRequest = GADRequest()
        
        interRequest.testDevices = [ kGADSimulatorID]
        interstitial.load(interRequest)
        
        interstitial.delegate = self
        
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
        header.title = NSLocalizedString("socialHeader", comment: "")
        lbl_history.text = NSLocalizedString("history", comment: "")
        lbl_dogpass.text = NSLocalizedString("social", comment: "")
        lbl_settings.text = NSLocalizedString("settings", comment: "")
        
        partner.title = NSLocalizedString("partner", comment: "")
        
        animalstore.setTitle(NSLocalizedString("animalstore", comment: ""), for: .normal)
        blogs.setTitle(NSLocalizedString("blogs", comment: ""), for: .normal)
        insta.setTitle(NSLocalizedString("insta", comment: ""), for: .normal)
        face.setTitle(NSLocalizedString("face", comment: ""), for: .normal)
        you.setTitle(NSLocalizedString("you", comment: ""), for: .normal)
        dogschool.setTitle(NSLocalizedString("dogschool", comment: ""), for: .normal)
         courses.setTitle(NSLocalizedString("courses", comment: ""), for: .normal)
    
    }
    
    //Petstore
    @IBAction func petstore(_ sender: Any)
    {
        if self.interstitial.isReady
        {
            petshop = true
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
    
    //Blogs
    @IBAction func blogs(_ sender: Any)
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
    
    //Instagram
    @IBAction func instagram(_ sender: Any)
    {
        if self.interstitial.isReady
        {
            instagram = true
            self.interstitial.present(fromRootViewController: self)
        }
        else
        {
            if let storyboard = storyboard
            {
                print("Advertisement is not ready")
                
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.instagram = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //Facebook
    @IBAction func facebook(_ sender: Any)
    {
        if self.interstitial.isReady
        {
            facebook = true
            self.interstitial.present(fromRootViewController: self)
        }
        else
        {
            if let storyboard = storyboard
            {
                print("Advertisement is not ready")
                
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.facebook = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //Youtube
    @IBAction func youtube(_ sender: Any)
    {
        if self.interstitial.isReady
        {
            youtube = true
            self.interstitial.present(fromRootViewController: self)
        }
        else
        {
            if let storyboard = storyboard
            {
                print("Advertisement is not ready")
                
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.youtube = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    //Dogschool
    @IBAction func DogSchool(_ sender: Any)
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
    
    //Courses
    @IBAction func Courses(_ sender: Any)
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
    
    
    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        if (petshop == true)
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
        
        if (instagram == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.instagram = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (facebook == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.facebook = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (youtube == true)
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PetStoreViewController") as! PetStoreViewController
                
                vc.youtube = true
                
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
    
    //Become a partner
    @IBAction func partnership(_ sender: Any)
    {
        let url = URL(string: NSLocalizedString("partnerLink", comment: ""))
        UIApplication.shared.open(url!, options: [:])
    }
    
    @IBAction func Dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func History(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func Settings(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
