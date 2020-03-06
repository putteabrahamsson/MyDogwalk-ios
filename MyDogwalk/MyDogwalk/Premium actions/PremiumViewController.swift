//
//  PremiumViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-16.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class PremiumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var editMode = false
    
    //Save Download URLs from PremImgViewController
    var downloadVet:[String] = []
    var downloadDoc:[String] = []
    var downloadInsu:[String] = []
    var downloadPedi:[String] = []
    
    
    //Sections in tableview
    var sections = [NSLocalizedString("prem-header-vacc", comment: ""), NSLocalizedString("prem-header-info", comment: ""), NSLocalizedString("prem-header-activity", comment: ""), NSLocalizedString("prem-header-other", comment: "")]
    
    //Images inside buttons
    var buttonImgs =
    [
        //Vaccination
        [UIImage(named: "information")!, UIImage(named: "vaccination")!],
        //Information
        [UIImage(named: "veterinary")!, UIImage(named: "documentation")!, UIImage(named: "insurance")!],
        //Activity
        [UIImage(named: "course")!, UIImage(named: "competitive")!],
        //Other
        [UIImage(named: "pedigree")!, UIImage(named: "weightcontroll")!, UIImage(named: "other")!]
    ]
    
    //Button names
    var buttonName =
    [
        //Vaccination
        [NSLocalizedString("prem-info", comment: ""), NSLocalizedString("prem-vaccination", comment: "")],
        //Information
        [NSLocalizedString("prem-veterinary", comment: ""), NSLocalizedString("prem-documentation", comment: ""), NSLocalizedString("prem-insurance", comment: "")],
        //Activity
        [NSLocalizedString("prem-course", comment: ""), NSLocalizedString("prem-comp", comment: "")],
        //Other
        [NSLocalizedString("prem-pedigree", comment: ""), NSLocalizedString("prem-weight", comment: ""), NSLocalizedString("prem-other", comment: "")]
    ]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Tableview proporties
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "premiumCell", for: indexPath) as! PremiumTableViewCell
        
        cell.buttonName.text = buttonName[indexPath.section][indexPath.row]
        cell.buttonIcon.image = buttonImgs[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
            return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Vaccination
        if indexPath == [0, 0]
        {
            print("Basic information tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "BasicInfoViewController") as! BasicInfoViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        if indexPath == [0, 1]
        {
            print("Vaccinations tapped")
            createTemporaryAlert()
        }
        
        //Information
        if indexPath == [1, 0]
        {
            print("Veterinary tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremImgViewController") as! PremImgViewController
                
                vc.vet = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        if indexPath == [1, 1]
        {
            print("Documentation tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremImgViewController") as! PremImgViewController
                
                vc.docu = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        if indexPath == [1, 2]
        {
            print("Insuranceletter tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremImgViewController") as! PremImgViewController
                
                vc.insu = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        //Activity
        if indexPath == [2, 0]
        {
            print("Courses tapped")
            createTemporaryAlert()
        }
        if indexPath == [2, 1]
        {
            print("Competition tapped")
            createTemporaryAlert()
        }
        
        //Other
        if indexPath == [3, 0]
        {
            print("Pedigree tapped")
            
            if let storyboard = storyboard
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "PremImgViewController") as! PremImgViewController
                
                vc.pedi = true
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        if indexPath == [3, 1]
        {
            print("Weightcontroll tapped")
            createTemporaryAlert()
        }
        if indexPath == [3, 2]
        {
            print("Other tapped")
            createTemporaryAlert()
        }
    }
    
    func createTemporaryAlert()
    {
        let alert = UIAlertController(title: NSLocalizedString("temp-title", comment: ""), message: NSLocalizedString("temp-body", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("temp-ok", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            //OK
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
