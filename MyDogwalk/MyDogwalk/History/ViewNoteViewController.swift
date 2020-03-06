//
//  ViewNoteViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-02.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewNoteViewController: UIViewController, GADBannerViewDelegate
{
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var header: UINavigationItem!
    
    var note: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        if note != ""
        {
            textArea.text = note
        }
        else
        {
            textArea.text = NSLocalizedString("noData", comment: "")
        }
        
        //Request Advertisement
        let request = GADRequest()
        
        //Set up advertisement
        advertisementBanner.adUnitID = "ca-app-pub-7225493999040026/4779408290"
        
        advertisementBanner.rootViewController = self
        advertisementBanner.delegate = self
        advertisementBanner.load(request)
    }
    
    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    
    //--------------------------------------------------------------------------------
    //                                 Translate code
    //--------------------------------------------------------------------------------
    func translateCode()
    {
        header.title = NSLocalizedString("noteHeader", comment: "")
    }
}
