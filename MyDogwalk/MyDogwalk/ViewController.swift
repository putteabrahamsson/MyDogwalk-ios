//
//  ViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-19.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import AVKit

class ViewController: UIViewController
{
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_register: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_login.layer.cornerRadius = 5.0
        btn_register.layer.cornerRadius = 5.0
        
        //viewDidLayoutSubviews()
        //setupView()
        translateCode()
        
        
        //Checking if user is signed in already.
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil
            {
                // User is signed in.
                self.performSegue(withIdentifier: "loggedInAlready", sender: self)
            }
        }
    }
   
    //Translating the language
    func translateCode()
    {
        btn_login.setTitle(NSLocalizedString("btnLogin", comment: "Login button of the index page"), for: .normal)
        btn_register.setTitle(NSLocalizedString("btnRegister", comment: "Register button of the index page"), for: .normal)
    }
    
    /*private func setupView()
    {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "mydogwalkvideo", ofType: ".mp4")!)

        
        let player = AVPlayer(url: path)
        
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.videoDidPlayToEnd(notification:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
    }
    
    @objc func videoDidPlayToEnd(notification: Notification)
    {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        //player.seek(to: CMTime.zero)
        player.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        self.videoView.frame = self.view.bounds
    } */


}

