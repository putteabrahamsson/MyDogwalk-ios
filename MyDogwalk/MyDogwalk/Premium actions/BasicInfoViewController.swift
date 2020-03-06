//
//  BasicInfoViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class BasicInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hdr: UINavigationItem!
    @IBOutlet weak var choose: UIBarButtonItem!
    
    //Passing values to save in userdefaults
    var u_dogId: String!
    var u_regNr: String!
    var u_dogName: String!
    var u_breed: String!
    var u_dob: String!
    var u_gender: String!
    var u_color: String!
    
    var u_ownership: String!
    var u_address: String!
    var u_phone: String!
    
    var u_dateForCast: String!
    var u_veterinary: String!
    
    var sections = [NSLocalizedString("basic-sec-info", comment: ""), NSLocalizedString("basic-sec-ownership", comment: ""), NSLocalizedString("basic-sec-castration", comment: "")]
    
    var labelNames =
    [
        [NSLocalizedString("basic-lbl-dogid", comment: ""), NSLocalizedString("basic-lbl-reg", comment: ""), NSLocalizedString("basic-lbl-dogname", comment: ""), NSLocalizedString("basic-lbl-breed", comment: ""),
             NSLocalizedString("basic-lbl-born", comment: ""),
             NSLocalizedString("basic-lbl-gender", comment: ""),
             NSLocalizedString("basic-lbl-color", comment: "")],
        
        [NSLocalizedString("basic-lbl-owner", comment: ""), NSLocalizedString("basic-lbl-address", comment: ""), NSLocalizedString("basic-lbl-phone", comment: "")],
        
        [NSLocalizedString("basic-lbl-date", comment: ""), NSLocalizedString("basic-lbl-veterinary", comment: "")]
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        translateCode()
    }
    
    func translateCode()
    {
        hdr.title = NSLocalizedString("basicInfoHdr", comment: "")
        choose.title = NSLocalizedString("basicInfoChoose", comment: "")
    }

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
        return labelNames[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath == [0, 0]
        {
            let cell:customDogId = tableView.dequeueReusableCell(withIdentifier: "customDogId", for: indexPath) as! customDogId
            
            cell.lbl_dogId.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_dogID.text = UserDefaults.standard.value(forKey: "u-dogId") as? String
            
            return cell
        }
        if indexPath == [0, 1]
        {
            let cell:customReg = tableView.dequeueReusableCell(withIdentifier: "customReg", for: indexPath) as! customReg
            
            cell.lbl_reg.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_reg.text = UserDefaults.standard.value(forKey: "u-regNr") as? String
            
            return cell
        }
        if indexPath == [0, 2]
        {
            let cell:customDogName = tableView.dequeueReusableCell(withIdentifier: "customDogName", for: indexPath) as! customDogName
            
            cell.lbl_dogname.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_dogname.text = UserDefaults.standard.value(forKey: "nameKey") as? String
            
            return cell
        }
        if indexPath == [0, 3]
        {
            let cell:customBreed = tableView.dequeueReusableCell(withIdentifier: "customBreed", for: indexPath) as! customBreed
            
            cell.lbl_breed.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_breed.text = UserDefaults.standard.value(forKey: "breedKey") as? String
            
            return cell
        }
        
        if indexPath == [0, 4]
        {
            let cell:customBorn = tableView.dequeueReusableCell(withIdentifier: "customBorn", for: indexPath) as! customBorn
            
            cell.lbl_born.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_born.text = UserDefaults.standard.value(forKey: "dobKey") as? String
            
            return cell
        }
        
        if indexPath == [0, 5]
        {
            let cell:customGender = tableView.dequeueReusableCell(withIdentifier: "customGender", for: indexPath) as! customGender
            
            cell.lbl_gender.text = labelNames[indexPath.section][indexPath.row]
            
            let segId = UserDefaults.standard.value(forKey: "sexKey") as? String
             cell.seg_gender.setTitle(NSLocalizedString("basic-seg-0", comment: ""), forSegmentAt: 0)
            cell.seg_gender.setTitle(NSLocalizedString("basic-seg-1", comment: ""), forSegmentAt: 1)
            cell.seg_gender.setTitle(NSLocalizedString("basic-seg-2", comment: ""), forSegmentAt: 2)
            
            
            if segId == "0"
            {
                cell.seg_gender.selectedSegmentIndex = 0
            }
            else if segId == "1"
            {
                cell.seg_gender.selectedSegmentIndex = 1
            }
            else
            {
                cell.seg_gender.selectedSegmentIndex = 2
            }
            
            return cell
        }
        if indexPath == [0, 6]
        {
            let cell:customColor = tableView.dequeueReusableCell(withIdentifier: "customColor", for: indexPath) as! customColor
            
            cell.lbl_color.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_color.text = UserDefaults.standard.value(forKey: "u-color") as? String
            
            return cell
        }
        //Ownership
        if indexPath == [1, 0]
        {
            let cell:customOwner = tableView.dequeueReusableCell(withIdentifier: "customOwner", for: indexPath) as! customOwner
            
            cell.lbl_owner.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_owner.text = UserDefaults.standard.value(forKey: "u-owner") as? String
            
            return cell
        }
        if indexPath == [1, 1]
        {
            let cell:customAddress = tableView.dequeueReusableCell(withIdentifier: "customAddress", for: indexPath) as! customAddress
            
            cell.lbl_address.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_address.text = UserDefaults.standard.value(forKey: "u-address") as? String
            
            return cell
        }
        if indexPath == [1, 2]
        {
            let cell:customPhone = tableView.dequeueReusableCell(withIdentifier: "customPhone", for: indexPath) as! customPhone
            
            cell.lbl_phone.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_phone.text = UserDefaults.standard.value(forKey: "u-phone") as? String
            
            return cell
        }
        //Castration
        if indexPath == [2, 0]
        {
            let cell:customDate = tableView.dequeueReusableCell(withIdentifier: "customDate", for: indexPath) as! customDate
            
            cell.lbl_date.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_date.text = UserDefaults.standard.value(forKey: "u-date") as? String
            
            return cell
        }
        if indexPath == [2, 1]
        {
            let cell:customVeterinary = tableView.dequeueReusableCell(withIdentifier: "customVeterinary", for: indexPath) as! customVeterinary
            
            cell.lbl_veterinary.text = labelNames[indexPath.section][indexPath.row]
            cell.txtfield_veterinary.text = UserDefaults.standard.value(forKey: "u-veterinary") as? String
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    //Adding heights to cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    //Options to save or remove
    @IBAction func choose(_ sender: Any)
    {

        u_dogId = UserDefaults.standard.value(forKey: "basic-dogId") as? String
        u_regNr = UserDefaults.standard.value(forKey: "basic-regNr") as? String
        u_color = UserDefaults.standard.value(forKey: "basic-color") as? String
        u_ownership = UserDefaults.standard.value(forKey: "basic-owner") as? String
        u_address = UserDefaults.standard.value(forKey: "basic-address") as? String
        u_phone = UserDefaults.standard.value(forKey: "basic-phone") as? String
        u_dateForCast = UserDefaults.standard.value(forKey: "basic-date") as? String
        u_veterinary = UserDefaults.standard.value(forKey: "basic-veterinary") as? String
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "basic-dogId")
        prefs.removeObject(forKey: "basic-regNr")
        prefs.removeObject(forKey: "basic-color")
        prefs.removeObject(forKey: "basic-owner")
        prefs.removeObject(forKey: "basic-address")
        prefs.removeObject(forKey: "basic-phone")
        prefs.removeObject(forKey: "basic-date")
        prefs.removeObject(forKey: "basic-veterinary")
        
        UserDefaults.standard.set(u_dogId, forKey: "u-dogId")
        UserDefaults.standard.set(u_regNr, forKey: "u-regNr")
        UserDefaults.standard.set(u_color, forKey: "u-color")
        UserDefaults.standard.set(u_ownership, forKey: "u-owner")
        UserDefaults.standard.set(u_address, forKey: "u-address")
        UserDefaults.standard.set(u_phone, forKey: "u-phone")
        UserDefaults.standard.set(u_dateForCast, forKey: "u-date")
        UserDefaults.standard.set(u_veterinary, forKey: "u-veterinary")
        
      if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
            
            self.present(vc, animated: true, completion: nil)
        } 
    }
}

