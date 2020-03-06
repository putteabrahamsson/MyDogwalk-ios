//
//  Login-ViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-19.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class Login_ViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {

    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var txtfield_user: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
    
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_password: UILabel!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var forgotpass: UIButton!
    @IBOutlet weak var btn_register: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_login.layer.cornerRadius = 5.0
        
        txtfield_user.delegate = self
        txtfield_password.delegate = self
        
        //Translating the code
        translateCode()
        
        //Adding small images  in the textfields.
        insertEmailLogo()
        insertPassLogo()
        
        //Request
        let request = GADRequest()
        
        //Set up advertisement
        advertisementBanner.adSize = kGADAdSizeSmartBannerPortrait
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
        btn_login.setTitle(NSLocalizedString("btnLogin", comment: "Login button of the index page"), for: .normal)
        btn_register.setTitle(NSLocalizedString("btnRegister", comment: "Login button of the index page"), for: .normal)
        lbl_email.text = NSLocalizedString("LoginEmail", comment: "")
        lbl_password.text = NSLocalizedString("LoginPassword", comment: "")
        header.title = NSLocalizedString("LoginTitle", comment: "")
        forgotpass.setTitle(NSLocalizedString("LoginForgotPass", comment: ""), for: .normal)
    }
    
    @IBAction func btn_login(_ sender: Any)
    {
        Auth.auth().signIn(withEmail: txtfield_user.text!, password: txtfield_password.text!)
        {
            [weak self] user, error in
            
            if user != nil
            {
                self?.performSegue(withIdentifier: "LogMeIn", sender: self)
            }
            else
            {
                // create the alert
                let alert = UIAlertController(title: NSLocalizedString("ftl", comment: ""), message: NSLocalizedString("wep", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func ForgotPass(_ sender: Any)
    {
        self.performSegue(withIdentifier: "forgot", sender: self)
    }
    
    
    func insertEmailLogo()
    {
        txtfield_user.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "user")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_user.frame.height / 2, height: txtfield_user.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_user.rightView = imageView
    }
    func insertPassLogo()
    {
        txtfield_password.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "password")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: txtfield_password.frame.height / 2, height: txtfield_password.frame.height / 2)
        view.addSubview(imageView)
        
        txtfield_password.rightView = imageView
    }
    
    //Hiding keyboarding when touching outside text.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtfield_user.resignFirstResponder()
        txtfield_password.resignFirstResponder()
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    
}
