//
//  ReadPremiumViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-08-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ReadPremiumViewController: UIViewController, GADBannerViewDelegate
{
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    @IBOutlet weak var titleOfPage: UINavigationItem!
    @IBOutlet weak var removeAds: UILabel!
    @IBOutlet weak var functions: UILabel!
    @IBOutlet weak var offers: UILabel!
    
    var premiumValue: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        translateCode()
        
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
    
    func translateCode()
    {
        titleOfPage.title = NSLocalizedString("ap-title", comment: "")
        removeAds.text = NSLocalizedString("ap-removeAds", comment: "")
        functions.text = NSLocalizedString("ap-moreFunctions", comment: "")
        offers.text = NSLocalizedString("ap-specialOffers", comment: "")
    }
    //Go back to previous page.
    @IBAction func goBack(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
