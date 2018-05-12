//
//  LoginViewController.swift
//  SeniorProject
//
//  Created by Angie on 2/26/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    private var valid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10.0
        //handle keyboard dismiss
        hideKeyboardWhenTappedAround()
        userText.delegate = self
        pwText.delegate = self
        if rememberMeSwitch.isOn {
            if let username: String = KeychainWrapper.standard.string(forKey: "Username") {
                if let password:String = KeychainWrapper.standard.string(forKey: "Password"){
                    userText.text = username
                    pwText.text = password
                }
            }
        }
        //handle keyboard cutting off textfields
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func validateNullEntry() -> Bool {
        if(userText.text == "" || pwText.text == ""){
            self.ShowAlert(title: "Oops", message: "Missing username or password.")
            return false
        }
        return true
    }
    
    @IBAction func login(_ sender: UIButton) {
        if (!validateNullEntry()){ return }
        var user:User? = nil
        if rememberMeSwitch.isOn {
            KeychainWrapper.standard.set(self.userText.text!, forKey: "Username")
            KeychainWrapper.standard.set(self.pwText.text!, forKey: "Password")
            if let username: String = KeychainWrapper.standard.string(forKey: "Username") {
                if let password:String = KeychainWrapper.standard.string(forKey: "Password"){
                    user = User(username: username, password: password)
                }
            }
        }
        else {
            KeychainWrapper.standard.removeObject(forKey: "Username")
            KeychainWrapper.standard.removeObject(forKey: "Password")
            user = User(username: userText.text!, password: pwText.text!)
        }
        
        if let model = user {
            let postString = RestApiManager.sharedInstance.buildLoginPostString(model: model)
            let path = URLConstants.base.appending(URLConstants.login)
            
            RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                (json, err) in
                //            print(json)
                let message = json["message"].stringValue
                print(message)
                self.valid = json["login"].boolValue
                if (!self.valid){
                    self.ShowAlert(title: "Log In", message: message)
                }
                else {
                    if let session = json["store_id"].string {
                        KeychainWrapper.standard.set(session, forKey: "Session")
                    }
                    //pass data to instantiated vc
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! TabBarViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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

extension LoginViewController {
    //MARK: - Textfield protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -55 // Move view 100 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    //MARK: - Indicators/Alerts
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Activity Indicator
//    private func startActivityIndicator(){
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
//    }
//
//    private func stopActivityIndicator(){
//        activityIndicator.stopAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
//    }
}
