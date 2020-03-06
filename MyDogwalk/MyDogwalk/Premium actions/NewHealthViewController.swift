//
//  NewHealthViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-27.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class NewHealthViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    let db = Firestore.firestore()
    
    @IBOutlet weak var txtfield_date: UITextField!
    @IBOutlet weak var txtfield_dogname: UITextField!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var whoWas: UITextField!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txtfield_title: UITextField!
    
    @IBOutlet weak var txtNote: UILabel!
    @IBOutlet weak var txtDogname: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var savebtn: UIBarButtonItem!
    @IBOutlet weak var txtNotice: UINavigationItem!
    
    
    var dateBool = false
    var cDate = ""
    var cPerson = ""
    var cDog = ""
    
    var exactDate: Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        { (didAllow, error) in
            
        }
        
        txtfield_date.text = cDate
        txtfield_dogname.text = cDog
        whoWas.text = cPerson
        
        getValues()
        
        note.delegate = self
    }
    
    func translateCode()
    {
        lbl_title.text = NSLocalizedString("NH-title", comment: "")
        txtNote.text = NSLocalizedString("NH-noti", comment: "")
        txtDogname.text = NSLocalizedString("NH-dogname", comment: "")
        txtName.text = NSLocalizedString("NH-name", comment: "")
        txtDate.text = NSLocalizedString("NH-date", comment: "")
        
        savebtn.title = NSLocalizedString("NH-save", comment: "")
        txtNotice.title = NSLocalizedString("NH-header-title", comment: "")
    }
    
    @IBAction func saveHealthControl(_ sender: Any)
    {
       if note.text.isEmpty || whoWas.text!.isEmpty || txtfield_dogname.text!.isEmpty || txtfield_date.text!.isEmpty
        {
            print("add in all rows!")
        }
        else
        {
            let authentication = Auth.auth().currentUser?.uid
            db.collection("premiumData").document(authentication!).collection("healthControl").addDocument(data:
                
                [
                "Title": txtfield_title.text!,
                "Note": note.text!,
                 "Who": whoWas.text!,
                 "Date": txtfield_date.text!,
                 "Dog": txtfield_dogname.text!
                ]){(error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                   self.runNotification()
                   print("succeded!")
                    
                    let prefs = UserDefaults.standard
                    prefs.removeObject(forKey: "cTitleKey")
                    prefs.removeObject(forKey: "cNoteKey")
                    prefs.removeObject(forKey: "cDogKey")
                    prefs.removeObject(forKey: "cPersonKey")
                    prefs.removeObject(forKey: "cDateKey")
                    
                    if let storyboard = self.storyboard
                    {
                        let vc = storyboard.instantiateViewController(withIdentifier: "PremHisViewController") as! PremHisViewController
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }

    func runNotification()
    {
        if exactDate < Date()
        {
            print("less")
        }
        if exactDate > Date()
        {
            let diff = exactDate.timeIntervalSince(Date())
            print(diff)
            
            let content = UNMutableNotificationContent()
            content.title = String(format: NSLocalizedString("NH-noti-title", comment: ""), txtfield_title.text!)
            
            content.body = String(format: NSLocalizedString("NH-noti-body", comment: ""), note.text!)
            
            print(content.body)
            content.badge = 1;
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: diff, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone1", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        else
        {
            print("none")
        }
    }
    
    @IBAction func dogTapped(_ sender: Any)
    {
        getValues()
        txtfield_dogname.inputView = UIView()
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogViewController") as! DogViewController
            
            vc.DogBool = true
            vc.premiumDog = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func nameTapped(_ sender: Any)
    {
        getValues()
        whoWas.inputView = UIView()
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogViewController") as! DogViewController
            
            vc.PersonBool = true
            vc.premiumDog = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func dateTapped(_ sender: Any)
    {
        getValues()
        txtfield_date.inputView = UIView()
        
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DateTimeViewController") as! DateTimeViewController
            
            vc.premiumDate = true
            vc.DateTime = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    func getValues()
    {
        if txtfield_title.text != ""
        {
            UserDefaults.standard.set(txtfield_title.text, forKey: "cTitleKey")
        }
        if note.text != ""
        {
            UserDefaults.standard.set(note.text, forKey: "cNoteKey")
        }
        if cDog != ""
        {
            UserDefaults.standard.set(txtfield_dogname.text, forKey: "cDogKey")
        }
        if cPerson != ""
        {
            UserDefaults.standard.set(whoWas.text, forKey: "cPersonKey")
        }
        if cDate != ""
        {
            UserDefaults.standard.set(txtfield_date.text, forKey: "cDateKey")
        }
        
        UserDefaults.standard.synchronize()
        
        txtfield_title.text = UserDefaults.standard.value(forKey: "cTitleKey") as? String
        note.text = UserDefaults.standard.value(forKey: "cNoteKey") as? String
        txtfield_dogname.text = UserDefaults.standard.value(forKey: "cDogKey") as? String
        whoWas.text = UserDefaults.standard.value(forKey: "cPersonKey") as? String
        txtfield_date.text = UserDefaults.standard.value(forKey: "cDateKey") as? String
        
        if whoWas.text == ""
        {
            whoWas.text = UserDefaults.standard.value(forKey: "personKey") as? String
        }
    }
    
    //When clicking on the return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    //Hiding keyboard when pressing somewhere else.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        note.resignFirstResponder()
        txtfield_title.resignFirstResponder()
    }
}
