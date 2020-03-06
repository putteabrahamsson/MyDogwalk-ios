//
//  PremImgViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-19.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class PremImgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    var vet = false
    var docu = false
    var insu = false
    var pedi = false
    
    //LoadingView
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var choose: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    //Veterinary Certificate Array
    var vetCertArray:[UIImage] = []
    
    //Documentataion Array
    var docArray:[UIImage] = []
   
    //Insurance Array
    var InsuArray:[UIImage] = []
    
    //Pedigree Array
    var PediArray:[UIImage] = []
    
    //Array for downloading links
    var downloadVet:[String] = []
    var downloadDoc:[String] = []
    var downloadInsu:[String] = []
    var downloadPedi:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getValues()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if vet == true
        {
            return vetCertArray.count
        }
        if docu == true
        {
            return docArray.count
        }
        if insu == true
        {
            return InsuArray.count
        }
        if pedi == true
        {
            return PediArray.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "premImgCell", for: indexPath) as! PremImgTableViewCell
        
        if vet == true
        {
            cell.imgBox.image = self.vetCertArray[indexPath.row]
        }
        if docu == true
        {
            cell.imgBox.image = self.docArray[indexPath.row]
        }
        if insu == true
        {
            cell.imgBox.image = self.InsuArray[indexPath.row]
        }
        if pedi == true
        {
            cell.imgBox.image = self.PediArray[indexPath.row]
        }
        
        return cell
    }
    
    //Handeling images
    @IBAction func addImage(_ sender: Any)
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
    
    @IBAction func takeImage(_ sender: Any)
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
    
    @IBAction func removeImage(_ sender: Any)
    {
        //Fix-
    }
    
    //Append image in array
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
            self.loadingView.isHidden = false
            self.indicator.startAnimating()
        
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                imageView.image = image
                
                if vet == true
                {
                    vetCertArray.append(imageView.image!)
                }
                if docu == true
                {
                    docArray.append(imageView.image!)
                }
                if insu == true
                {
                    InsuArray.append(imageView.image!)
                }
                if pedi == true
                {
                    PediArray.append(imageView.image!)
                }
    
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
                                if self.vet == true
                                {
                                    self.downloadVet.append(dlUrl!.absoluteString)
                                }
                                if self.docu == true
                                {
                                    self.downloadDoc.append(dlUrl!.absoluteString)
                                }
                                if self.insu == true
                                {
                                    self.downloadInsu.append(dlUrl!.absoluteString)
                                }
                                if self.pedi == true
                                {
                                    self.downloadPedi.append(dlUrl!.absoluteString)
                                }
                                
                                self.loadingView.isHidden = true
                                self.indicator.stopAnimating()
                            }
                        })
                    }
                    
                }
                //imageView.image = nil
            }
            self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func chooseButtonTapped(_ sender: Any)
    {
        //Choose veterinary
        if self.vet == true
        {
            if downloadVet != []
            {
                UserDefaults.standard.set(downloadVet, forKey: "dl-vet-key")
            }
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Choose documentation
        if self.docu == true
        {
            if downloadDoc != []
            {
                UserDefaults.standard.set(downloadDoc, forKey: "dl-doc-key")
            }
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Choose insurance
        if self.insu == true
        {
            if downloadInsu != []
            {
                UserDefaults.standard.set(downloadInsu, forKey: "dl-insu-key")
            }
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        //Choose pedigree
        if self.pedi == true
        {
            if downloadPedi != []
            {
                UserDefaults.standard.set(downloadPedi, forKey: "dl-pedi-key")
            }
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func getValues()
    {
        if downloadVet != []
        {
            loadingView.isHidden = false
            indicator.startAnimating()
        }
        if downloadDoc != []
        {
            loadingView.isHidden = false
            indicator.startAnimating()
        }
        if downloadInsu != []
        {
            loadingView.isHidden = false
            indicator.startAnimating()
        }
        if downloadPedi != []
        {
            loadingView.isHidden = false
            indicator.startAnimating()
        }
        
        //Veterinary
        if self.vet == true
        {
            downloadVet = UserDefaults.standard.array(forKey: "dl-vet-key") as? [String] ?? []
            
            for url in downloadVet
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
                        self.vetCertArray.append(image)
                        self.tableView.reloadData()
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
        //Documentation
        if self.docu == true
        {
            downloadDoc = UserDefaults.standard.array(forKey: "dl-doc-key") as? [String] ?? []
            
            for url in downloadDoc
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
                        self.docArray.append(image)
                        self.tableView.reloadData()
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                    }
                }
            }
            
        }
        //Insurance
        if self.insu == true
        {
            downloadInsu = UserDefaults.standard.array(forKey: "dl-insu-key") as? [String] ?? []
            
            for url in downloadInsu
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
                        self.InsuArray.append(image)
                        self.tableView.reloadData()
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
        //Pedigree
        if self.pedi == true
        {
            downloadPedi = UserDefaults.standard.array(forKey: "dl-pedi-key") as? [String] ?? []
            
            for url in downloadPedi
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
                        self.PediArray.append(image)
                        self.tableView.reloadData()
                        
                        self.loadingView.isHidden = true
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
    }

    func translateCode()
    {
        if vet == true
        {
            header.title = NSLocalizedString("vetHeader", comment: "")
        }
        if docu == true
        {
            header.title = NSLocalizedString("docuHeader", comment: "")
        }
        if insu == true
        {
            header.title = NSLocalizedString("insuHeader", comment: "")
        }
        if pedi == true
        {
            header.title = NSLocalizedString("pediHeader", comment: "")
        }
        
        choose.title = NSLocalizedString("imgChoose", comment: "")
        loading.text = NSLocalizedString("indicator-loading", comment: "")
    }

}
