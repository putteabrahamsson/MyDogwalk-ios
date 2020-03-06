//
//  MoreViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-30.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import StoreKit
import GoogleMobileAds

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, SKPaymentTransactionObserver
{
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingTxt: UILabel!
    
    
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //Declaring
    @IBOutlet weak var header: UINavigationItem!

    @IBOutlet weak var Dogwalk: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var more: UILabel!
    
    var premiumValue: String!
    
    let db = Firestore.firestore()
    
    var person = false
    var dog = false
    
    //Sections in the tableview
    var sections = [NSLocalizedString("sett-Premium", comment: ""),
                    NSLocalizedString("sett-premiumSection", comment: ""), NSLocalizedString("sett-myInfo", comment: ""), NSLocalizedString("sett-share", comment: ""), NSLocalizedString("sett-settings", comment: "")]
    
    //Images inside the sections
    var buttonImage =
    [
        //Shop
        [UIImage(named: "premium")!],
        //Premium section
        [UIImage(named: "logbook")!],
        //People and Dogs
        [UIImage(named: "people")!, UIImage(named: "dogs")!],
        //Rate, Invite and Support
        [UIImage(named: "rate")!, UIImage(named: "invite")!],
        //Profile, Change pass and Logout
        [UIImage(named: "profile")!, UIImage(named: "pass")!, UIImage(named: "support")!, UIImage(named: "logbook"), UIImage(named: "logout")!]
    ]
    //Titles inside the sections
    var buttonName =
    [
        [NSLocalizedString("sett-buyPremium", comment: "")],
        
        [NSLocalizedString("sett-logbook", comment: "")],
        
        [NSLocalizedString("sett-myPeople", comment: ""), NSLocalizedString("sett-myDogs", comment: "")],
        
        [NSLocalizedString("sett-rateUs", comment: ""), NSLocalizedString("sett-tellFriend", comment: "")],
        
        [NSLocalizedString("sett-profile", comment: ""), NSLocalizedString("sett-changePass", comment: ""), NSLocalizedString("sett-support", comment: ""), NSLocalizedString("sett-restorePremium", comment: ""), NSLocalizedString("sett-logout", comment: "")]
    ]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        //Shop stuff
        SKPaymentQueue.default().add(self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    
    func translateCode()
    {
        header.title = NSLocalizedString("More", comment: "")
        Dogwalk.text = NSLocalizedString("dogwalk", comment: "")
        history.text = NSLocalizedString("history", comment: "")
        more.text = NSLocalizedString("settings", comment: "")
        
        loadingTxt.text = NSLocalizedString("indicator-loading", comment: "")
    }
    
    //------------------------------------------------------------------------
    //                        TABLEVIEW PROPORTIES
    //------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return buttonName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreTableViewCell
        
        cell.buttonName.text = buttonName[indexPath.section][indexPath.row]
        cell.buttonImage.image = buttonImage[indexPath.section][indexPath.row]
        
        return cell
    }
    
    //Changing color of header text and background
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if premiumValue == "1"
        {
            if section == 0
            {
                return 0
            }
            else
            {
                return 45
            }
        }
        else
        {
            //Hide premium section here
            if section == 1
            {
                return 0
            }
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if premiumValue == "1"
        {
            if indexPath == [0, 0]
            {
                return 0
            }
            else
            {
                return 64
            }
        }
        else
        {
            //Hide all premium functions here
            if indexPath == [1, 0]
            {
                return 0
            }
            if indexPath == [1, 1]
            {
                return 0
            }
            if indexPath == [1, 2]
            {
                return 0
            }
        }
        return 64
    }
    
    //If user clicked on a button
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Buy premium
        if indexPath == [0, 0]
        {
            loadingView.isHidden = false
            indicator.startAnimating()
            
            print("premium button tapped")
            if SKPaymentQueue.canMakePayments()
            {
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = productID
                SKPaymentQueue.default().add(paymentRequest)
            }
            else
            {
                loadingView.isHidden = true
                indicator.stopAnimating()
                print("Users unable to make payments!")
            }
        }
        //Premium section
        if indexPath == [1, 0]
        {
            print("Logbook tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremHisViewController") as! PremHisViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if indexPath == [1, 2]
        {
            print("Weightcontroll tapped")

        }
        
        //My people
        if indexPath == [2, 0]
        {
            print("My people tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                vc.human = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //My dogs
        if indexPath == [2, 1]
        {
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "AddNewViewController") as! AddNewViewController
                vc.dog = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Rate us
        if indexPath == [3, 0]
        {
            print("Rate us tapped")
            let url = URL(string: "https://itunes.apple.com/se/app/mydogwalk/id1464139139?mt=8")
            UIApplication.shared.open(url!, options: [:])
        }
        //Invite a friend
        if indexPath == [3, 1]
        {
            print("Invite a friend tapped")
            
            let txt = NSLocalizedString("shareWithFriend", comment: "")
            
            let link = "https://itunes.apple.com/se/app/mydogwalk/id1464139139?mt=8"
            
            let activityVC = UIActivityViewController(activityItems: [txt, link], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
        //My profile
        if indexPath == [4, 0]
        {
            print("My profile tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Change password
        if indexPath == [4, 1]
        {
            print("Change password tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Contact support by mail
        if indexPath == [4, 2]
        {
            
            print("Contact support button tapped")
            
            let email = "putte_abrahamsson@hotmail.com"
            if let url = URL(string: "mailto:\(email)")
            {
                UIApplication.shared.open(url)
            }
            
        }
        if indexPath == [4, 3]
        {
            print("Restore purchase button tapped!")
            SKPaymentQueue.default().restoreCompletedTransactions()
            
            let alert = UIAlertController(title: NSLocalizedString("restore-alert-title", comment: ""), message: NSLocalizedString("restore-alert-mess", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("restore-alert-thanks", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                if let storyboard = self.storyboard
                {
                    let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            }))

            
            self.present(alert, animated: true, completion: nil)
            
        }
        //Logout
        if indexPath == [4, 4]
        {
            print("Logout tapped")
            
            //Creating an alert message function, to check weather the user wanna logout or not.
            let alert = UIAlertController(title: NSLocalizedString("logme", comment: ""), message: NSLocalizedString("logSure", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            //Adding button "Logga ut"
            alert.addAction(UIAlertAction(title: NSLocalizedString("logout", comment: ""), style: UIAlertAction.Style.default, handler:
                { (UIAlertAction) in
                    
                    //If button tapped -> Using authentication to logout user.
                    try! Auth.auth().signOut()
                    
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    
                    if let storyboard = self.storyboard
                    {
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! ViewController
                        
                        self.present(vc, animated: false, completion: nil)
                    }
            }))
            
            //Adding button "Avbryt"
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel, handler:
                { (UIAlertAction) in
                    
                    //If user press button "Avbryt", keep user logged in
                    print("Cancelled logout")
            }))
            
            //Presentating the alert-message
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //-----------------------------------Shop-----------------------------------
    
    let productID = "se.MyDogwalk.Premium"
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        retrieveCurrentData()
        
        for transaction in transactions
        {
            if transaction.transactionState == .restored
            {
                print("restored!")
                queue.finishTransaction(transaction)
            }
           if transaction.transactionState == .purchased
            {
                //If premium is purchased
                print("Transaction succesfully purchased!")
                
                let authentication = Auth.auth().currentUser?.uid
                
                db.collection("users").document(authentication!).collection("Info").document(docID).setData(
                ["premium" : "1"]) { (err) in
                    if err != nil
                    {
                        print("Error adding premium to account!")
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                        queue.finishTransaction(transaction)
                        return
                    }
                    else
                    {
                        print("Succeded adding premium!")
                        UserDefaults.standard.set("1", forKey: "premium")
                        
                        if let storyboard = self.storyboard
                        {
                            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                        queue.finishTransaction(transaction)
                    }
                    
                }

                
            }
            if transaction.transactionState == .deferred
            {
                print("deffered")
            }
            else if transaction.transactionState == .failed
            {
                //If premium failed to be purchased
                print(transaction.error ?? "")
                print("Transaction failed to be purschased!")
                queue.finishTransaction(transaction)
                self.loadingView.isHidden = true
                self.indicator.stopAnimating()
            }
        }
        
    }
    var docID: String!
    
    func retrieveCurrentData()
    {
        let authentication = Auth.auth().currentUser?.uid
        
        db.collection("users").document(authentication!).collection("Info").getDocuments { (query, err) in
            if err != nil
            {
                print(err!.localizedDescription)
            }
            else
            {
                for document in query!.documents
                {
                    self.docID = document.documentID
                }
            }
            
        }
    }
    
    //--------------------------------------------------------------------------
    
    
    //News
    @IBAction func newsButtonTapped(_ sender: Any)
    {
        let url = URL(string:NSLocalizedString("newsLink", comment: ""))
        UIApplication.shared.open(url!, options: [:])
    }
    
    
    //Navigation buttons
    
    @IBAction func Dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func history(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}
