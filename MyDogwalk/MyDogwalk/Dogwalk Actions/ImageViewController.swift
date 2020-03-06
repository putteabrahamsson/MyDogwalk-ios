//
//  ImageViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-08.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import GoogleMobileAds

class ImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate
{
    //Indicator
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingTxt: UILabel!
    
    //Add new image
    @IBOutlet weak var btn_camera: UIBarButtonItem!
    @IBOutlet weak var btn_library: UIBarButtonItem!
    
    var uploadNew = true
    
    //Declaring for translate
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var choose: UIBarButtonItem!
    
    //Banner for advertisements
    @IBOutlet weak var advertisementBanner: GADBannerView!
    
    //Imageview to temporary store images to be inserted in the tableview
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //Array for all images
    var imgArray:[UIImage] = []
    //Path using to delete images inside array
    var deletePathFromArray: Int!
    var deleteName: String!
    
    //Array for download links
    var downloadURL:[String] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()

        tableView.delegate = self
        tableView.dataSource = self
        
        getValues()
        
        //Request Advertisement
        let request = GADRequest()
        
        //Set up advertisement
        advertisementBanner.adUnitID = "ca-app-pub-7225493999040026/4779408290"
        advertisementBanner.rootViewController = self
        advertisementBanner.delegate = self
        advertisementBanner.load(request)
    }
    
    //If no advertisement is shown.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        advertisementBanner.isHidden = true
    }
    
    //-------------------------------------------------------------------------------
    //----------------------------- Tableview proporties ----------------------------
    //-------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imgArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! ImageTableViewCell
        
        cell.imgViewBox.image = imgArray[indexPath.row]
        
        let premiumValue = UserDefaults.standard.value(forKey: "premium") as! String
        
        //If user is premium
        if premiumValue == "1"
        {
            print("Premium")
            btn_camera.isEnabled = true
            btn_library.isEnabled = true
        }
        //If user is not premium
        else
        {
            if imgArray.count > 0
            {
                btn_camera.isEnabled = false
                btn_library.isEnabled = false
            }
            else
            {
                btn_camera.isEnabled = true
                btn_library.isEnabled = true
            }
        }
            
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        deletePathFromArray = indexPath.row
        print(indexPath)
    }
    
    //-------------------------------------------------------------------------------
    //--------------------------- Take photo and/or import --------------------------
    //-------------------------------------------------------------------------------

    @IBAction func takePhotoButton(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            print("Could not load")
        }
    }
    
    
    
    @IBAction func importImage(_ sender: Any)
    {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After the completion
        }
        
    }
    
    //-------------------------------------------------------------------------------
    //--------------------------- Delete images from array --------------------------
    //-------------------------------------------------------------------------------
    @IBAction func deleteSelectedImage(_ sender: Any)
    {
        if self.deletePathFromArray != nil
        {
            let alert = UIAlertController(title: NSLocalizedString("del-img-title", comment: ""), message: NSLocalizedString("del-img-body", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            //Delete image
            alert.addAction(UIAlertAction(title: NSLocalizedString("del-delete", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                
                self.imgArray.remove(at: self.deletePathFromArray)
                self.tableView.reloadData()
                
                
                self.btn_camera.isEnabled = true
                self.btn_library.isEnabled = true
                
                let prefs = UserDefaults.standard
                prefs.removeObject(forKey: "dl-url-key")
                
                self.deletePathFromArray = nil
                self.choose.isEnabled = false
                
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("del-cancel", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
            
            
        //No image is selected
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("del-noSel-title", comment: ""), message: NSLocalizedString("del-noSel-body", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("del-noSel-ok", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
            
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //-------------------------------------------------------------------------------
    //----------------------------- Append image to array ---------------------------
    //-------------------------------------------------------------------------------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if uploadNew == true
        {
            uploadNew = false
            
            choose.isEnabled = false
            indicator.startAnimating()
            loadingView.isHidden = false
            
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                imageView.image = image
                imgArray.append(imageView.image!)
                self.tableView.reloadData()
                
                let imageName = UUID().uuidString
                
                
                let storageRef = Storage.storage().reference().child(imageName)
                
                if let uploadData = self.imageView.image!.pngData()
                {
                    
                    storageRef.putData(uploadData, metadata: nil)
                    { (metadata, err) in
                        if let err = err
                        {
                            print(err.localizedDescription)
                            return
                        }
                        
                        storageRef.downloadURL(completion: { (dlUrl, err) in
                            if let err = err
                            {
                                print(err.localizedDescription)
                            }
                            else
                            {
                                self.downloadURL.append(dlUrl!.absoluteString)
                                
                                self.choose.isEnabled = true
                                self.uploadNew = true
                                
                                self.indicator.stopAnimating()
                                self.loadingView.isHidden = true
                                
                            }
                        })
                    }
                    
                }
                //imageView.image = nil
            }
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            print("Do not click so fast!")
        }
        
    }
    
    //-------------------------------------------------------------------------------
    //----------------------------- Choose button tapped ----------------------------
    //-------------------------------------------------------------------------------
    
    @IBAction func choose(_ sender: Any)
    {

        if downloadURL != []
        {
            UserDefaults.standard.set(downloadURL, forKey: "dl-url-key")
        }
        
        print(self.downloadURL)
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    //-------------------------------------------------------------------------------
    //--------------------------- Retrieve image -------------------------
    //-------------------------------------------------------------------------------
    func getValues()
    {
        
        //Retrieving the array by key
        downloadURL = UserDefaults.standard.array(forKey: "dl-url-key") as? [String] ?? []
        
        
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

    func translateCode()
    {
        header.title = NSLocalizedString("addImgHeader", comment: "")
        choose.title = NSLocalizedString("addImgChoose", comment: "")
        loadingTxt.text = NSLocalizedString(("indicator-loading"), comment: "")
    }

}
