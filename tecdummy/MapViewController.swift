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
    var id: Int = 0
    
    let dispatchGroup = DispatchGroup()
    var allPosts = [String: Any]()
    var allPostsData = [String: Any]()
    
    var username: String = ""
    var token: String = ""
    
    var initialLocation = CLLocation()
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coordenatesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call API
        self.getFromURL()
        
        //update labels
        if let my_address = self.allPostsData["address"] as? String {
            self.addressLabel.text = my_address
        }else{
           self.addressLabel.text = "coulndt get address"
        }
        
        if let my_latitude = self.allPostsData["latitude"] as? Double {
            self.latitude = my_latitude
        }else{
            self.latitude = 1.2
        }
        
        if let my_longitud = self.allPostsData["longitude"] as? Double {
            self.longitude = my_longitud
        }else{
            self.longitude = 3.4
        }
        
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
    
    func getFromURL(){
        self.dispatchGroup.enter()
        
        //params
        let params = ["username": self.username, "token": self.token]
        
        //request
        guard let url = URL(string: "https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/posts/\(self.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
        request.httpBody = myHttpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        //do stuff with session
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print("RESPONSE from MAP: \(response)")
            }
            if let data = data{
                print("DATA from MAP: \(data)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.allPosts = json as! [String: Any]
                    self.allPostsData = self.allPosts["data"] as! [String: Any]
                    print("JSON from MAP: \(self.allPosts)")
                }catch{
                    print("ERROR from MAP: \(error)")
                }
                
                self.dispatchGroup.leave()
            }
            }.resume()
        dispatchGroup.wait()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
