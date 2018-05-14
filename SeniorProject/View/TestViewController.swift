//
//  TestViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/13/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    private var pushKeyboard:Bool = false
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var license: UITextField!
    @IBOutlet weak var name: UITextField!
    
    private var user:UserDetails?
    private var valid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        name.delegate = self
        license.delegate = self
        address.delegate = self
        city.delegate = self
        state.delegate = self
        zip.delegate = self
        email.delegate = self
        phone.delegate = self
        username.delegate = self
        password.delegate = self
        submitButton.layer.cornerRadius = 10.0
        clearButton.layer.cornerRadius = 10.0
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(_ sender: UIButton) {
        clearAllFields()
    }
    
    func clearAllFields(){
        name.text = ""
        license.text = ""
        address.text = ""
        city.text = ""
        state.text = ""
        zip.text = ""
        phone.text = ""
        email.text = ""
        username.text = ""
        password.text = ""
    }

    @IBAction func submit(_ sender: UIButton) {
        if (name.text == "" || license.text == "" || address.text == "" || city.text == "" ||
            state.text == "" || zip.text == "" || email.text == "" || username.text == "" || password.text == "") {
            ShowAlert(title: "Oops", message: "Enter all fields to continue.")
        }
        else {
            if !(validateEmail(enteredEmail: email.text!)){
                ShowAlert(title: "Oops", message: "Invalid email address format.\nTry Again.")
            }
            else {
                let name = self.name.text
                let license = self.license.text
                let address = self.address.text
                let city = self.self.city.text
                let state = self.state.text
                let zip = self.zip.text
                let phone = self.phone.text
                let email = self.email.text
                let username = self.username.text
                let password = self.password.text
                
                user = UserDetails(name: name!, license: license!, address: address!, city: city!, state: state!, zip: zip!, email: email!, phone: phone!, username: username!, password: password!)
                
                let postString = RestApiManager.sharedInstance.buildRegistrationPostString(model: user!)
                let path = URLConstants.base.appending(URLConstants.registration)
                RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
                    (json, err) in
                    print(json)
                    self.valid = json["register"].boolValue
                    if (self.valid){
                        self.ShowAlert(title: json["message"].stringValue, message: json["response"].stringValue)
                        self.clearAllFields()
                    }
                    else {
                        self.ShowAlert(title: "Register", message: json["message"].stringValue)
                    }
                }
            }
        }
    }
}

extension RegisterViewController {
    //MARK: - Textfield protocol
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        if( textField == email ||
            textField == username ||
            textField == password) {
            pushKeyboard = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            return
        }
        pushKeyboard = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == license {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
            
        else if textField == state {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2
        }
            
        else if textField == zip {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 5
        }
            
        else if textField == phone {
            var fullString = phone.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                phone.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                phone.text = format(phoneNumber: fullString)
            }
            return false
        }
        return true
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        if pushKeyboard {
            self.scrollView.contentOffset.y = 400  // Move view points upward
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.scrollView.contentOffset.y = 0 // Move view to original position
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        self.scrollView.contentOffset.y = 0
    }
}

extension RegisterViewController{
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
