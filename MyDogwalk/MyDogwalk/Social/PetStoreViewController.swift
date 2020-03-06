//
//  PetStoreViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-15.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PetStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate
{
    //Translate
    @IBOutlet weak var goBack: UIBarButtonItem!
    @IBOutlet weak var historik: UILabel!
    @IBOutlet weak var dogpass: UILabel!
    @IBOutlet weak var settings: UILabel!
    
    //Banner for advertisement
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Arrays
    var businessName:[String] = ["Apply today!"]
    var businessWeb:[String] = ["www.MyDogwalk.se"]
    var businessImg:[UIImage] = [UIImage(named: "noImage")!]
    
    var blogName:[String] = ["MalleTheMalinois"]
    var blogWeb:[String] = ["https://mallethemalinois.wordpress.com"]
    var blogImg:[UIImage] = [UIImage(named: "malle")!]
    
    var instaName:[String] = ["MalleTheMalinois"]
    var instaWeb:[String] = [NSLocalizedString("fmi", comment: "")]
    var instaImg:[UIImage] = [UIImage(named: "malle")!]
    
    var youtubeName:[String] = ["Apply today!"]
    var youtubeWeb:[String] = ["www.MyDogwalk.se"]
    var youtubeImg:[UIImage] = [UIImage(named: "noImage")!]
    
    var courseName:[String] = ["Apply today!"]
    var courseCoupon:[String] = ["Coupong"]
    var courseImg:[UIImage] = [UIImage(named: "noImage")!]
    
    var schoolName:[String] = ["Apply today!"]
    var schoolCoupon:[String] = ["Coupong"]
    var schoolImg:[UIImage] = [UIImage(named: "noImage")!]
    
    //Retrieve boolean values
    var petshop = false
    var blog = false
    var profiles = false
    var channels = false
    var course = false
    var dogSchool = false
    
    var premiumValue: String!
    
    //Navigation title
    @IBOutlet weak var navTitle: UINavigationItem!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        if petshop == true
        {
            navTitle.title = NSLocalizedString("store", comment: "")
        }
        if blog == true
        {
            navTitle.title = NSLocalizedString("blog", comment: "")
        }
        if profiles == true
        {
            navTitle.title = NSLocalizedString("profiles", comment: "")
        }
        if channels == true
        {
            navTitle.title = NSLocalizedString("channel", comment: "")
        }
        if course == true
        {
            navTitle.title = NSLocalizedString("course", comment: "")
        }
        if dogSchool == true
        {
            navTitle.title = NSLocalizedString("dogschool", comment: "")
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        advertisementBanner.clipsToBounds = true
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
    
    //Translating the language
    func translateCode()
    {
        historik.text = NSLocalizedString("history", comment: "")
        dogpass.text = NSLocalizedString("social", comment: "")
        settings.text = NSLocalizedString("settings", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if petshop == true
        {
           return businessName.count
        }
        if blog == true
        {
            return blogName.count
        }
        if profiles == true
        {
            return instaName.count
        }
        if channels == true
        {
            return youtubeName.count
        }
        if course == true
        {
            return courseName.count
        }
        if dogSchool == true
        {
            return schoolName.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PetTableViewCell
        
        if petshop == true
        {
            let Name = self.businessName[indexPath.row]
            let Website = self.businessWeb[indexPath.row]
            let Image = self.businessImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        if blog == true
        {
            let Name = self.blogName[indexPath.row]
            let Website = self.blogWeb[indexPath.row]
            let Image = self.blogImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        if profiles == true
        {
            let Name = self.instaName[indexPath.row]
            let Website = self.instaWeb[indexPath.row]
            let Image = self.instaImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        if channels == true
        {
            let Name = self.youtubeName[indexPath.row]
            let Website = self.youtubeWeb[indexPath.row]
            let Image = self.youtubeImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        if course == true
        {
            let Name = self.courseName[indexPath.row]
            let Website = self.courseCoupon[indexPath.row]
            let Image = self.courseImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        if dogSchool == true
        {
            let Name = self.schoolName[indexPath.row]
            let Website = self.schoolCoupon[indexPath.row]
            let Image = self.schoolImg[indexPath.row]
            
            cell.businessName.text = Name
            cell.businessWebsite.text = Website
            cell.businessImage.image = Image
        }
        
        return cell
    }
    
    //If a tablecell is clicked. Open URL depend on indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // ------------------------------ STORES -----------------------------
        if petshop == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://mydogwalk.se")
                UIApplication.shared.open(url!, options: [:])
            }
        }
        // ------------------------------ BLOGS -----------------------------
        if blog == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://mallethemalinois.wordpress.com")
                UIApplication.shared.open(url!, options: [:])
            }
        }
        // ------------------------------ INSTAGRAM -----------------------------
        if profiles == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://www.instagram.com/mallethemalinois/?hl=en")
                UIApplication.shared.open(url!, options: [:])
            }
        }
        // ------------------------------ YOUTUBE -----------------------------
        if channels == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://www.MyDogwalk.se")
                UIApplication.shared.open(url!, options: [:])
            }
        }
        
        // ------------------------------ COURSES -----------------------------
        if course == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://www.MyDogwalk.se")
                UIApplication.shared.open(url!, options: [:])
            }
        }
        // ------------------------------ DOGSCHOOL (TIPS N TRICKS) -----------------------------
        if dogSchool == true
        {
            if indexPath == [0, 0]
            {
                let url = URL(string: "https://www.MyDogwalk.se")
                UIApplication.shared.open(url!, options: [:])
            }
        }
    }
    
    //----------------------------------------------------
    // Buttons for navigation
    //----------------------------------------------------
    @IBAction func goBack(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "NewSocialViewController") as! NewSocialViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //Dogwalk
    @IBAction func Dogwalk(_ sender: Any)
    {
        print("Dogwalk button tapped")
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //History
    @IBAction func History(_ sender: Any)
    {
        print("History button tapped")
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //Settings
    @IBAction func Settings(_ sender: Any)
    {
        print("More button tapped")
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
