//
//  ChangePassViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ChangePassViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate
{
    var premiumValue: String!
    
    //Translate
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var pass: UILabel!
    @IBOutlet weak var pass1: UILabel!
    @IBOutlet weak var passSegment: UISegmentedControl!
    @IBOutlet weak var btn_change: UIBarButtonItem!
    
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var repeatPass: UITextField!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        translateCode()
        
        newPass.delegate = self
        repeatPass.delegate = self
        
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7225493999040026/7170494261")
        let request = GADRequest()
        
        interstitial.load(request)
        
        interstitial.delegate = self
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("cpHeader", comment: "")
        pass.text = NSLocalizedString("cpPass", comment: "")
        pass1.text = NSLocalizedString("cpPassRepeat", comment: "")
        
        passSegment.setTitle(NSLocalizedString("cpSeg0", comment: ""), forSegmentAt: 0)
        passSegment.setTitle(NSLocalizedString("cpSeg1", comment: ""), forSegmentAt: 1)
        
        btn_change.title = NSLocalizedString("cpChange", comment: "")
    }
    
    //-----------------------------------------------------------
    //                 Change user password
    //-----------------------------------------------------------
    
    @IBOutlet weak var segment: UISegmentedControl!
    //Hiding / showing password
    @IBAction func hideOrShowPass(_ sender: Any)
    {
        if segment.selectedSegmentIndex == 0
        {
            newPass.isSecureTextEntry = false
            repeatPass.isSecureTextEntry = false
        }
        else if segment.selectedSegmentIndex == 1
        {
            newPass.isSecureTextEntry = true
            repeatPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        if newPass.text == repeatPass.text
        {
            Auth.auth().currentUser?.updatePassword(to: newPass.text!, completion: { (err) in
                //If any error occured
                if err != nil
                {
                    
                    let alert = UIAlertController(title: NSLocalizedString("fled", comment: ""), message: NSLocalizedString("secure", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                    //If password successfully changed
                else
                {
                    self.premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
                    
                    if self.premiumValue == "1"
                    {
                        let alert = UIAlertController(title: NSLocalizedString("succededHeader", comment: ""), message: NSLocalizedString("succeded", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        if self.interstitial.isReady
                        {
                            self.interstitial.present(fromRootViewController: self)
                        }
                    }
                }
            })
        }
            //If password dosent match eachother.
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("fled", comment: ""), message: NSLocalizedString("noMatch", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Advertisement is dismissed
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        let alert = UIAlertController(title: NSLocalizedString("succededHeader", comment: ""), message: NSLocalizedString("succeded", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        newPass.text = ""
        repeatPass.text = ""
    }
    //-----------------------------------------------------------
    //                 Hide keyboard when done writing
    //-----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //Resigning responder to hide keyboard
        newPass.resignFirstResponder()
        repeatPass.resignFirstResponder()
    }
}
