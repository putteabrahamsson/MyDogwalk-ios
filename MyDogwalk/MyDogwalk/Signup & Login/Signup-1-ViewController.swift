//
//  Signup-1-ViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-20.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class Signup_1_ViewController: UIViewController, UITextFieldDelegate
{
    var goBack = false
    
    var password = ""
    var email = ""
    
    //Translate
    @IBOutlet weak var reg1Back: UIBarButtonItem!
    @IBOutlet weak var reg1header: UINavigationItem!
    @IBOutlet weak var reg1person1: UILabel!
    @IBOutlet weak var reg1person2: UILabel!
    @IBOutlet weak var reg1person3: UILabel!
    @IBOutlet weak var reg1person4: UILabel!
    @IBOutlet weak var reg1person5: UILabel!
    @IBOutlet weak var reg1person6: UILabel!
    @IBOutlet weak var reg1next: UIButton!
    @IBOutlet weak var clear: UIBarButtonItem!
    
    
    
    @IBOutlet weak var txtfield_name1: UITextField!
    @IBOutlet weak var txtfield_name2: UITextField!
    @IBOutlet weak var txtfield_name3: UITextField!
    @IBOutlet weak var txtfield_name4: UITextField!
    @IBOutlet weak var txtfield_name5: UITextField!
    @IBOutlet weak var txtfield_name6: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtfield_name1.delegate = self
        txtfield_name2.delegate = self
        txtfield_name3.delegate = self
        txtfield_name4.delegate = self
        txtfield_name5.delegate = self
        txtfield_name6.delegate = self

        getValues()
        translateCode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        reg1Back.title = NSLocalizedString("reg1GoBack", comment: "")
        reg1header.title = NSLocalizedString("reg1Title", comment: "")
        reg1person1.text = NSLocalizedString("reg1person", comment: "")
        reg1person2.text = NSLocalizedString("reg1person", comment: "")
        reg1person3.text = NSLocalizedString("reg1person", comment: "")
        reg1person4.text = NSLocalizedString("reg1person", comment: "")
        reg1person5.text = NSLocalizedString("reg1person", comment: "")
        reg1person6.text = NSLocalizedString("reg1person", comment: "")
        reg1next.setTitle(NSLocalizedString("reg1Next", comment: ""), for: .normal)
        clear.title = NSLocalizedString("clearBtn", comment: "")
    }
    
    //When pressing the button "Next"
    @IBAction func register3(_ sender: Any)
    {
        if(txtfield_name1.text?.isEmpty) == true
        {
            let alert = UIAlertController(title: NSLocalizedString("onePerTitle", comment: ""), message: NSLocalizedString("onePer", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("OKreg", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "Register3", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if goBack == false
        {
            getValues()
            
            let vc = segue.destination as! Signup_2_ViewController
            
            vc.password = password
            vc.email = email
            vc.name1 = txtfield_name1.text!
            vc.name2 = txtfield_name2.text!
            vc.name3 = txtfield_name3.text!
            vc.name4 = txtfield_name4.text!
            vc.name5 = txtfield_name5.text!
            vc.name6 = txtfield_name6.text!
        }
        else
        {
            getValues()
        }
    }
    
    //STORE INTO USERDEFAULTS
    func getValues()
    {
        
        if txtfield_name1.text != ""
        {
            UserDefaults.standard.set(txtfield_name1.text, forKey: "regNameKey1")
        }
        if txtfield_name2.text != ""
        {
            UserDefaults.standard.set(txtfield_name2.text, forKey: "regNameKey2")
        }
        if txtfield_name3.text != ""
        {
            UserDefaults.standard.set(txtfield_name3.text, forKey: "regNameKey3")
        }
        if txtfield_name4.text != ""
        {
            UserDefaults.standard.set(txtfield_name4.text, forKey: "regNameKey4")
        }
        if txtfield_name5.text != ""
        {
            UserDefaults.standard.set(txtfield_name5.text, forKey: "regNameKey5")
        }
        if txtfield_name6.text != ""
        {
            UserDefaults.standard.set(txtfield_name6.text, forKey: "regNameKey6")
        }
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtfield_name1.text = UserDefaults.standard.value(forKey:"regNameKey1") as? String
        txtfield_name2.text = UserDefaults.standard.value(forKey:"regNameKey2") as? String
        txtfield_name3.text = UserDefaults.standard.value(forKey:"regNameKey3") as? String
        txtfield_name4.text = UserDefaults.standard.value(forKey:"regNameKey4") as? String
        txtfield_name5.text = UserDefaults.standard.value(forKey:"regNameKey5") as? String
        txtfield_name6.text = UserDefaults.standard.value(forKey:"regNameKey6") as? String
    }
    
    
    @IBAction func clearAll(_ sender: Any)
    {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "regNameKey1")
        prefs.removeObject(forKey: "regNameKey2")
        prefs.removeObject(forKey: "regNameKey3")
        prefs.removeObject(forKey: "regNameKey4")
        prefs.removeObject(forKey: "regNameKey5")
        prefs.removeObject(forKey: "regNameKey6")
        
        txtfield_name1.text = ""
        txtfield_name2.text = ""
        txtfield_name3.text = ""
        txtfield_name4.text = ""
        txtfield_name5.text = ""
        txtfield_name6.text = ""
    }
    
    //Sending to previous view
    @IBAction func goBack(_ sender: Any)
    {
        goBack = true
        self.performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    //Hiding keyboarding when touching outside text.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtfield_name1.resignFirstResponder()
        txtfield_name2.resignFirstResponder()
        txtfield_name3.resignFirstResponder()
        txtfield_name4.resignFirstResponder()
        txtfield_name5.resignFirstResponder()
        txtfield_name6.resignFirstResponder()
    }
}
