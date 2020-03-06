//
//  MyProfileViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-10.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyProfileViewController: UIViewController
{
    //Declaration
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_verNr: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    //Translation
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var upgraded: UILabel!
    @IBOutlet weak var registered: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var terms: UIButton!
    
    //Calling firestore
    let db = Firestore.firestore()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()

        getValues()
        //Setting the values
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        lbl_verNr.text = appVersion
        
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("profileHeader", comment: "")
        version.text = NSLocalizedString("profileVersion", comment: "")
        upgraded.text = NSLocalizedString("profileUpgraded", comment: "")
        registered.text = NSLocalizedString("profileRegistered", comment: "")
        status.text = NSLocalizedString("upgradeStatus", comment: "")
        terms.setTitle(NSLocalizedString("profileTerms", comment: ""), for: .normal)
    }
    
    
    //-----------------------------------------------------------
    //                Function to retrieve values
    //-----------------------------------------------------------
    func getValues()
    {
        //Authentication to access the right directory
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("users").document(authentication!).collection("Info").getDocuments { (querySnapshot, err) in
            if err != nil
            {
                print("Error retrieving info-documents!")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    
                    let data1 = data["Email"] as? String
                    let data2 = data["Date"] as? String
                    let data3 = data["premium"] as? String
                    //Inserting datavalues into the textfield.
                    self.lbl_email.text = data1
                    self.lbl_date.text = data2
                    
                    //Checking if user is premium
                    if data3 == "1"
                    {
                        self.status.text = NSLocalizedString("profile-prem-yes", comment: "")
                    }
                    else
                    {
                        self.status.text = NSLocalizedString("profile-prem-no", comment: "")
                    }
                }
            }
        }
    }
    
    @IBAction func terms(_ sender: Any)
    {
        let url = URL(string: NSLocalizedString("termsLink", comment: ""))
        UIApplication.shared.open(url!, options: [:])
    }
    

}
