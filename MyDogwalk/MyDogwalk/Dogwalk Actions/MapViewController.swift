//
//  MapViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-02-26.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    var locationManager = CLLocationManager()
    
    //Translate
    @IBOutlet weak var mapHeader: UINavigationItem!
    @IBOutlet weak var mapSave: UIBarButtonItem!
    
    
    //Declare labels
    @IBOutlet weak var TimeSet: UILabel!
    @IBOutlet weak var PlayStop: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var KiloMeters: UILabel!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    var play = true
    var counter = 0
    
    //Location array
    var locations: [CLLocationCoordinate2D] = []
    
    //Timer setup
    var timer : Timer?
    var Annotationtimer : Timer?
    var awayTimer: Timer?
    var tstTimer: Timer?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Zoom in to current location
        if let userLocation = locationManager.location?.coordinate
        {
            //Zooming in to current position
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
        }
        
        translateCode()
       
         let app = UIApplication.shared
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: app)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: app)

        
        if TimeSet.text == "00:00:00"
        {
            SaveButton.isEnabled = false
        }
        else
        {
            SaveButton.isEnabled = true
        }
        //Delegating the mapview to self
        mapView.delegate = self
    }
    
    //Translating the language
    func translateCode()
    {
        mapSave.title = NSLocalizedString("mapSave", comment: "")
        mapHeader.title = NSLocalizedString("mapTitle", comment: "")
    }
    
    var start: CFAbsoluteTime = 0.0
   
    @objc func applicationWillResignActive(notification: NSNotification)
    {
        start = CFAbsoluteTimeGetCurrent()
        print("Background entered")
        locationManager.startUpdatingLocation()
        
        tstTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block:
            { (timError) in
            
                if timError != timError
                {
                    print(timError)
                }
                else
                {
                    let lastLocation = self.locations.last!
                    self.locations.append(lastLocation.self)
                    
                    print("Locations retrieved from background: ", self.locations)
                }
        })
        
        
    }
    
    @objc func didBecomeActive(notification: NSNotification)
    {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        print(elapsed)
        //counter = counter + Int(elapsed)
        
        print("Returned to application")
        //locationManager.stopMonitoringSignificantLocationChanges()
        
    }
    
    //-----------------------------------------------------------
    //      When play button is tapped, start a new walk
    //-----------------------------------------------------------
    
    //Start a new walk
    @IBAction func StartWalk(_ sender: Any)
    {
        if play == true
        {
            SaveButton.isEnabled = false
            
            play = false
            
            //Set resetbutton disabled.
            ResetButton.isHidden = true
            
            //Set new image when play is true
            PlayStop.setImage(UIImage(named: "Stop"), for: .normal)
            
            //Checking userpermission to allow map and current location
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.showsBackgroundLocationIndicator = true
                
                //Retrieve current position
                if let userLocation = locationManager.location?.coordinate
                {
                    self.locations.append(userLocation)
                    print(self.locations, "First")
                    
                    //Starts the walk-timer, with interval: 1 second
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
                    
                    //Sending to update
                    update()
                }
            }
            
        }
        //--
        // ELSE, If stop button is tapped.
        //--
        else
        {
            //Set new image when play is false
            PlayStop.setImage(UIImage(named: "Start"), for: .normal)
        
            SaveButton.isEnabled = true
            ResetButton.isHidden = false
            
            play = true
            
            timer?.invalidate()
            Annotationtimer?.invalidate()
            tstTimer?.invalidate()
            
            self.locationManager.stopUpdatingLocation()
            self.locationManager.allowsBackgroundLocationUpdates = false
            self.locationManager.showsBackgroundLocationIndicator = false
            
        }
        
    }
    //Retrieving the distance of the polyline
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {

        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    //-----------------------------------------------------------
    //            Adding current location to array
    //-----------------------------------------------------------
    @objc func update()
    {
        Annotationtimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timerr) in

            self.locations.append((self.locationManager.location?.coordinate)!)
            print(self.locations)
            
            let aPolyLine = MKGeodesicPolyline(coordinates: self.locations, count: self.locations.count)
            
            self.mapView.addOverlay(aPolyLine)
            
            var total: Double = 0.0
            for i in 0..<self.locations.count - 1
            {
                let start = self.locations[i]
                let end = self.locations[i + 1]
                let distance = self.getDistance(from: start, to: end)
                total += distance
            }
            
            self.KiloMeters.text = ""
            let y = total / 10
            let result = round(100 * y) / 10
            self.KiloMeters.text = String(result) + " m"

            //Zoom in to current location
            if let userLocation = self.locationManager.location?.coordinate
            {
                //Zooming in to current position
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 0, longitudinalMeters: 0)
                self.mapView.setRegion(viewRegion, animated: true)
            }
        })
    }
    
    //-----------------------------------------------------------
    //           Create a polyline using coordinates in array
    //-----------------------------------------------------------
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if(overlay is MKPolyline)
        {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.blue.withAlphaComponent(1)
            polyLineRender.lineWidth = 3
            
            return polyLineRender
        }
        
        return MKPolylineRenderer()
    }
    
    //-----------------------------------------------------------
    //   Update the timer to check how long the walk was.
    //-----------------------------------------------------------
    
    @objc func updateCounter()
    {
        //Updating timer-function
        print(counter)
        let hours = counter / 3600
        let mins = counter / 60 % 60
        let secs = counter % 60
        let restTime = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        
        counter += 1
        TimeSet.text = String(restTime)
        
    }
    
    //-----------------------------------------------------------
    //          Clearing the walk. (Removes all data)
    //-----------------------------------------------------------
    @IBAction func ClearWalk(_ sender: Any)
    {
        let alert = UIAlertController(title: NSLocalizedString("suhr", comment: ""), message: NSLocalizedString("remMap", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("remAbort", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alertActionError) in
            
            //CLOSING THE ALERT
        }))
        
            alert.addAction(UIAlertAction(title: NSLocalizedString("removeMap", comment: ""), style: UIAlertAction.Style.default, handler: { (alertActionError) in
                
                self.SaveButton.isEnabled = false
                
                //Clearing the walk. Sets all indexes to 0.
                self.timer?.invalidate()
                self.counter = 0
                self.TimeSet.text = "00:00:00"
                self.KiloMeters.text = "0 m"
                self.locations = []
                self.tstTimer?.invalidate()
                print("Nuvarande platser: ", self.locations)
                
                self.mapView.removeOverlays(self.mapView.overlays)
                
                
                
                //Removing all annotations from the mapview
                self.mapView.removeAnnotations(self.mapView.annotations)
                
            }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //-----------------------------------------------------------
    //  Button to save annotations, distance and time.
    //-----------------------------------------------------------

    @IBAction func SaveDataInfo(_ sender: Any)
    {
        performSegue(withIdentifier: "saveContent", sender: self)
    }
    
    //-----------------------------------------------------------
    //               Prepare for a segue
    //-----------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! DogwalkViewController
        
        vc.timer = TimeSet.text!
        vc.kilometers = KiloMeters.text!
        
        vc.locations = locations
    }
}
