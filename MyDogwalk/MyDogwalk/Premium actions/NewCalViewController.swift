//
//  NewCalViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-28.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class NewCalViewController: UIViewController
{
    @IBOutlet weak var txtfield_title: UITextField!
    @IBOutlet weak var txtfield_date: UITextField!
    @IBOutlet weak var txtfield_dogname: UITextField!
    @IBOutlet weak var txtfield_person: UITextField!
    @IBOutlet weak var txtfield_location: UITextField!
    @IBOutlet weak var lbl_addNote: UILabel!
    @IBOutlet weak var txtview_note: UITextView!
    @IBOutlet weak var pickDateTime: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtfield_person.text = UserDefaults.standard.value(forKey: "personKey") as? String
        
        pickDateTime.minimumDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        txtfield_date.text = formatter.string(from: pickDateTime.date)
    }
    
    @IBAction func saveData(_ sender: Any)
    {
        let authentication = Auth.auth().currentUser?.uid
        db.collection("premiumData").document(authentication!).collection("calendar").addDocument(data:
            [
                "title": txtfield_title.text!,
                "date": txtfield_date.text!,
                "dogName": txtfield_dogname.text!,
                "person": txtfield_person.text!,
                "location": txtfield_location.text!,
                "note": txtview_note.text!]) { (error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    print("succeded adding documents to calendar")
                    
                    //Get seconds between dates.
                    let dateTimer = Date()
                    let diffTime = Calendar.current.dateComponents([.second], from: dateTimer, to: self.pickDateTime.date)
                    
                    let d = diffTime.second
                    
                    let content = UNMutableNotificationContent()
                    content.title = self.txtfield_title.text! //NSLocalizedString("CalendarTitle", comment: "")
                    
                    content.body = String(format: NSLocalizedString("CalendarBody", comment: ""), self.txtfield_date.text!, self.txtfield_dogname.text!, self.txtfield_person.text!, self.txtfield_location.text!, self.txtview_note.text!)
                    
                    content.badge = 0;
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(d!), repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "calendarTimer", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                    if let storyboard = self.storyboard
                    {
                        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
        }
        

        
    }
    
    //Showing the DateTimePicker when tapping date textfield
    @IBAction func dateDidBegin(_ sender: Any)
    {
        pickDateTime.isHidden = false
    }
    //Adding new data to textfield when value changed
    @IBAction func dateChanged(_ sender: Any)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        txtfield_date.text = formatter.string(from: pickDateTime.date)
    }
    //Go back to previous page
    @IBAction func goBack(_ sender: Any)
    {
        if let storyboard = self.storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    



}
