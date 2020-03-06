//
//  PremHisViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-27.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class PremHisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTitle: UINavigationItem!
    
    var contentArray:[contentTxt] = []
    
    let db = Firestore.firestore()
    var docID = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        contentArray = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func translateCode()
    {
        historyTitle.title = NSLocalizedString("premHis-title", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let listPath = contentArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "premHis") as! PremHisCell
        cell.setCell(contentArray: listPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = self.tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! PremHisCell
        
        docID = cell.docID.text!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 298
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            removeRowAt(indexPath: indexPath)
        }
    }
    
    func removeRowAt(indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath) as! PremHisCell
        let authentication = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: NSLocalizedString("premHis-rem-title", comment: ""), message: NSLocalizedString("premHis-rem-message", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("premHis-rem-ok", comment: ""), style: UIAlertAction.Style.default))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("premHis-rem-remove", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alertAction) in
            self.db.collection("premiumData").document(authentication!).collection("healthControl").document(cell.docID.text!).delete { (err) in
                if let err = err
                {
                    print(err.localizedDescription)
                }
                else
                {
                    print("successfully deleted document with ID:", cell.docID.text!)
                    self.updateList()
                }
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateList(){
        contentArray.removeAll()
        
        contentArray = createArray()
        
        self.tableView.reloadData()
        print("Data reloaded!")
    }
    
    func createArray() -> [contentTxt]
    {
        var tempTxt: [contentTxt] = []
        
        let authentication = Auth.auth().currentUser?.uid
        db.collection("premiumData").document(authentication!).collection("healthControl").getDocuments
            { (querySnapshot, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    
                    let data0 = data["Title"] as? String
                    let data1 = data["Who"] as? String
                    let data2 = data["Dog"] as? String
                    let data3 = data["Note"] as? String
                    let data4 = data["Date"] as? String
                    let data5 = document.documentID
                    
                    let txt = contentTxt(title: data0!, who: data1!, dog: data2!, content: data3!, date: data4!, docID: data5)
                    
                    tempTxt.append(txt)
                }
                self.contentArray = tempTxt
                self.tableView.reloadData()
            }
        }
        return contentArray
    }
    

    //Adding a new history
    @IBAction func addNew(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "NewHealthViewController") as! NewHealthViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}
