//
//  ContactViewController.swift
//  SeniorProject
//
//  Created by Angie on 5/6/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        nameTextField.delegate = self
        emailTextField.delegate = self
        numberTextField.delegate = self
        commentTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func clearInfo(_ sender: UIButton) {
        nameTextField.text = ""
        emailTextField.text = ""
        numberTextField.text = ""
        commentTextField.text = ""
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        print("...sending email")
        if (nameTextField.text == "" || emailTextField.text == "" || commentTextField.text == ""){
            ShowAlert(title: "Oops", message: "Enter all fields to continue.")
            return
        }
        else{
            if let name = nameTextField.text {
                if let email = emailTextField.text {
                    if let comment = commentTextField.text{
                        Helpers.contact(name: name, email: email, phone: numberTextField.text ?? "", comment: comment, completion: { (complete) in
                                if (complete){
                                    self.ShowAlert(title: "Contact Us", message: "Thank you for your feedback! Your email has been delivered.")
                                }
                            })
                    }
                }
            }
        }
    }
    
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            
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
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textField.resignFirstResponder()
        return true
    }

}

extension ContactViewController {
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -100 // Move view points upward
//        self.commentTextField.frame.origin.y = -200
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
