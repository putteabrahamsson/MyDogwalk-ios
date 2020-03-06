//
//  ViewRowViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-26.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class ViewRowViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var extraBar: UINavigationBar!
    
    //Translate
    @IBOutlet weak var rowHeader: UINavigationItem!
    
    //Calling Firestore
    let db = Firestore.firestore()
    //Location manager.
    var locationManager = CLLocationManager()
    
    //Variables to be called
    var dog = ""
    var who = ""
    var what = ""
    var time = ""
    var date = ""
    var timer = ""
    var kilometer = ""
    var documentID = ""
    var note = ""
    
    var imgUrl:[String] = []
    
    //Two arrays for Double, thats going to merge into locations.
    var latitude:[Double] = []
    var longitude:[Double] = []
    //Array for CLLocationCooridnate2D
    var locations: [CLLocationCoordinate2D] = []
    
    var bath = false
    
    
    @IBOutlet weak var topController: UINavigationBar!
    //Walk related
    @IBOutlet weak var txtfield_dog: UILabel!
    @IBOutlet weak var txtfield_who: UILabel!
    @IBOutlet weak var txtfield_what: UILabel!
    @IBOutlet weak var txtfield_time: UILabel!
    @IBOutlet weak var txtfield_date: UILabel!
    //Time and Kilometer
    @IBOutlet weak var Kilometers: UILabel!
    @IBOutlet weak var Timer: UILabel!
    //Map related
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topcontroller: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var map: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var notes: UIBarButtonItem!
    
    //Start function.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if note != ""
        {
            notes.isEnabled = true
        }
        
        translateCode()
    
        mapView.delegate = self
        insertInMap()
        
        //If boolean bath is equal to true. Run this code snippet
        if bath == true
        {
            txtfield_dog.text = dog
            txtfield_who.text = who
            txtfield_what.text = what
            txtfield_time.text = time
            txtfield_date.text = date
            Timer.text = timer
            Kilometers.text = kilometer
            
            mapView.isHidden = true
            Timer.isHidden = true
            Kilometers.isHidden = true
        }
        //Else, normal run
        else
        {
            txtfield_dog.text = dog
            txtfield_who.text = who
            txtfield_what.text = what
            txtfield_time.text = time
            txtfield_date.text = date
            Timer.text = timer
            Kilometers.text = kilometer
            
            //If timer and kilometer is equal to zero, hide and change text
            if(Timer.text == "00:00:00" && Kilometers.text == "0 m")
            {
                Kilometers.text = NSLocalizedString("noResult", comment: "")
                //"Ingen promenad statisk hittades.."
                Timer.isHidden = true
                mapView.isHidden = true
            }
            else
            {
                map.isEnabled = true
            }
            //Checking if imagearray is not empty
            if imgUrl != []
            {
                camera.isEnabled = true
            }
            else
            {
                camera.isEnabled = false
            }
        }
    }
    
    //Translating the language
    func translateCode()
    {
        rowHeader.title = NSLocalizedString("rowHeader", comment: "")
    }
    
    //--------------------------------------------------------------------
    //                 Retrieve the cooridnates and insert into map
    //--------------------------------------------------------------------
    
    func insertInMap()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            //Request authorization
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            assert(latitude.count == longitude.count, "Both arrays must contain the same number of items")
            locations = zip(latitude, longitude).map(CLLocationCoordinate2D.init)
            
            let user = locations.first
            
            //Zooming in to current position
            let viewRegion = MKCoordinateRegion(center: user!, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
            
            //Creating a start annotation
            let annotation = MKPointAnnotation()
            annotation.title = "Start"
            annotation.coordinate = locations.first!
            mapView.addAnnotation(annotation)
            
            //Creating a stop annotation
            let stopAnno = MKPointAnnotation()
            stopAnno.title = "Stop"
            stopAnno.coordinate = locations.last!
            mapView.addAnnotation(stopAnno)

            //Draw polyline on the map
            let aPolyLine = MKPolyline(coordinates: self.locations, count: self.locations.count)
            
            //Adding polyline to mapview
            self.mapView.addOverlay(aPolyLine)
            
            print(locations)
        }
    }
    
    //-----------------------------------------------------------
    //                 Create a polyline
    //-----------------------------------------------------------
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if(overlay is MKPolyline)
        {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            //Polyline color and width.
            polyLineRender.strokeColor = UIColor.blue.withAlphaComponent(1)
            polyLineRender.lineWidth = 3
            
            return polyLineRender
        }
        
        return MKPolylineRenderer()
    }

    //NAVIGATION BUTTONS
    @IBAction func mapTapped(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewMapViewController") as! ViewMapViewController
            
            vc.locations = locations
            vc.kilometer = kilometer
            vc.timer = timer
            vc.documentID = documentID
            vc.dog = dog
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewImgViewController") as! ViewImgViewController
            
            
            vc.downloadURL = imgUrl
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func noteTapped(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewNoteViewController") as! ViewNoteViewController
            
            vc.note = note
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    //Share route
    @IBAction func shareTapped(_ sender: Any)
    {
        let img = screenShotMethod()
        

       let txt = String(format: NSLocalizedString("share", comment: ""),txtfield_dog.text!, Kilometers.text!, Timer.text!)
        
        let link = "https://itunes.apple.com/se/app/mydogwalk/id1464139139?mt=8"
        
        let activityVC = UIActivityViewController(activityItems: [img, txt, link], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.markupAsPDF]
        
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    
        view.backgroundColor = UIColor.init(red: 63/255, green: 236/255, blue: 201/255, alpha: 1)
        toolbar.isHidden = false
        topcontroller.isHidden = false
        extraBar.isHidden = false
    }
    
    func screenShotMethod()->UIImage
    {
        view.backgroundColor = .white
        toolbar.isHidden = true
        topcontroller.isHidden = true
        extraBar.isHidden = true
        
        let layer = self.view.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
    
    
    //-----------------------------------------------------------
    //                 Buttons for navigation
    //-----------------------------------------------------------
    
    @IBAction func GoBack(_ sender: Any)
    {
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //Go back to Dogwalk aka Homepage
    @IBAction func DogwalkButton(_ sender: Any)
    {
        if let storyboard = self.storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "DogwalkViewController") as! DogwalkViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }

    //Settings
    @IBAction func Settings(_ sender: Any)
    {
        if let storyboard = storyboard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            
            self.present(vc, animated: false, completion: nil)
        }
    }
    

    
}
