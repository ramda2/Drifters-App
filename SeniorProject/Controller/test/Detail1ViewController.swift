//
//  Detail1ViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/13/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class Detail1ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    private var pushKeyboard:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        prepareEntryFields()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Prepare textfield entry
    func prepareEntryFields(){
        nameTextField?.delegate = self
        licenseTextField?.delegate = self
        addressTextField?.delegate = self
        cityTextField?.delegate = self
        stateTextField?.delegate = self
        zipTextField?.delegate = self
        phoneTextField?.delegate = self
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

extension Detail1ViewController: UITextFieldDelegate {
    //MARK: - Textfield protocol
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        if( textField == zipTextField ||
            textField == phoneTextField) {
            pushKeyboard = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            return
        }
        pushKeyboard = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = nameTextField?.text {
            Detail2ViewController.name = name
        }
        if let license = licenseTextField?.text {
            Detail2ViewController.license = license
        }
        if let address = addressTextField?.text {
            Detail2ViewController.address = address
        }
        if let city = cityTextField?.text {
            Detail2ViewController.city = city
        }
        if let state = stateTextField?.text {
            Detail2ViewController.state = state
        }
        if let zip = zipTextField?.text {
            Detail2ViewController.zip = zip
        }
        if let phone = phoneTextField?.text {
            Detail2ViewController.phone = phone
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == licenseTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        
        else if textField == stateTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2
        }
            
        else if textField == zipTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 5
        }
        
        else if textField == phoneTextField {
            var fullString = phoneTextField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                phoneTextField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                phoneTextField.text = format(phoneNumber: fullString)
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
}

extension Detail1ViewController {
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        if pushKeyboard {
            self.view.frame.origin.y = -130 // Move view points upward
        }
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
extension Detail1ViewController {
     func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
