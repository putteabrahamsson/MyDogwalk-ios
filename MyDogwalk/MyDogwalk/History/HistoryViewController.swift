//
//  HistoryViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-21.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate
{

    //Banner for advertisement
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var TableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //Tableview
    @IBOutlet weak var tableView: UITableView!

    //Translate
    @IBOutlet weak var historyHeader: UINavigationItem!
    @IBOutlet weak var historyPromenad: UILabel!
    @IBOutlet weak var historyDusch: UILabel!
    @IBOutlet weak var historyPoints: UILabel!
    
    var bath = false
    var walk = false
    var score = false
    
    var premiumValue: String!
    
    let db = Firestore.firestore()
    
    var list: [listTxt] = []
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        walk = true
        list = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshTableView()
        
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
        topConstraint.constant = 0
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        topConstraint.constant = 100
        
        tableView.layoutIfNeeded()
        tableView.updateConstraints()
    }
    
    //Translating the language
    func translateCode()
    {
        historyHeader.title = NSLocalizedString("historyHeader", comment: "")
        historyPromenad.text = NSLocalizedString("historyPromenad", comment: "")
        historyDusch.text = NSLocalizedString("historyDusch", comment: "")
        historyPoints.text = NSLocalizedString("historyPoints", comment: "")
    }
    
    //-----------------------------------------------------------
    //                 Refresh tableview
    //-----------------------------------------------------------
    
    func refreshTableView()
    {
        let title = NSLocalizedString("historyUpdate", comment: "")
        self.refreshControl.attributedTitle = NSAttributedString(string: title)
        
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        updateList()
    }
    
    func updateList(){
        list.removeAll()
        
        list = createArray()
        // Code to refresh table view
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        print("Data reloaded!")
    }
    
    //--------------------------------------------------------------------
    //                 Create an array to be inserted in the tableView
    //--------------------------------------------------------------------
    func createArray() -> [listTxt]
    {
        var tempTxt: [listTxt] = []
        
        //Authentication
        let authentication = Auth.auth().currentUser?.uid
        
        //If walk is selected
        if walk == true
        {
            //Choosing collection
            db.collection("rastad").document(authentication!).collection("promenad")
                .order(by: "Date", descending: true)
                .order(by: "Time", descending: true)
                .getDocuments()
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
                                
                                let data1 = data["Dog"] as? String
                                let data2 = data["Person"] as? String
                                let data3 = data["What"] as? String
                                let data4 = data["Date"] as? String
                                let data5 = data["Time"] as? String
                                let data6 = data["Kilometers"] as? String
                                let data7 = data["Timer"] as? String
                                let data8 = data["latitude"] as? [Double]
                                let data9 = data["longitude"] as? [Double]
                                let data10 = document.documentID
                                let data11 = data["Note"] as? String
                                let data12 = data["imgUrl"] as? [String]
                                
                                let imgView = UIImage.init(named: "noteeeee.png")
                                
                                let txt = listTxt(dog: data1!, person: data2!, action: data3!, time: data5!, date: data4!, kilometers: data6!, timer: data7!, documentID: data10, latitude: data8 ?? [], longitude: data9 ?? [], note: data11 ?? "", imgUrl: data12 ?? [], noteImg: imgView!)
                                
                                tempTxt.append(txt)
                                
                            }
                            self.list = tempTxt
                            self.tableView.reloadData()
                        }
            }
        }
        //If bath button is selected
        if bath == true
        {
            //Choosing collection
            db.collection("rastad").document(authentication!).collection("duschBad")
                .order(by: "Date", descending: true)
                .order(by: "Time", descending: true)
                .getDocuments()
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
                                
                                let data1 = data["Dog"] as? String
                                let data2 = data["Person"] as? String
                                let data3 = data["What"] as? String
                                let data4 = data["Date"] as? String
                                let data5 = data["Time"] as? String
                                let data6 = data["Kilometers"] as? String
                                let data7 = data["Timer"] as? String
                                let data8 = data["latitude"] as? [Double]
                                let data9 = data["longitude"] as? [Double]
                                let data10 = document.documentID
                                let data11 = data["Note"] as? String
                                let data12 = data["imgUrl"] as? [String]
                                
                                let imgView = UIImage.init(named: "noteeeee.png")
                                
                                let txt = listTxt(dog: data1!, person: data2!, action: data3!, time: data4!, date: data5!, kilometers: data6!, timer: data7!, documentID: data10, latitude: data8 ?? [], longitude: data9 ?? [], note: data11 ?? "", imgUrl: data12 ?? [], noteImg: imgView!)
                                
   
                                print(txt)
                                
                                tempTxt.append(txt)
                                
                            }
                            self.list = tempTxt
                            self.tableView.reloadData()
                        }
            }
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! HistoryCell
        cell.setCell(list: listPath) 
        
        if listPath.note.isEmpty == false
        {
            cell.noteImg.isHidden = false
        }
        else
        {
            cell.noteImg.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showRow", sender: self)
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if walk == true{
                removeRowAtWalk(indexPath: indexPath)
            }
            else{
                removeRowAtShower(indexPath: indexPath)
            }
        }
    }
    
    //Removing row at walk
    func removeRowAtWalk(indexPath: IndexPath!){
        
        let cell = tableView.cellForRow(at: indexPath) as! HistoryCell
        let authentication = Auth.auth().currentUser?.uid
        
        //Create an alert and ask for permission to delete document
        let alert = UIAlertController(title: NSLocalizedString("auss", comment: ""), message: NSLocalizedString("ausMessage", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        //Cancelling delte if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("cancel-remove-row", comment: ""), style: UIAlertAction.Style.cancel))
        
        //Deleting row if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("remove", comment: ""), style: UIAlertAction.Style.default, handler:
            { (alertAction) in
                self.db.collection("rastad").document(authentication!).collection("promenad").document(cell.documentID.text!).delete()
                    { err in
                        if err != nil{
                            print("Error deleting document with ID:", cell.documentID.text!)
                        }
                        else{
                            print("Successfully deleted document with ID:", cell.documentID.text!)
                            self.updateList()
                        }
                }
        }))
        //Presentating the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Removing row at shower
    func removeRowAtShower(indexPath: IndexPath!){
        
         let cell = tableView.cellForRow(at: indexPath) as! HistoryCell
        let authentication = Auth.auth().currentUser?.uid
        
        //Create an alert and ask for permission to delete document
        let alert = UIAlertController(title: NSLocalizedString("auss", comment: ""), message: NSLocalizedString("aussMessage", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("cancel-remove-row", comment: ""), style: UIAlertAction.Style.cancel))
        
        //Deleting row if button is clicked.
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("remove", comment: ""), style: UIAlertAction.Style.default, handler:
            { (alertAction) in
                self.db.collection("rastad").document(authentication!).collection("duschBad").document(cell.documentID.text!).delete()
                    { err in
                        if let err = err{
                            print(err.localizedDescription, "Error deleting document with ID:", cell.documentID.text!)
                        }
                        else
                        {
                            print("Successfully deleted document with ID:", cell.documentID.text!)
                            self.updateList()
                        }
                }
        }))
        //Presentating the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //-----------------------------------------------------------
    //                 Prepare for a segue
    //-----------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showRow"
        {
            let vc = segue.destination as? ViewRowViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: indexPath!) as! HistoryCell
            
            let dog = cell.DogName.text
            let who = cell.Person.text
            let what = cell.Action.text
            let date = cell.Date.text
            let time = cell.Time.text
            let timer = cell.timer.text
            let kilometers = cell.kilometer.text
            let documentID = cell.documentID.text
            let lat = cell.latitude
            let long = cell.longitude
            let notes = cell.note.text
            let imgUrl = cell.imgUrl
            
            vc!.dog = dog!
            vc!.who = who!
            vc!.what = what!
            vc!.time = time!
            vc!.date = date!
            vc!.timer = timer!
            vc!.kilometer = kilometers!
            vc!.documentID = documentID!
            vc!.latitude = lat
            vc!.longitude = long
            vc!.bath = bath
            vc!.note = notes ?? ""
            vc!.imgUrl = imgUrl
            
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
        if score == true
        {
            let vc = segue.destination as? ScoreBoardViewController
            
            vc!.countedArray = countedArray
            vc!.nameArray = nameArray
            
            nameArray.removeAll()
            countedArray.removeAll()
            
            score = false
        }
    }
    
    var countedArray:[String] = []
    var nameArray:[String] = []
    
    //Refreshing the tableview
    @IBAction func refreshTableView(_ sender: Any) {
        updateList()
    }
    
    //-----------------------------------------------------------
    //                 Buttons for navigation
    //-----------------------------------------------------------
    
    //Outlets for buttons & booleans
    @IBOutlet weak var btn_score: UIBarButtonItem!
    @IBOutlet weak var btn_bath: UIButton!
    @IBOutlet weak var btn_walk: UIButton!
    @IBOutlet weak var lbl_promenad: UILabel!
    @IBOutlet weak var lbl_dusch: UILabel!
    
    @IBAction func WalkTapped(_ sender: Any)
    {
        if walk == false
        {
            walk = true
            bath = false
            let _ = createArray()
            
            btn_bath.tintColor = UIColor.black
            lbl_dusch.textColor = UIColor.black
            btn_score.tintColor = UIColor.black
            btn_walk.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
            lbl_promenad.textColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        }
        else
        {
            walk = false
        }
    }
    
    @IBAction func BathTapped(_ sender: Any)
    {
        if bath == false
        {
            walk = false
            bath = true
            
            let _ = createArray()
            
            btn_walk.tintColor = UIColor.black
            lbl_promenad.textColor = UIColor.black
            btn_score.tintColor = UIColor.black
            
            btn_bath.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
            lbl_dusch.textColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        }
        else
        {
            bath = false
        }
    
    }
    
    @IBAction func ScoreTapped(_ sender: Any)
    {
           score = true
        
            let set = NSCountedSet(array: self.list.map{ $0.person })
            set.forEach
            {
                    //let result = "\($0): \(set.count(for: $0))"
                
                    let count = "\(set.count(for: $0))"
                    let name = "\($0)"
                    countedArray.append(count)
                    nameArray.append(name)
            }
            self.performSegue(withIdentifier: "points", sender: self)
    }
    
}