//Classes for custom tableview cell
class customDogId: UITableViewCell
{
    @IBOutlet weak var lbl_dogId: UILabel!
    @IBOutlet weak var txtfield_dogID: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_dogID.text, forKey: "basic-dogId")
    }
}
class customReg: UITableViewCell
{
    @IBOutlet weak var lbl_reg: UILabel!
    @IBOutlet weak var txtfield_reg: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_reg.text, forKey: "basic-regNr")
    }
}
class customDogName: UITableViewCell
{
    @IBOutlet weak var lbl_dogname: UILabel!
    @IBOutlet weak var txtfield_dogname: UITextField!

}
class customBreed: UITableViewCell
{
    @IBOutlet weak var lbl_breed: UILabel!
    @IBOutlet weak var txtfield_breed: UITextField!

}
class customBorn: UITableViewCell
{
    @IBOutlet weak var lbl_born: UILabel!
    @IBOutlet weak var txtfield_born: UITextField!
}
class customGender: UITableViewCell
{
    @IBOutlet weak var lbl_gender: UILabel!
    @IBOutlet weak var seg_gender: UISegmentedControl!
}
class customColor: UITableViewCell
{
    @IBOutlet weak var lbl_color: UILabel!
    @IBOutlet weak var txtfield_color: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_color.text, forKey: "basic-color")
    }
}
//Ownership
class customOwner: UITableViewCell
{
    @IBOutlet weak var lbl_owner: UILabel!
    @IBOutlet weak var txtfield_owner: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_owner.text, forKey: "basic-owner")

    }
}
class customAddress: UITableViewCell
{
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var txtfield_address: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_address.text, forKey: "basic-address")

    }
    
}
class customPhone: UITableViewCell
{
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var txtfield_phone: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_phone.text, forKey: "basic-phone")
    }
}
//Veterinary
class customDate: UITableViewCell
{

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var txtfield_date: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_date.text, forKey: "basic-date")
    }
}
class customVeterinary: UITableViewCell
{
    @IBOutlet weak var lbl_veterinary: UILabel!
    @IBOutlet weak var txtfield_veterinary: UITextField!
    
    @IBAction func newValues(_ sender: Any)
    {
        print("Value changed and saved")
        UserDefaults.standard.set(txtfield_veterinary.text, forKey: "basic-veterinary")
    }
}
