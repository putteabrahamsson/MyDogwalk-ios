//
//  AddNewViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class AddNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate
{
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    //Declaring
    @IBOutlet weak var header: UINavigationItem!
    
    //+ for adding a new
    @IBOutlet weak var btn_addNew: UIBarButtonItem!
    
    //Loading indicator
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //Booleans
    var human = false
    var dog = false
    
    var docID: String!
    var premiumValue: String!
    
    //Firestore
    let db = Firestore.firestore()
    
    //Creating arrays
    var list: [addNewTxt] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        indicator.isHidden = false
        indicator.startAnimating()
        
        
        if human == true
        {
            header.title = NSLocalizedString("add-human", comment: "")
        }
        else if dog == true
        {
            header.title = NSLocalizedString("add-dog", comment: "")
        }
        
        list = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        btn_addNew.isEnabled = true
    
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
        }
    }
    
    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    
    //--------------------------------------------------------------------
    //                 Create an array to be inserted in the tableView
    //--------------------------------------------------------------------
    func createArray() -> [addNewTxt]
    {
        var tempTxt: [addNewTxt] = []
        
        //Authentication
        let authentication = Auth.auth().currentUser?.uid
        
        //If walk is selected
        if human == true
        {
            //Choosing collection
            db.collection("users").document(authentication!).collection("person").order(by: "dob", descending: false).getDocuments()
                    { (QuerySnapshot, err) in
                        if err != nil
                        {
                            print("Error getting documents: \(String(describing: err))");
                        }
                        else
                        {
                            //For-loop
                            for document in QuerySnapshot!.documents
                            {
                                self.list.removeAll()
                                let data = document.data()
                                
                                let data1 = data["name"] as? String
                                var data2 = data["sex"] as? String
                                let data3 = ""
                                let data4 = data["dob"] as? String
                                let data6 = ""
                                self.docID = document.documentID
                                
                                //Replacing numbers to gender
                                if data2 == "0"
                                {
                                    data2 = NSLocalizedString("list-male", comment: "")
                                }
                                else if data2 == "1"
                                {
                                    data2 = NSLocalizedString("list-female", comment: "")
                                }
                                else if data2 == "2"
                                {
                                    data2 = NSLocalizedString("list-other", comment: "")
                                }
                                
                                let txt = addNewTxt(FullName: data1!, sex: data3, breed: data2!, identity: self.docID, timer: data6, dob: data4!)
                                
                                tempTxt.append(txt)
                                
                            }
                            self.list = tempTxt
                            self.tableView.reloadData()
                        }
            }
        }
        //If bath button is selected
        if dog == true
        {
            //Choosing collection
                db.collection("users").document(authentication!).collection("dog").order(by: "dob", descending: false).getDocuments()
                    { (QuerySnapshot, err) in
                        if err != nil
                        {
                            print("Error getting documents: \(String(describing: err))");
                        }
                        else
                        {
                            //For-loop
                            for document in QuerySnapshot!.documents
                            {
                                self.list.removeAll()
                                //let document = QuerySnapshot!.documents
                                let data = document.data()
                                
                                let data1 = data["name"] as? String
                                let data2 = data["breed"] as? String
                                let data3 = data["sex"] as? String
                                let data4 = data["dob"] as? String
                                let data6 = data["timer"] as? String
                                self.docID = document.documentID
                                
                                let txt = addNewTxt(FullName: data1!, sex: data3!, breed: data2!, identity: self.docID, timer: data6!, dob: data4!)
                                
                                print("-----")
                                print(self.docID!)
                                print("-----")
                                
                                print(txt)
                                
                                tempTxt.append(txt)
                                
                            }
                            self.list = tempTxt
                            self.tableView.reloadData()
                        }
            }
        }
        
        indicator.stopAnimating()
        indicator.isHidden = true
        //return tempTxt
        return list
    }
    
    //-----------------------------------------------------------
    //                 TableView properties
    //-----------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let listPath = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewCell") as! AddNewTableViewCell
        cell.setCell(list: listPath)
        
        let premiumValue = UserDefaults.standard.value(forKey: "premium") as! String
        
        //If user is premium
        if premiumValue == "1"
        {
            print("Premium")
            btn_addNew.isEnabled = true
        }
        //If user is not premium
        else
        {
            if human == true
            {
                if list.count > 4
                {
                    btn_addNew.isEnabled = false
                }
                else
                {
                   btn_addNew.isEnabled = true
                }
            }
            else if dog == true
            {
                if list.count > 2
                {
                    btn_addNew.isEnabled = false
                }
                else
                {
                    btn_addNew.isEnabled = true
                }
            }
        }

    
        indicator.isHidden = true
        indicator.stopAnimating()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if human == true
        {
            self.performSegue(withIdentifier: "editPerson", sender: self)
        }
        else if dog == true
        {
            self.performSegue(withIdentifier: "editDog", sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if human == true{
                removeRowAtPerson(indexPath: indexPath)
            }
            else{
                removeRowAtDog(indexPath: indexPath)
            }
        }
    }
    
    func removeRowAtPerson(indexPath: IndexPath!){
        let cell = tableView.cellForRow(at: indexPath) as! AddNewTableViewCell
        let authentication = Auth.auth().currentUser?.uid
        
        //Create an alert and ask for permission to delete document
        let alert = UIAlertController(title: NSLocalizedString("deletePerson-title", comment: ""), message: NSLocalizedString("deletePerson-txt", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        //Cancelling delte if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("deletePerson-cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alertAction) in
            
            print("No rows were deleted!")
            
        }))
        
        //Deleting row if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("deletePerson-remove", comment: ""), style: UIAlertAction.Style.default, handler:
            { (alertAction) in
                self.db.collection("users").document(authentication!).collection("person").document(cell.identity.text!).delete()
                    { err in
                        if err != nil{
                            print("Error deleting document with ID:", cell.identity.text!)
                        }
                        else{
                            print("Successfully deleted document with ID:", cell.identity.text!)
                            self.updateList()
                        }
                }
        }))
        //Presentating the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeRowAtDog(indexPath: IndexPath!){
        let cell = tableView.cellForRow(at: indexPath) as! AddNewTableViewCell
        let authentication = Auth.auth().currentUser?.uid
        
        //Create an alert and ask for permission to delete document
        let alert = UIAlertController(title: NSLocalizedString("deleteDog-title", comment: ""), message: NSLocalizedString("deleteDog-txt", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        //Cancelling delte if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("deleteDog-cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alertAction) in
            
            print("No rows were deleted!")
            
        }))
        
        //Deleting row if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("deleteDog-remove", comment: ""), style: UIAlertAction.Style.default, handler:
            { (alertAction) in
                self.db.collection("users").document(authentication!).collection("dog").document(cell.identity.text!).delete()
                    { err in
                        if err != nil
                        {
                            print("Error deleting document with ID:", cell.identity.text!)
                        }
                        else
                        {
                            let prefs = UserDefaults.standard
                            prefs.removeObject(forKey: "nameKey")
                            prefs.removeObject(forKey: "breedKey")
                            prefs.removeObject(forKey: "sexKey")
                            prefs.removeObject(forKey: "dobKey")
                            prefs.removeObject(forKey: "addTimerKey")
                            
                            print("Successfully deleted document with ID:", cell.identity.text!)
                            self.updateList()
                            
                        }
                }
        }))
        //Presentating the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateList(){
        list.removeAll()
        
        list = createArray()
        // Code to refresh table view
        self.tableView.reloadData()
        print("Data reloaded!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if human == true
        {
            let vc  = segue.destination as? PersonViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: indexPath!) as! AddNewTableViewCell
            
            vc?.editMode = true
            vc?.nameStr = cell.FullName.text!
            vc?.dobStr = cell.dob!
            vc?.documentID = cell.identity.text!
            
            //Converting gender into numbers
            if cell.breed.text == NSLocalizedString("list-male", comment: "")
            {
                vc?.genderStr = "0"
            }
            else if cell.breed.text == NSLocalizedString("list-female", comment: "")
            {
                vc?.genderStr = "1"
            }
            else
            {
                 vc?.genderStr = "2"
            }

        }
        else if dog == true
        {
            let vc  = segue.destination as? AddDogViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: indexPath!) as! AddNewTableViewCell
            
            vc?.editMode = true
            vc?.nameStr = cell.FullName.text!
            vc?.breedStr = cell.breed.text!
            vc?.gender = cell.sex.text!
            vc?.DoB = cell.dob!
            vc?.documentID = cell.identity.text!
            vc?.timerStr = cell.timer.text!
        }
    }
    //-----------------------------------------------------------
    //                 Add new
    //-----------------------------------------------------------
    
    @IBAction func addNew(_ sender: Any)
    {
        if human == true
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PersonViewController") as! PersonViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        else if dog == true
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
