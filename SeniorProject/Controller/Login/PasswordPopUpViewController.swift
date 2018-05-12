//
//  PasswordPopUpViewController.swift
//  SeniorProject
//
//  Created by Angie on 3/21/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class PasswordPopUpViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    private var tapBGGesture: UITapGestureRecognizer!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        emailTextField.delegate = self
        //dismiss keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(settingsBGTapped (sender:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        popUpView.window!.addGestureRecognizer(tapBGGesture)
    }
    
    @objc func settingsBGTapped(sender: UITapGestureRecognizer){
        //checks to see if user tapped outside of modal VC
        if sender.state == UIGestureRecognizerState.ended {
//            print("tapped")
            let location: CGPoint = sender.location(in: nil)
            if !popUpView.point(inside: popUpView.convert(location, from: popUpView.window), with: nil) {
                dismiss(animated: true, completion: nil)
                popUpView.window?.removeGestureRecognizer(sender)
//                print("outside")
            }
        }

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if tapBGGesture != nil {
            view.window?.removeGestureRecognizer(tapBGGesture)
            tapBGGesture = nil
        }
    }
   
    @IBAction func ResetPassword(_ sender: UIButton) {
        if (emailTextField.text == ""){
            return
        }
        let postString = "ForgotPassword&email_address=\(emailTextField.text!)"
        let path = URLConstants.base.appending(URLConstants.reset)
        RestApiManager.sharedInstance.PostHTTPRequest(path: path, args: postString) {
            (json, err) in
            print(json)
            self.ShowAlert(title: "Reset", message: json["message"].stringValue)
        }
    }
    
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            self.emailTextField.text = ""
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
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

extension PasswordPopUpViewController {
    //MARK: Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -100 // Move view 100 points upward
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
        view.endEditing(true)
    }
    
    //MARK: - Textfield protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
