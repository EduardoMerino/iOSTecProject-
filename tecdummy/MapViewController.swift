//
//  MapViewController.swift
//  tecdummy
//
//  Created by eduardo merino padilla on 10/04/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var address = ""
    //let locationManager = CLLocationManager()
    var initialLocation = CLLocation()
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coordenatesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update labels
        self.addressLabel.text = self.address
        self.coordenatesLabel.text = "\(self.latitude), \(self.longitude)"
        
        //initial location
         self.initialLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        centerMapToLocation(coordinate: initialLocation.coordinate)
        
    }

    
    func centerMapToLocation(coordinate: CLLocationCoordinate2D){
        let distance: CLLocationDistance = 100
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        myMapView.setRegion(region, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
