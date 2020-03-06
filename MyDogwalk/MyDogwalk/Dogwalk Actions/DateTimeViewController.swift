//
//  DateTimeViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-25.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DateTimeViewController: UIViewController, GADBannerViewDelegate
{
    //Banner for advertisement
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    //Declaring the DatePicker
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    @IBOutlet weak var changeHeader: UINavigationItem!
    @IBOutlet weak var save: UIButton!
    
    var premiumDate = false
    var premiumValue: String!
    
    var Datum = false
    var Time = false
    var DateTime = false
    
    var cDatum = ""
    var cTime = ""
    var cDateTime = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Adding radius of button
        save.layer.cornerRadius = 5.0

        translateCode()
        
        if Datum == true
        {
            changeHeader.title = NSLocalizedString("dateTitle", comment: "")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            cDatum = formatter.string(from: DateTimePicker.date)
            
            DateTimePicker.datePickerMode = .date
        }
        if Time == true
        {
            changeHeader.title = NSLocalizedString("timeTitle", comment: "")
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cTime = formatter.string(from: DateTimePicker.date)
            
            DateTimePicker.datePickerMode = .time
        }
        if DateTime == true
        {
            changeHeader.title = NSLocalizedString("dateTimeTitle", comment: "")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            cDateTime = formatter.string(from: DateTimePicker.date)
            
            DateTimePicker.datePickerMode = .dateAndTime
        }
        
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
    
    //Translating the language
    func translateCode()
    {
        save.setTitle(NSLocalizedString("dateTimeSave", comment: ""), for: .normal)
        DateTimePicker.locale = NSLocale.init(localeIdentifier: NSLocalizedString("dateLocale", comment: "")) as Locale
    }
    
    //-----------------------------------------------------------
    //      Checking if time / date has been changed
    //-----------------------------------------------------------
    
    @IBAction func ifChanged(_ sender: Any)
    {
        if Datum == true
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            cDatum = formatter.string(from: DateTimePicker.date)
        }
        if Time == true
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cTime = formatter.string(from: DateTimePicker.date)
        }
        if DateTime == true
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            cDateTime = formatter.string(from: DateTimePicker.date)
            
            print(DateTimePicker.date)
        }
    }
    
    //-----------------------------------------------------------
    //            Save date / time and go back
    //----------------------------------------------------------
    
    @IBAction func Save(_ sender: Any)
    {
        if premiumDate == true
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "NewHealthViewController") as! NewHealthViewController
                
                vc.cDate = cDateTime
                vc.exactDate = DateTimePicker.date
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else
        {
            self.performSegue(withIdentifier: "saveDateTime", sender: self)
        }
    }
    
    //-----------------------------------------------------------
    //                 Prepare for a segue
    //-----------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if Datum == true
        {
            let vc = segue.destination as! DogwalkViewController
            
            vc.cDate = cDatum
        }
        if Time == true
        {
            let vc = segue.destination as! DogwalkViewController

            vc.cTime = cTime
        }
    }
    
    
}
