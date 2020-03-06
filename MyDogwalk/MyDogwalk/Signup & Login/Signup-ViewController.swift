//
//  Signup-ViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-20.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class Signup_ViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    var dateRegistered: String!
    
    //Translate
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_password: UILabel!
    @IBOutlet weak var lbl_repeatPassword: UILabel!
    @IBOutlet weak var terms: UIButton!
    @IBOutlet weak var btn_clear: UIBarButtonItem!
    
    //Terms
    @IBOutlet weak var termsTxt: UILabel!
    @IBOutlet weak var acceptTerms: UISwitch!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //Email
    @IBOutlet weak var txtfield_email: UITextField!
    //Password
    @IBOutlet weak var txtfield_password: UITextField!
    @IBOutlet weak var txtfield_repeat: UITextField!
    
    //Button for register
    @IBOutlet weak var btn_register: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_register.layer.cornerRadius = 5.0
        
        activity.isHidden = true
        
        txtfield_email.delegate = self
        txtfield_password.delegate = self
        txtfield_repeat.delegate = self
        
        getValues()
        
        translateCode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Get current date to save
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateRegistered = formatter.string(from: date)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if self.view.frame.origin.y != 0
        {
            self.view.frame.origin.y = 0
        }
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }

    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("regTitle", comment: "")
        lbl_email.text = NSLocalizedString("regEmail", comment: "")
        lbl_password.text = NSLocalizedString("regPass", comment: "")
        lbl_repeatPassword.text = NSLocalizedString("regRepeat", comment: "")
        
        termsTxt.text = NSLocalizedString("termsTxt", comment: "")
        
        terms.setTitle(NSLocalizedString("profileTerms", comment: ""), for: .normal)
        
        btn_clear.title = NSLocalizedString("clearBtn", comment: "")
    }
    
    //Button (Register) tapped.
    @IBAction func btn_registerTapped(_ sender: Any)
    {
        if acceptTerms.isOn == true{
            activity.isHidden = false
            activity.startAnimating()
            
            //If textfields are empty
            if (txtfield_password.text?.isEmpty)! || (txtfield_email.text?.isEmpty) == true
            {
                let alert = UIAlertController(title: NSLocalizedString("missingTitle", comment: ""), message: NSLocalizedString("missingContent", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                activity.isHidden = true
                activity.stopAnimating()
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }

            //PASSWORD IS LESS THAN 6
            else if (txtfield_password.text!.count < 6)
            {
                let alert = UIAlertController(title: NSLocalizedString("missingTitle", comment: ""), message: NSLocalizedString("lessThan6", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                activity.isHidden = true
                activity.stopAnimating()
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                //If password = repeat password
                if txtfield_password.text == txtfield_repeat.text
                {
                    //Create a new user with txtfield email & password
                    Auth.auth().createUser(withEmail: txtfield_email.text!, password: txtfield_password.text!)
                    { authResult, error in
                        
                        //Printing error if any
                        if error != nil
                        {
                            
                            let alert = UIAlertController.init(title: NSLocalizedString("badTitle", comment: ""), message: error as? String, preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            print(error as Any)
                            return
                        }
                        
                        //Authentication -> Getting userID to insert into Firestore
                        let authentication = Auth.auth().currentUser?.uid
                        
                        //Document Reference properties
                        var _: DocumentReference = self.db
                            
                            //Collection into Subcollection & Documents
                            .collection("users").document(authentication!)
                            .collection("Info").addDocument(data:
                                //Insert first values
                                [
                                    "Email": self.txtfield_email.text!,
                                    "Date": self.dateRegistered!,
                                    "premium": "0"
                                ], completion: { (err) in
                                    if err != nil
                                    {
                                        print("Error adding info-details")
                                        self.activity.isHidden = true
                                        self.activity.stopAnimating()
                                        return
                                    }
                                    else
                                    {
                                        print("Succeded!")
                                        
                                        let prefs = UserDefaults.standard
                                        prefs.removeObject(forKey: "regEmailKey")
                                        prefs.removeObject(forKey: "regPassKey")
                                        prefs.removeObject(forKey: "regRepeatKey")
                                        
                                        
                                        self.signMeIn()
                                    }
                            })
                    }
                }
                else
                {
                    let alert = UIAlertController(title: NSLocalizedString("missingTitle", comment: ""), message: NSLocalizedString("noMatch1", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else{
            print("You have to accept the terms first!")
        }
        
    }
    
    func signMeIn()
    {
        Auth.auth().signIn(withEmail: txtfield_email.text!, password: txtfield_password.text!)
        {
            [weak self] user, error in
            
            if user != nil
            {
                self!.activity.isHidden = true
                self!.activity.stopAnimating()
                
                if let storyboard = self?.storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
                    
                    self!.present(vc, animated: true, completion: nil)
                }
            }
            else
            {
                self!.activity.isHidden = true
                self!.activity.stopAnimating()
                
                // create the alert
                let alert = UIAlertController(title: NSLocalizedString("ftl", comment: ""), message: NSLocalizedString("wep", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

        getValues()
        
    }
    
    //-----------------------------------------------------------------
    //                 Insert UserDefault values into textfields
    //-----------------------------------------------------------------
    
    func getValues()
    {
        if txtfield_email.text != ""
        {
            UserDefaults.standard.set(txtfield_email.text, forKey: "regEmailKey")
        }
        if txtfield_password.text != ""
        {
            UserDefaults.standard.set(txtfield_password.text, forKey: "regPassKey")
        }
        if txtfield_repeat.text != ""
        {
            UserDefaults.standard.set(txtfield_repeat.text, forKey: "regRepeatKey")
        }
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtfield_email.text = UserDefaults.standard.value(forKey:"regEmailKey") as? String
        txtfield_password.text = UserDefaults.standard.value(forKey:"regPassKey") as? String
        txtfield_repeat.text = UserDefaults.standard.value(forKey:"regRepeatKey") as? String
    }
    
    
    @IBAction func clearAll(_ sender: Any)
    {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "regEmailKey")
        prefs.removeObject(forKey: "regPassKey")
        prefs.removeObject(forKey: "regRepeatKey")
        
        txtfield_email.text = ""
        txtfield_password.text = ""
        txtfield_repeat.text = ""
    }
    //Hiding keyboard when pressing somewhere else.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtfield_email.resignFirstResponder()
        txtfield_password.resignFirstResponder()
        txtfield_repeat.resignFirstResponder()
    }
    
    @IBAction func terms(_ sender: Any)
    {
        let url = URL(string: NSLocalizedString("termsLink", comment: ""))
        UIApplication.shared.open(url!, options: [:])
    }
    
}


