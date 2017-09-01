//
//  ViewController.swift
//  Map
//
//  Created by Roberto on 01/09/17.
//  Copyright © 2017 Roberto. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    let geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func toggleMaptype(sender: UISegmentedControl!) {
        if sender.selectedSegmentIndex == 0 {
            self.mapView.mapType = MKMapType.standard
        }
        else if sender.selectedSegmentIndex == 1 {
            self.mapView.mapType = MKMapType.satellite
        }
        else if sender.selectedSegmentIndex == 2 {
            self.mapView.mapType = MKMapType.hybrid
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let address = "Avenida Rebouças, 3506 - São Paulo-SP"
        let title   = "Origem"
        
        searchAddress(address: address, title: title, zoomDegre: 0.005)
    }
    
    func searchAddress(address: String, title: String, zoomDegre: Double) {
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks else {return}
            
            if let location = placemarks.last?.location! {
                self.printLocation(location: location, title: title, zoomDegre: zoomDegre)
            }
        }
    }
    
    func printLocation(location: CLLocation, title: String, zoomDegre: Double) {
        let coordinate = location.coordinate
        NSLog("Location found from Map: %f %f", coordinate.latitude, coordinate.longitude)
        
        let span = MKCoordinateSpanMake(zoomDegre, zoomDegre)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        self.mapView.addAnnotation(annotation)
        
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1, pitch: 1, heading: 1)
        self.mapView.setCamera(camera, animated: true)
        self.mapView.showsUserLocation = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAddress(address: searchBar.text!, title: "Destino", zoomDegre: 0.005)
    }
}
