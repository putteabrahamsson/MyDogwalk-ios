//
//  NoteViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-02.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NoteViewController: UIViewController, UITextViewDelegate, GADBannerViewDelegate
{
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var txtarea: UITextView!
    @IBOutlet weak var choose: UIBarButtonItem!
    @IBOutlet weak var addNote: UINavigationItem!
    
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    var premiumValue: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtarea.layer.cornerRadius = 5.0
        
        //txtfield_note.delegate = self
        txtarea.delegate = self
        
        translateCode()
        getValues()
        
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
    
    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    
    func translateCode()
    {
        noteLbl.text = NSLocalizedString("addNewNote", comment: "")
        addNote.title = NSLocalizedString("note-hdr", comment: "")
        choose.title = NSLocalizedString("note-choose", comment: "")
    }
    

    func getValues()
    {
        if txtarea.text != ""
        {
            UserDefaults.standard.set(txtarea.text, forKey: "noteKey")
        }
        
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtarea.text = UserDefaults.standard.value(forKey:"noteKey") as? String
    }
    
    @IBAction func choose(_ sender: Any)
    {
        getValues()
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            vc.note = txtarea.text!
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}
