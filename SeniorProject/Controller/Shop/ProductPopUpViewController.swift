//
//  ProductPopUpViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/8/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class ProductPopUpViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    private var tapBGGesture: UITapGestureRecognizer!
    public var selectedProduct: Product?

    @IBOutlet weak var productPopUpView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productQuantity: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productPopUpView.layer.cornerRadius = 10
        productPopUpView.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        productQuantity.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let product = selectedProduct {
            productName.text = product.name
            productPrice.text = "$ ".appending(product.price.description)
            let url = product.img.replacingOccurrences(of: " ", with: "%20")
            let path = URLConstants.base.appending(url)
            productImage.sd_setImage(with: URL(string: path), completed: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(settingsBGTapped (sender:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        productPopUpView.window!.addGestureRecognizer(tapBGGesture)
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        selectedProduct?.quantity = Int(sender.value)
        productQuantity.text = selectedProduct?.quantity.description
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if KeychainWrapper.standard.bool(forKey: "Guest")!{
            ShowLogInAlert(title: "Guest user", message: "Please sign in or register to purchase products.")
        }
        else {
                if let product = selectedProduct {
                product.quantity = Int(productQuantity.text!)!
                Helpers.checkQuantity(model: product, completion: { (status, message) in
                    if (!status){
                        if let msg = message {
                            self.ShowAlert(title: "Warning", message: msg)
                        }
                    }
                    else {
                        Helpers.addItem_Cart(model: product, completion: { (status, alert) in
                            if (!status){
                                if let msg = alert {
                                    self.ShowAlert(title: "Warning", message: msg)
                                }
                            }
                            else {
                                self.dismiss(animated: false, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @objc func settingsBGTapped(sender: UITapGestureRecognizer){
        //checks to see if user tapped outside of modal VC
        if sender.state == UIGestureRecognizerState.ended {
            //            print("tapped")
            let location: CGPoint = sender.location(in: nil)
            if !productPopUpView.point(inside: productPopUpView.convert(location, from: productPopUpView.window), with: nil) {
                
                self.dismiss(animated: false, completion: nil)
                productPopUpView.window?.removeGestureRecognizer(sender)
//                print("outside")
            }
//            productPopUpView.endEditing(true)
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
    
    private func ShowAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func ShowLogInAlert(title: String, message: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action: UIAlertAction) -> Void in
        }))
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
            self.present(vc!, animated: false, completion: nil)
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
extension ProductPopUpViewController {
    //MARK: - Textfield protocol
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textField.resignFirstResponder()
        return true
    }
}

extension ProductPopUpViewController {
    //MARK: - Keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -60 // Move view points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y  = 0 // Move view to original position
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.frame.origin.y  = 0
        view.endEditing(true)
    }
}


