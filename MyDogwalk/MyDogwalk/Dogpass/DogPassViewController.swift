//
//  DogPassViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-03-08.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class DogPassViewController: UIViewController
{
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var lbl_social: UILabel!
    @IBOutlet weak var btn_insurance: UIButton!
    @IBOutlet weak var btn_veterinary: UIButton!
    @IBOutlet weak var btn_vaccination: UIButton!
    @IBOutlet weak var btn_training: UIButton!
    @IBOutlet weak var btn_competition: UIButton!
    @IBOutlet weak var btn_documentation: UIButton!
    @IBOutlet weak var btn_weight: UIButton!
    @IBOutlet weak var lbl_history: UILabel!
    @IBOutlet weak var lbl_dogpass: UILabel!
    @IBOutlet weak var lbl_settings: UILabel!
    
//-----------------------------------------------------------
//                  ViewDidLoad
//-----------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        translateCode()
    }
    
    //Translating the language
    func translateCode()
    {
        header.title = NSLocalizedString("dogpassHeader", comment: "")
        lbl_social.text = NSLocalizedString("social", comment: "")
        lbl_history.text = NSLocalizedString("dpHistory", comment: "")
        lbl_dogpass.text = NSLocalizedString("dpDogpass", comment: "")
        lbl_settings.text = NSLocalizedString("dpSettings", comment: "")
        
        btn_insurance.setTitle(NSLocalizedString("insurance", comment: ""), for: .normal)
        btn_veterinary.setTitle(NSLocalizedString("veterinary", comment: ""), for: .normal)
        btn_vaccination.setTitle(NSLocalizedString("vaccination", comment: ""), for: .normal)
        btn_training.setTitle(NSLocalizedString("training", comment: ""), for: .normal)
        btn_competition.setTitle(NSLocalizedString("competition", comment: ""), for: .normal)
        btn_documentation.setTitle(NSLocalizedString("documentation", comment: ""), for: .normal)
        btn_weight.setTitle(NSLocalizedString("weight", comment: ""), for: .normal)
    }
    
//-----------------------------------------------------------------
//                     Dogpass buttons (Upgrade to use)
//-----------------------------------------------------------------
    @IBAction func jordbruksverket(_ sender: Any)
    {
        alertText()
    }
    @IBAction func insurance(_ sender: Any)
    {
        alertText()
    }
    @IBAction func veterinary(_ sender: Any)
    {
        alertText()
    }
    @IBAction func vaccination(_ sender: Any)
    {
        alertText()
    }
    @IBAction func training(_ sender: Any)
    {
        alertText()
    }
    @IBAction func competition(_ sender: Any)
    {
        alertText()
    }
    @IBAction func documentation(_ sender: Any)
    {
        alertText()
    }
    @IBAction func weightcontrol(_ sender: Any)
    {
        alertText()
    }
    
    //Send out an alert if button is tapped
    func alertText()
    {
        let alert = UIAlertController(title: NSLocalizedString("upgrade", comment: ""), message: NSLocalizedString("required", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
//-----------------------------------------------------------------
//                     Buttons for Navigation
//-----------------------------------------------------------------
    //Social media
    @IBAction func social(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    @IBAction func Dogwalk(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func History(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func Settings(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
