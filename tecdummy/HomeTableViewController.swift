//
//  HomeTableViewController.swift
//  tecdummy
//
//  Created by eduardo merino padilla on 04/04/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let dispatchGroup = DispatchGroup()
    var token = ""
    var username = ""
    var allPosts = [String: Any]()
    var allPostsData = [[String: Any]]()
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //format
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = self.backgroundImage
        
        //GET from API
        print("TOKEN from HOME: \(self.token)")
        self.getFromURL()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allPostsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TextReminderCell
        
        // Configure the cell...
        //name:
        if let name = self.allPostsData[indexPath.row]["name"] as? String{
            cell.nameLabel.text = name
        }else{ print("Couldnt find name") }
        //date:
        if let date = self.allPostsData[indexPath.row]["date"] as? String{
            cell.dateLabel.text = date
        }else{ print("Coundt find date") }
        //content:
        if let content = self.allPostsData[indexPath.row]["content"] as? String{
            cell.contentLabel.text = content
        }else{ print("couldnt find content")}
        //id.
        if let id = self.allPostsData[indexPath.row]["id"] as? String{
            cell.id = Int(id)!
            print("the ID is: \(cell.id)")
        }else{ print("Couldn't get id") }
        
        return cell
    }
    
    func getFromURL(){
        self.dispatchGroup.enter()
        
        //params
        let params = ["username": self.username, "token": self.token]
        
        //request
        guard let url = URL(string: "https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/posts/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
        request.httpBody = myHttpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        //do stuff with session
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print("RESPONSE from HOME: \(response)")
            }
            if let data = data{
                print("DATA from HOME: \(data)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.allPosts = json as! [String: Any]
                    self.allPostsData = self.allPosts["data"] as! [[String: Any]]
                    print("JSON from HOME[0]: \(self.allPostsData[0])")
                }catch{
                    print("ERROR from HOME: \(error)")
                }
                
                self.dispatchGroup.leave()
            }
        }.resume()
        dispatchGroup.wait()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
        let cell = tableView.cellForRow(at: indexPath) as! TextReminderCell
        
        nextViewController.username = self.username
        nextViewController.token = self.token
        nextViewController.id = cell.id
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }

}
