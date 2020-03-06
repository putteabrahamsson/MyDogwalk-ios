//
//  Signup-2-ViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-20.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Signup_2_ViewController: UIViewController, UITextFieldDelegate
{
    //Translate
    @IBOutlet weak var reg2Back: UIBarButtonItem!
    @IBOutlet weak var reg2Header: UINavigationItem!
    @IBOutlet weak var reg2Dog1: UILabel!
    @IBOutlet weak var reg2Dog2: UILabel!
    @IBOutlet weak var reg2Dog3: UILabel!
    @IBOutlet weak var reg2Register: UIButton!
    @IBOutlet weak var btn_clear: UIBarButtonItem!
    
    
    var dateRegistered = ""
    var password = ""
    var email = ""
    var name1 = ""
    var name2 = ""
    var name3 = ""
    var name4 = ""
    var name5 = ""
    var name6 = ""
    
    @IBOutlet weak var txtfield_dog1: UITextField!
    @IBOutlet weak var txtfield_dog2: UITextField!
    @IBOutlet weak var txtfield_dog3: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtfield_dog1.delegate = self
        txtfield_dog2.delegate = self
        txtfield_dog3.delegate = self   
        
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
        reg2Back.title = NSLocalizedString("reg2Back", comment: "")
        reg2Header.title = NSLocalizedString("reg2Title", comment: "")
        reg2Dog1.text = NSLocalizedString("reg2dog", comment: "")
        reg2Dog2.text = NSLocalizedString("reg2dog", comment: "")
        reg2Dog3.text = NSLocalizedString("reg2dog", comment: "")
        reg2Register.setTitle(NSLocalizedString("reg2register", comment: ""), for: .normal)
        btn_clear.title = NSLocalizedString("clearBtn", comment: "")
    }
    
    
    @IBAction func btn_register(_ sender: Any)
    {
        if(txtfield_dog1.text == "")
        {
            let alert = UIAlertController(title: NSLocalizedString("oneDogTitle", comment: ""), message: NSLocalizedString("oneDog", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("OKreg", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let dog1 = self.txtfield_dog1.text!
            let dog2 = self.txtfield_dog2.text!
            let dog3 = self.txtfield_dog3.text!
            
            //Create a new user with txtfield email & password
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                //Printing error if any
                if error != nil
                {
                    
                    let alert = UIAlertController.init(title: NSLocalizedString("badTitle", comment: ""), message: NSLocalizedString("badEmail", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
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
                        ["Email": self.email,
                         "Date": self.dateRegistered
                        ], completion: { (err) in
                            if err != nil
                            {
                                print("Error adding info-details")
                                return
                            }
                            else
                            {
                                print("Succeded!")
                            }
                    })
                
                //Equal to above, but for "Person"
                var _: DocumentReference = self.db
                    
                    .collection("users").document(authentication!)
                    .collection("Person").addDocument(data:
                        ["Name1": self.name1,
                         "Name2": self.name2,
                         "Name3": self.name3,
                         "Name4": self.name4,
                         "Name5": self.name5,
                         "Name6": self.name6
                        ], completion: { (err) in
                            if err != nil
                            {
                                print("Error adding person!")
                                return
                            }
                            else
                            {
                                print("Succeded!")
                            }
                    })
                
                //Equal to above, but for "Dogs"
                var _: DocumentReference = self.db
                    
                    .collection("users").document(authentication!)
                    .collection("Dogs").addDocument(data:
                        ["Dog1": dog1,
                         "Dog2": dog2,
                         "Dog3": dog3,
                        ], completion: { (err) in
                            if err != nil
                            {
                                print("Error adding dogs!")
                                return
                            }
                            else
                            {
                                print("Succeded!")
                            }
                    })
                
                
                //Equal to above, but for "Timer"
                let noTimer = "864000022.0"
                
                var _: DocumentReference = self.db
                    
                    .collection("timerCol").document(authentication!)
                    .collection("timer").addDocument(data:
                        ["Dog1": noTimer,
                         "Dog2": noTimer,
                         "Dog3": noTimer,
                        ], completion: { (err) in
                            if err != nil
                            {
                                print("Error adding timer!")
                                return
                            }
                            else
                            {
                                print("Succeded adding timer!")
                                
                                //Removing all userdefaults
                                let prefs = UserDefaults.standard
                                prefs.removeObject(forKey: "regEmailKey")
                                prefs.removeObject(forKey: "regPassKey")
                                prefs.removeObject(forKey: "regRepeatKey")
                                prefs.removeObject(forKey: "regNameKey1")
                                prefs.removeObject(forKey: "regNameKey2")
                                prefs.removeObject(forKey: "regNameKey3")
                                prefs.removeObject(forKey: "regNameKey4")
                                prefs.removeObject(forKey: "regNameKey5")
                                prefs.removeObject(forKey: "regNameKey6")
                                prefs.removeObject(forKey: "regDogKey1")
                                prefs.removeObject(forKey: "regDogKey2")
                                prefs.removeObject(forKey: "regDogKey3")
                                
                                
                                self.performSegue(withIdentifier: "toLoginScreen", sender: self)
                            }
                    })
                
                
            }
        }
        
    }
    
    
    //STORE INTO USERDEFAULTS
    func getValues()
    {
        
        if txtfield_dog1.text != ""
        {
            UserDefaults.standard.set(txtfield_dog1.text, forKey: "regDogKey1")
        }
        if txtfield_dog2.text != ""
        {
            UserDefaults.standard.set(txtfield_dog2.text, forKey: "regDogKey2")
        }
        if txtfield_dog3.text != ""
        {
            UserDefaults.standard.set(txtfield_dog3.text, forKey: "regDogKey3")
        }
        
        //Userdefault synchronize
        UserDefaults.standard.synchronize()
        
        //Retrieve the UserDefault values
        txtfield_dog1.text = UserDefaults.standard.value(forKey:"regDogKey1") as? String
        txtfield_dog2.text = UserDefaults.standard.value(forKey:"regDogKey2") as? String
        txtfield_dog3.text = UserDefaults.standard.value(forKey:"regDogKey3") as? String

    }
    
    @IBAction func clearAll(_ sender: Any)
    {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "regDogKey1")
        prefs.removeObject(forKey: "regDogKey2")
        prefs.removeObject(forKey: "regDogKey3")
        
        txtfield_dog1.text = ""
        txtfield_dog2.text = ""
        txtfield_dog3.text = ""
    }
    
    
    //Send back to previous form
    @IBAction func toPerson(_ sender: Any)
    {
        getValues()
        self.performSegue(withIdentifier: "toPerson", sender: self)
    }
    
    //Hiding keyboarding when touching outside text.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtfield_dog1.resignFirstResponder()
        txtfield_dog2.resignFirstResponder()
        txtfield_dog3.resignFirstResponder()
    }
    
}
