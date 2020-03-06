//
//  CalendarViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-28.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var currentIndexPath: Int!
    var currentDocID: String!
    
    var calendarArray: [calendarTxt] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        calendarArray = createArray()
    }
    
    //Retrieving data and inserts into tableview
    func createArray() -> [calendarTxt]
    {
        var tempTxt: [calendarTxt] = []
        
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("premiumData").document(authentication!).collection("calendar").order(by: "date", descending: false).getDocuments { (querySnapshot, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let data = document.data()
                    
                    let data1 = data["title"] as? String
                    let data2 = data["date"] as? String
                    let data3 = data["dogName"] as? String
                    let data4 = data["person"] as? String
                    let data5 = data["location"] as? String
                    let data6 = data["note"] as? String
                    let data7 = document.documentID
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    let dateStr = formatter.string(from: Date())
                    
                    if data2! <= dateStr
                    {
                        self.currentDocID = data7
                        self.deleteOldData()
                        self.tableView.reloadData()
                    }
                    
                    let txt = calendarTxt.init(title: data1!, date: data2!, dogName: data3!, person: data4!, location: data5!, note: data6!, documentID: data7)
                    
                    print(data7)
                    
                    tempTxt.append(txt)
                }
                self.calendarArray = tempTxt
                self.tableView.reloadData()
            }
        }
        return calendarArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return calendarArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let calendarPath = calendarArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarTableViewCell
        
        cell.setCell(calendarArray: calendarPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  267
    }
    
    //If date and time passed, remove from calendar
    func deleteOldData()
    {
        //currentIndexPath
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("premiumData").document(authentication!).collection("calendar").document(currentDocID).delete { (error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                print("CMD: Row deleted, reason: Expired Date")
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func newCalendarData(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "NewCalViewController") as! NewCalViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    

}
