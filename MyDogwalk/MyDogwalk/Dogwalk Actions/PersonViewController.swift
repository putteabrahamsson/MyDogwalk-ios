//
//  PersonViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PersonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var pickerview: UIPickerView!
    
    var selectedPerson = ""
    
    //Getting Firestore
    let db = Firestore.firestore()
    
    var personArray : [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        
        //Start function
        getPerson()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return personArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return personArray.count - 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPerson = personArray[row]
    }
    
    //Function getPerson()
    func getPerson()
    {
        let authentication = Auth.auth().currentUser?.uid
        db.collection("users").document(authentication!).collection("Person").getDocuments { (QuerySnapshot, err) in
            
            //If error is not equal to nil
            if err != nil
            {
                print("Error getting documents: \(String(describing: err))");
            }
            //Succeded
            else
            {
                //For-loop
                for _ in QuerySnapshot!.documents
                {
                    //Cleaning the array for the new values
                    self.personArray.removeAll()
                    
                    let document = QuerySnapshot!.documents.first
                    let data = document!.data()
                    
                    data.forEach { (item) in
                        if let person1Data = data["Name1"] as? String
                        {
                            self.personArray.append(person1Data)
                        }
                        if let person2Data = data["Name2"] as? String
                        {
                            self.personArray.append(person2Data)
                        }
                        if let person3Data = data["Name3"] as? String
                        {
                            self.personArray.append(person3Data)
                        }
                        if let person4Data = data["Name4"] as? String
                        {
                            self.personArray.append(person4Data)
                        }
                        if let person5Data = data["Name5"] as? String
                        {
                            self.personArray.append(person5Data)
                        }
                        if let person6Data = data["Name6"] as? String
                        {
                            self.personArray.append(person6Data)
                        }
                    }
                }
                self.pickerview.reloadAllComponents()
            }
        }
    }
    
    
    
    
    @IBAction func save(_ sender: Any)
    {
        self.performSegue(withIdentifier: "savePerson", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! DogwalkViewController
        
        vc .person = selectedPerson
    }
    
}
