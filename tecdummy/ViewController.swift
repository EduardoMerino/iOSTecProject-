//
//  ViewController.swift
//  tecdummy
//
//  Created by UX Lab - ISC Admin on 3/21/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var loginResponse = [String: Any]()
    var token = ""
    var statusCode = 0
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Text field control:
        self.usernameTextfield.delegate = self
        self.usernameTextfield.tag = 0
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 1
        
    }
    
    func myURLRequest(){
        // preparing http request
        let yourUrl = URL(string: "https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/")! // whatever is your url
        let yourAuthorizationToken = "9638dce2-e237-4913-91de-2024562c450d" // whatever is your token
        let yourPayload = Data() // whatever is your payload
        //making request
        var request = URLRequest(url:yourUrl)
        request.httpMethod = "POST"
        request.setValue(yourAuthorizationToken, forHTTPHeaderField: "Authorization")
        request.httpBody = yourPayload
        // executing the call
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            // your stuff here
        })
        task.resume()
    }

    @IBAction func registerButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: nil, preferredStyle: .alert)
        
        alert.addTextField{ (textField:UITextField) in textField.placeholder = "email"}
        let emailTextField = alert.textFields![0]
        alert.addTextField{ (textField2:UITextField) in textField2.placeholder = "password"}
        let passwordTextField = alert.textFields![1]
        
        alert.addAction(UIAlertAction(title: "REGISTER", style: .default, handler: { (action:UIAlertAction) in
            print ("oh ke pressed")
            self.createAccount(email: emailTextField.text!, password: passwordTextField.text!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordButtonClick(_ sender: Any) {
        let forgottenAlert = UIAlertController(title: "Forgot password", message: nil, preferredStyle: .alert)
        forgottenAlert.addAction(UIAlertAction(title: "Recover", style: .default, handler: { (action:UIAlertAction) in print ("recover pressed")}))
        forgottenAlert.addTextField{ (textField:UITextField) in textField.placeholder = "email"}
        forgottenAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(forgottenAlert, animated: true, completion: nil)
    }
    
    //Login button
    @IBAction func loginButtonClick(_ sender: Any) {
        print("Login Clicked user: \(usernameTextfield.text ?? "nada") pass: \(passwordTextField.text ?? "EqjxonEK")")
        
        //login to API
        self.loginUrlSession()
        print("STATUS from LOGIN: \(self.statusCode)")
        print("JSON from LOGIN: \(self.loginResponse)")
        print("TOKEN from LOGIN: \(self.token)")
        
        //react to status code
        switch (self.statusCode){
        case 200:
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTableView") as! HomeTableViewController
            nextViewController.token = self.token
            nextViewController.username = self.usernameTextfield.text!
            self.navigationController?.pushViewController(nextViewController, animated:true)
            
        case 403:
            let forbiddenAlert = UIAlertController(title: "Forbidden", message: "wrong username or password, please try again", preferredStyle: .alert)
            forbiddenAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in print ("OK pressed")}))
        default:
            print("DEFAULT")
            let defaultAlert = UIAlertController(title: "Forbidden Def.", message: "wrong username or password, please try again", preferredStyle: .alert)
            defaultAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in print ("OK pressed")}))
        }
    }
    
    
    //hide keyboard on tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //return key change text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        if textField.tag == 1 {
            self.loginButtonClick(self)
        }
        
        return false
    }
    
    func loginUrlSession(){
        self.dispatchGroup.enter()
        //username and password params
        let username = self.usernameTextfield.text
        let password = self.passwordTextField.text
        let params = ["username": username!, "password": password!]
        
        //request
        guard let url = URL(string: "https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/login/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
        request.httpBody = myHttpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        //do stuff with session
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                self.statusCode = (response as! HTTPURLResponse).statusCode
                print("RESPONSE from LOGIN: \(response)")
            }
            if let data = data{
                print("DATA from LOGIN: \(data)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if (self.statusCode == 200){
                        self.loginResponse = json as! [String: Any]
                        self.token = self.loginResponse["token"] as! String
                    }
                } catch{
                    print("ERROR from LOGIN: \(error)")
                }
            }
            self.dispatchGroup.leave()
        }.resume()
        
        dispatchGroup.wait()
    }
    
    func createAccount(email: String, password: String){
        print("At CREATE ACCOUNT REGISTER: email: \(email) password: \(password)")
        //parameter
        let params = ["email": email, "password": password]
        
        //request
        guard let url = URL(string: "https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/register/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {return}
        request.httpBody = myHttpBody
        //request.addValue(loginString, forHTTPHeaderField: "")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        //do stuff with session
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print("RESPONSE from REGISTER: \(response)")
            }
            if let data = data{
                //print("DATA from REGISTER: \(data)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON from REGISTER: \(json)")
                } catch{
                    print("ERROR from REGISTER: \(error)")
                }
            }
            }.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

