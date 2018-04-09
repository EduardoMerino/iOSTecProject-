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
    var allPostsData = [Any]()
    var allPostsJSON: [[String: Any]] = []
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //format
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundView = self.backgroundImage
        
        //GET from API
        print("TOKEN from HOME: \(self.token)")
        self.getFromURL()
        
        //format result
        /*
        for element in self.allPostsData{
            guard let elementJSON = try? JSONSerialization.data(withJSONObject: element, options: []) else { return }
            self.allPostsJSON.append(elementJSON as! [String: Any])
        }
        */
        
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
        //cell.nameLabel.text = self.allPostsData[indexPath]["name"] as! String
        
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
                    //print("JSON from HOME: \(self.allPosts["data"]!)")
                    print("JSON from HOME[0]: \(self.allPostsData[0])")
                }catch{
                    print("ERROR from HOME: \(error)")
                }
                
                self.dispatchGroup.leave()
            }
        }.resume()
        dispatchGroup.wait()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
