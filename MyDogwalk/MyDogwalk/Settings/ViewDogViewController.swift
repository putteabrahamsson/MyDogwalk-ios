//
//  ViewDogViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-05-24.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewDogViewController: UIViewController
{
    var nameStr: String!
    var breedStr: String!
    var sexStr: String!
    var documentID: String!
    
    var newTimer: String!
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var breed: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var timer: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadData()
        insertTimerArrow()
    }
    
    func loadData()
    {
        fullName.text = nameStr
        breed.text = breedStr
        sex.text = sexStr
    }
    
    

    @IBAction func timerBtnTapped(_ sender: Any)
    {
        timer.inputView = UIView()
        self.performSegue(withIdentifier: "editTimer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
    func insertTimerArrow()
    {
        timer.rightViewMode = UITextField.ViewMode.always
        
        let imageView = UIImageView()
        let image = UIImage(named: "SideArrow")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: 0, width: timer.frame.height / 2, height: timer.frame.height / 2)
        view.addSubview(imageView)
        
        timer.rightView = imageView
    }



}
