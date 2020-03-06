//
//  ChooseTimerViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-16.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ChooseTimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate, GADInterstitialDelegate
{
    var premiumValue: String!
    //Advertisement banner declaration
    @IBOutlet weak var advertisementBanner: GADBannerView!
    //Declaring
    @IBOutlet weak var headerTitle: UINavigationItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!

    var editMode = false
    var rowID: Int!
    
    var timer1: String!
    
    var dogID: String!
    var db = Firestore.firestore()
    
    //Send string to original view
    var selectedData: String!
    
    //Array for choosing timer
    var timerArray: [String] = [
    NSLocalizedString("0h", comment: ""),
    NSLocalizedString("30m", comment: ""),
    NSLocalizedString("1h", comment: ""),
    NSLocalizedString("1h30m", comment: ""),
    NSLocalizedString("2h", comment: ""),
    NSLocalizedString("2h30m", comment: ""),
    NSLocalizedString("3h", comment: ""),
    NSLocalizedString("3h30m", comment: ""),
    NSLocalizedString("4h", comment: ""),
    NSLocalizedString("4h30m", comment: ""),
    NSLocalizedString("5h", comment: ""),
    NSLocalizedString("5h30m", comment: ""),
    NSLocalizedString("6h", comment: ""),
    NSLocalizedString("6h30m", comment: ""),
    NSLocalizedString("7h", comment: ""),
    ]
    
    //interstitial
    var interstitial: GADInterstitial!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 5.0
        
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
            
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
            let interRequest = GADRequest()
            
            interstitial.load(interRequest)
            
            interstitial.delegate = self
        }
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        if editMode == true
        {
            pickerView.selectRow(rowID, inComponent: 0, animated: true)
            pickerView.reloadAllComponents()
            rowID = pickerView.selectedRow(inComponent: 0)
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
        headerTitle.title = NSLocalizedString("chooseHeader", comment: "")
        saveButton.setTitle(NSLocalizedString("chooseSave", comment: ""), for: .normal)
    }
    
    //PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return timerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return timerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        rowID = pickerView.selectedRow(inComponent: 0)
    }
    
    //Button to save the timer
    @IBAction func saveButtonTapped(_ sender: Any)
    {
        convertRowIDtoTimer()
        
        //Advertisement test
        if self.interstitial.isReady
        {
            self.interstitial.present(fromRootViewController: self)
        }
        else
        {
            print("Advertisement is not ready!")
            self.performSegue(withIdentifier: "saveTimer", sender: self)
        }

    }

    
    //Advertisement will dismiss from the screen
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        self.performSegue(withIdentifier: "saveTimer", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if editMode == true
        {
            let vc = segue.destination as! AddDogViewController
            
            vc.editMode = true
            vc.timerStr = timer1
            vc.documentID = dogID
        }
        else
        {
            let vc = segue.destination as! AddDogViewController
            vc.timerStr = timer1
        }
        
    }
    
    //CONVERT INTO SECONDS
    func convertRowIDtoTimer()
    {
        if rowID == 0
        {
            timer1 = "864000022.0"
        }
        if rowID == 1
        {
            timer1 = "1800.0"
        }
        if rowID == 2
        {
            timer1 = "3600.0"
        }
        if rowID == 3
        {
            timer1 = "5400.0"
        }
        if rowID == 4
        {
            timer1 = "7200.0"
        }
        if rowID == 5
        {
            timer1 = "9000.0"
        }
        if rowID == 6
        {
            timer1 = "10800.0"
        }
        if rowID == 7
        {
            timer1 = "12600.0"
        }
        if rowID == 8
        {
            timer1 = "14400.0"
        }
        if rowID == 9
        {
            timer1 = "16200.0"
        }
        if rowID == 10
        {
            timer1 = "18000.0"
        }
        if rowID == 11
        {
            timer1 = "19800.0"
        }
        if rowID == 12
        {
            timer1 = "21600.0"
        }
        if rowID == 13
        {
            timer1 = "23400.0"
        }
        if rowID == 14
        {
            timer1 = "25200.0"
        }
    }
}
