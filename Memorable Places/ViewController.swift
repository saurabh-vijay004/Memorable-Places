//
//  ViewController.swift
//  Memorable Places
//
//  Created by Saurabh on 5/24/18.
//  Copyright © 2018 Saurabh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        let uiLongPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(gestureRecogniser:)))
        
        uiLongPressGestureRecogniser.minimumPressDuration = 2
        
        map.addGestureRecognizer(uiLongPressGestureRecogniser)
        
        if activePlace == -1 {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.stopUpdatingLocation()
            
        } else {
         
           //get places details to display
           
            if places.count > activePlace {
                
                if let name = places[activePlace]["name"]{
                    
                    if let lat = places[activePlace]["lat"]{
                        
                        if let lon = places[activePlace]["lon"]{
                            
                            if let longitude = Double(lon){
                                if let latitude = Double(lat) {
                                   
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                                    let region = MKCoordinateRegion(center: coordinates, span: span)
                                    
                                    map.setRegion(region, animated: true)
                                    
                                    var annotation = MKPointAnnotation();
                                    annotation.coordinate = coordinates
                                    annotation.title = name
                                    
                                    map.addAnnotation(annotation)
                                    
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            }
            
           let name = places[activePlace]["name"]
            
            
        }
        
    }
    
    func longpress(gestureRecogniser: UIGestureRecognizer){
        
        
        if gestureRecogniser.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecogniser.location(in: self.map)
            
            let coordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)
                in
                
                if error != nil{
                    
                    print(error)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if (placemark.subThoroughfare != nil) {
                            
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if (placemark.thoroughfare != nil) {
                            
                            title += placemark.thoroughfare! + " "
                            
                        }
                        
                        if title == "" {
                            title = "Added \(NSDate())"
                        }
                        
                        let annotaion = MKPointAnnotation()
                        
                        annotaion.coordinate = coordinate
                        annotaion.title = title
                        
                        print(placemark)
                        self.map.addAnnotation(annotaion)
                        
                        places.append(["name":title,"lat":String(coordinate.latitude),"lon":String(coordinate.longitude)])
                        UserDefaults.standard.setValue(places, forKey: "places")
                        
                    }
                    
                }
            
            })
            
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

