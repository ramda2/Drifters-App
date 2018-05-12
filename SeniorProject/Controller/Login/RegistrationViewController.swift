//
//  RegistrationViewController.swift
//  SeniorProject
//
//  Created by Angie on 2/28/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    //fields inside of detailView
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var licenseText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var phoneText: UITextField!

    @IBOutlet weak var createView: UIView!
    //fields inside of createView
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    private var user:UserDetails?
    private var valid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10.0
        createView.isHidden = true
        prepareEntryFields()
        hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
    }
    
    @IBAction func next(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Next"){
            if (nameText.text == "" || licenseText.text == "" || addressText.text == "" || cityText.text == "" || cityText.text == "" ||
                stateText.text == "" || zipText.text == "" || phoneText.text == "") {
                ShowAlert(title: "Oops", message: "Enter all fields to continue.")
            }
            else {
                UIView.animate(withDuration: 1.5, delay: 0.0, options: [], animations: {
                    self.detailView.isHidden = true
                    self.nextButton.setTitle("Register", for: .normal)
                    self.createView.isHidden = false
                }, completion: { (finished: Bool) in
                })
            }
        }
        else {
            if (emailText.text == "" || usernameText.text == "" || passwordText.text == "") {
                ShowAlert(title: "Oops", message: "Enter all fields to continue.")
            }
            else {
                let name = nameText.text
                let license = licenseText.text
                let address = addressText.text
                let city = cityText.text
                let state = stateText.text
                let zip = zipText.text
                let phone = phoneText.text
                let email = emailText.text
                let username = usernameText.text
                let password = passwordText.text
                
                user = UserDetails(name: name!, license: license!, address: address!, city: city!, state: state!, zip: zip!, email: email!, phone: phone!, username: username!, password: password!)
            
                let postString = RestApiManager.sharedInstance.buildRegistrationPostString(model: user!)
                let path = URLConstants.base.appending(URLConstants.registration)
                RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                    (json, err) in
                    print(json)
                    self.valid = json["register"].boolValue
                    if (self.valid){
                        self.ShowAlert(title: json["message"].stringValue, message: json["response"].stringValue)
                        clearAllFields()
                    }
                    else {
                        self.ShowAlert(title: "Register", message: json["message"].stringValue)
                    }
                }
            }
        }
        
        func clearAllFields(){
            nameText.text = ""
            licenseText.text = ""
            addressText.text = ""
            cityText.text = ""
            stateText.text = ""
            zipText.text = ""
            emailText.text = ""
            phoneText.text = ""
            usernameText.text = ""
            passwordText.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [], animations: {
            self.detailView.isHidden = false
            self.nextButton.setTitle("Next", for: .normal)
            self.createView.isHidden = true
        }, completion: { (finished: Bool) in
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension RegistrationViewController {
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -95 // Move view points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
}

extension RegistrationViewController {
    //MARK: - Textfield protocol
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        if( textField == zipText ||
            textField == phoneText) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textField.resignFirstResponder()
        return true
    }
    
    //Prepare textfield entry
    func prepareEntryFields(){
        nameText.delegate = self
        licenseText.delegate = self
        addressText.delegate = self
        cityText.delegate = self
        stateText.delegate = self
        zipText.delegate = self
        phoneText.delegate = self
        emailText.delegate = self
        usernameText.delegate = self
        passwordText.delegate = self
    }
}

extension RegistrationViewController {
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
    private func startActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    private func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


