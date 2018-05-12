//
//  CartTabViewController.swift
//  SeniorProject
//
//  Created by Angie on 4/9/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import UIKit
protocol UpdateTableDelegate {
    func taskDidFinish(finished: Bool)
}
class CartTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateTableDelegate, PayPalPaymentDelegate {

    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var products = [Product]()
    private var model:Cart?
    private let formatter = NumberFormatter()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        checkoutButton.layer.cornerRadius = 10.0
        formatter.numberStyle = .currency
//        activityIndicator.isHidden = true
        self.tableView.addSubview(self.refreshControl)
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Drifters Distributors"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        //        payPalConfig.payPalShippingAddressOption = .payPal;
        
        payPalConfig.payPalShippingAddressOption = .provided
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCart()
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getCart()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func taskDidFinish(finished: Bool) {
        if (finished){
            getCart()
        }
    }
    
    private func getCart(){
//        activityIndicator.startAnimating()
        Helpers.getProductsFromCart(completion: { (cart) -> () in
            self.model = cart
            self.totalPriceLabel.text = self.formatter.string(from: (self.model?.total)!)
            if self.model?.total == 0.00 {
                self.checkoutButton.isEnabled = false
                self.checkoutButton.backgroundColor = UIColor.gray
            }
            else {
                self.checkoutButton.isEnabled = true
                self.checkoutButton.backgroundColor = UIColor.init(red: 218/255, green: 32/255, blue: 23/255, alpha: 1.0)
            }
            self.tableView.reloadData()
//            self.activityIndicator.stopAnimating()
        })
    }
    
    @IBAction func checkout(_ sender: UIButton) {
        // Optional: include multiple items
        if let cart = model {
            if cart.product.count > 0 {
                var items = [PayPalItem]()
                cart.product.forEach { (prod) in
                    items.append(PayPalItem(name: prod.name, withQuantity: UInt(prod.quantity), withPrice: NSDecimalNumber(string: prod.price), withCurrency: "USD", withSku: prod.id))
                    
                }
                let payment = PayPalPayment(amount: NSDecimalNumber(string: cart.total.description), currencyCode: "USD", shortDescription: "Drifters Distributors", intent: .sale)
                payment.items = items
                if (payment.processable) {
                    let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                    present(paymentViewController!, animated: true, completion: nil)
                }
                else {
                    print("Payment not processalbe: \(payment)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.product.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(model?.product.count ?? 0) Items"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cartItem", for: indexPath) as? CartTableViewCell {
            
            if let cart = model {
                cell.productName.text = cart.product[indexPath.row].name

                //Currency Format
                let price = Double(cart.product[indexPath.row].price)
                let ns_price = price! as NSNumber
                
                cell.productPrice.text = formatter.string(from: ns_price)
                
                let quantity = cart.product[indexPath.row].quantity
    //            let subtotal = price! * Double(quantity) as NSNumber
                let subtotal: NSNumber = cart.subtotal[indexPath.row]
                cell.productSubtotal.text = formatter.string(from: subtotal)
                
                cell.productQty.text = quantity.description
                let url = cart.product[indexPath.row].img.replacingOccurrences(of: " ", with: "%20")
                let path = URLConstants.base.appending(url)
                cell.productImage.sd_setImage(with: URL(string: path), completed: nil)
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let cart = model {
                Helpers.removeItem_Cart(model: cart.product[indexPath.row], completion:
                { (status) -> () in
                    if (status){
                        self.getCart()
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected \(indexPath.row)")
        presentOptionFor(index: indexPath.row)
    }
    
    private func presentOptionFor(index: Int){
        if let cart = model {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "productUpdate") as? UpdatePopUpViewController{
                //TODO: pass data between controllers
                vc.delegate = self
                vc.selectedProduct = cart.product[index]
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.preferredContentSize = CGSize(width: view.frame.width/2, height: view.frame.height/2)
                tabBarController?.navigationController?.present(vc, animated: false, completion: nil)
            }
        }
    }
}

//MARK: PayPalPaymentDelegate
extension CartTabViewController {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }

    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            if let cart = self.model {
                Helpers.placeOrder(completion: { (order_completed, update_completed) in
                    if (order_completed) && (update_completed) {
                        Helpers.getUserInfo(completion: { (userDetails) in
                            Helpers.EmailInvoice(user: userDetails, model: cart, completion: {
                                (completed) in
                                if (completed){
                                    self.getCart()
                                    self.ShowAlert(title: "Payment Confirmation", message: "Payment was processed, please check your email for your receipt.")
                                }
                            })
                        })
                    }
                })
            }
        })
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
}

//MARK: Activity Indicator
//extension CartTabViewController {
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
//}
