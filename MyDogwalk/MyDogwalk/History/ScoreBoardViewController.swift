//
//  ScoreBoardViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-05.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate
{
    //Translate
    @IBOutlet weak var scoreBoard: UINavigationItem!

    var premiumValue: String!

    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var TableViewHeightConstraint: NSLayoutConstraint! //504
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var countedArray: [String] = []
    var nameArray: [String] = []
    var sort = false
    
    @IBOutlet weak var tableView: UITableView!
    var list: [pointsTxt] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        list = createArray()
        
        //Sorting the array after points
        list.sort()
        { $0.points.localizedStandardCompare($1.points) == .orderedDescending
                
        }
        
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
        scoreBoard.title = NSLocalizedString("scoreboardHeader", comment: "")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let listPath = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointsCell") as! ScoreCell
        cell.setCell(list: listPath)
        
        return cell
    }
    
    func createArray() -> [pointsTxt]
    {
        self.list = zip(nameArray, countedArray).map { pointsTxt(person: $0.0, points: $0.1) }
        
        self.tableView.reloadData()
        sort = true
        return list
    }
}
