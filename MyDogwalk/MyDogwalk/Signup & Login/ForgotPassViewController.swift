//
//  ForgotPassViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-07.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class ForgotPassViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate
{

    @IBOutlet weak var ForgotPass_title: UINavigationItem!
    @IBOutlet weak var btn_resetPass: UIButton!
    @IBOutlet weak var lbl_email: UILabel!

    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_resetPass.layer.cornerRadius = 5.0
        
        email.delegate = self
        
        translateCode()

        //Request
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

    
    //Translating the language
    func translateCode()
    {
        btn_resetPass.setTitle(NSLocalizedString("btnResetPass", comment: ""), for: .normal)
        lbl_email.text = NSLocalizedString("ForgotEmail", comment: "")
        ForgotPass_title.title = NSLocalizedString("ForgotPassTitle", comment: "")
    }
    
    @IBAction func ResetPassword(_ sender: Any)
    {
        Auth.auth().sendPasswordReset(withEmail: email.text!) { (err) in
            if err != nil
            {
                // create the alert
                let alert = UIAlertController(title: "Misslyckades", message: "Kontrollera din email address och försök igen!", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                // create the alert
                let alert = UIAlertController(title: "Lösenord skickat", message: "Ett nytt lösenord har skickats till " + self.email.text!, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Hiding keyboarding when touching outside text.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        email.resignFirstResponder()
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
}
