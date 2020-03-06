//
//  ViewImgViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds

class ViewImgViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate
{
    @IBOutlet weak var header: UINavigationItem!
    var premiumValue: String!
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var imgArray:[UIImage] = []
    var downloadURL:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        getValues()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        premiumValue = UserDefaults.standard.value(forKey: "premium") as? String
        if premiumValue == "1"
        {
            print("No ads will be shown")
        }
        else
        {
            //Request
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
    }
    
    //---------------------------------------------------------------------
    //----------------------------- Tableview proporties ------------------
    //---------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewImgCell", for: indexPath) as! ViewImgTableViewCell
        
        cell.imgViewBox.image = imgArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath)
    }
    
    //-------------------------------------------------------------------------------
    //--------------------------- Retrieve image -------------------------
    //-------------------------------------------------------------------------------
    func getValues()
    {
        
        if downloadURL != []
        {
            loadingView.isHidden = false
            indicator.startAnimating()
        }
        
        for url in downloadURL
        {
            guard let imageURL = URL(string: url) else
            {
                continue
            }
            
            imageView.kf.setImage(with: imageURL)
            
            KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                let image = try? result.get().image
                if let image = image
                {
                    self.imgArray.append(image)
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    self.indicator.stopAnimating()
                }
            }
        }
    }

    //-------------------------------------------------------------------------------
    //------------------------------- Translate code --------------------------------
    //-------------------------------------------------------------------------------
    func translateCode()
    {
        header.title = NSLocalizedString("view-img-header", comment: "")
        loading.text = NSLocalizedString("indicator-loading", comment: "")
    }
}
