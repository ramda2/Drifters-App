//
//  Detail2ViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/13/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class Detail2ViewController: Detail1ViewController {
    
    public static var name:String = String()
    public static var license:String = String()
    public static var address:String = String()
    public static var city:String = String()
    public static var state:String = String()
    public static var zip:String = String()
    public static var phone:String = String()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    private var user:UserDetails?
    private var valid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10.0
        clearButton.layer.cornerRadius = 10.0
        hideKeyboardWhenTappedAround()

        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func submit(_ sender: UIButton) {
        print(Detail2ViewController.name, Detail2ViewController.license,
              Detail2ViewController.address,
              Detail2ViewController.city,
              Detail2ViewController.state,
              Detail2ViewController.zip,
              Detail2ViewController.phone)
//        if (Detail2ViewController.name == "" || Detail2ViewController.license == "" || Detail2ViewController.address == "" || Detail2ViewController.city == "" ||
//            Detail2ViewController.state == "" || Detail2ViewController.zip == "" || emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "") {
//            super.ShowAlert(title: "Oops", message: "Enter all fields to continue.")
//        }
//        else {
//            if !(validateEmail(enteredEmail: emailTextField.text!)){
//                super.ShowAlert(title: "Oops", message: "Invalid email address format.\nTry Again.")
//            }
//            else {
//                let name = Detail2ViewController.name
//                let license = Detail2ViewController.license
//                let address = Detail2ViewController.address
//                let city = Detail2ViewController.city
//                let state = Detail2ViewController.state
//                let zip = Detail2ViewController.zip
//                let phone = Detail2ViewController.phone
//                let email = emailTextField.text
//                let username = usernameTextField.text
//                let password = passwordTextField.text
//
//                user = UserDetails(name: name, license: license, address: address, city: city, state: state, zip: zip, email: email!, phone: phone, username: username!, password: password ?? "")
//
//                let postString = RestApiManager.sharedInstance.buildRegistrationPostString(model: user!)
//                let path = URLConstants.base.appending(URLConstants.registration)
//                RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
//                    (json, err) in
//                    print(json)
//                    self.valid = json["register"].boolValue
//                    if (self.valid){
//                        super.ShowAlert(title: json["message"].stringValue, message: json["response"].stringValue)
//                        self.clearAllFields()
//                    }
//                    else {
//                        super.ShowAlert(title: "Register", message: json["message"].stringValue)
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        clearAllFields()
    }
    
    private func clearAllFields(){
        nameTextField.text = ""
        licenseTextField.text = ""
        addressTextField.text = ""
        cityTextField.text = ""
        stateTextField.text = ""
        zipTextField.text = ""
        phoneTextField.text = ""
        emailTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
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





