//
//  UpdateProductViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/29/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit

class UpdatePopUpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: UpdateTableDelegate?
    
    private var tapBGGesture: UITapGestureRecognizer!
    public var selectedProduct: Product?

    @IBOutlet weak var productQuantity: UITextField!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPopUpView: UIView!
    @IBOutlet weak var deleteProduct: UIButton!
    @IBOutlet weak var updateProduct: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productPopUpView.layer.cornerRadius = 10
        productPopUpView.layer.masksToBounds = true
        deleteProduct.layer.cornerRadius = 10
        updateProduct.layer.cornerRadius = 10
        if let product = selectedProduct {
            productName.text = product.name
            productPrice.text = "$ ".appending(product.price.description)
            let url = product.img.replacingOccurrences(of: " ", with: "%20")
            let path = URLConstants.base.appending(url)
            productImg.sd_setImage(with: URL(string: path), completed: nil)
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

    @IBAction func updateQuantity(_ sender: UIButton) {
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
                            self.delegate?.taskDidFinish(finished: true)
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func deleteProduct(_ sender: UIButton) {
        if let product = selectedProduct {
            Helpers.removeItem_Cart(model: product, completion: {(status) in
                self.delegate?.taskDidFinish(finished: true)
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        selectedProduct?.quantity = Int(sender.value)
        productQuantity.text = selectedProduct?.quantity.description
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
