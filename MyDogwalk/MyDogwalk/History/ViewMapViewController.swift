//
//  ViewMapViewController.swift
//  MyDogwalk
//
//  Created by Putte on 2019-06-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMobileAds

class ViewMapViewController: UIViewController, GADBannerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var advertisementBanner: GADBannerView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var header: UINavigationItem!
    
    @IBOutlet weak var km: UILabel!
    @IBOutlet weak var tmr: UILabel!
    
    @IBOutlet weak var topbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var locations: [CLLocationCoordinate2D] = []
    var locationManager = CLLocationManager()
    
    var documentID = ""
    var kilometer = ""
    var timer = ""
    var dog = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        translateCode()
        
        //Inserting timer and kilometer into labels
        km.text = kilometer
        tmr.text = timer
        
        mapView.delegate = self
        insertInMap()
        
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
    
    //-----------------------------------------------------------
    //                 Insert coordinates into map
    //-----------------------------------------------------------
    func insertInMap()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            //Request authorization
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()

            let user = locations.first
            
            //Zooming in to current position
            let viewRegion = MKCoordinateRegion(center: user!, latitudinalMeters: 300, longitudinalMeters: 300)
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
    
    //-----------------------------------------------------------
    //                      Share walk
    //-----------------------------------------------------------
    @IBAction func shareWalk(_ sender: Any)
    {
        let img = screenShotMethod()
        
        
        let txt = String(format: NSLocalizedString("share", comment: ""), dog, km.text!, tmr.text!)
        
        let link = "https://itunes.apple.com/se/app/mydogwalk/id1464139139?mt=8"
        
        let activityVC = UIActivityViewController(activityItems: [img, txt, link], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.markupAsPDF]
        
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
        view.backgroundColor = UIColor.white
        
        toolbar.isHidden = false
        topbar.isHidden = false
    }
    
    func screenShotMethod()->UIImage
    {
        view.backgroundColor = .white
        toolbar.isHidden = true
        topbar.isHidden = true
        
        let layer = self.view.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
    
    //-----------------------------------------------------------
    //                     Translate code
    //-----------------------------------------------------------
    func translateCode()
    {
        header.title = NSLocalizedString("view-map-header", comment: "")
    }
}
