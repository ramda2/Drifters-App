//// Add this in your bridging header:
//
//
////class PaymentViewController: UIViewController, BTAppSwitchDelegate, BTViewControllerPresentingDelegate {
////
////    var braintreeClient: BTAPIClient?
////
////    func startCheckout() {
////        // Example: Initialize BTAPIClient, if you haven't already
////        braintreeClient = BTAPIClient(authorization: "<#CLIENT_AUTHORIZATION#>")!
////        let payPalDriver = BTPayPalDriver(APIClient: braintreeClient)
////        payPalDriver.viewControllerPresentingDelegate = self
////        payPalDriver.appSwitchDelegate = self // Optional
////
////        // Specify the transaction amount here. "2.32" is used in this example.
////        let request = BTPayPalRequest(amount: "2.32")
////        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
////
////        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
////            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
////                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
////
////                // Access additional information
////                let email = tokenizedPayPalAccount.email
////                let firstName = tokenizedPayPalAccount.firstName
////                let lastName = tokenizedPayPalAccount.lastName
////                let phone = tokenizedPayPalAccount.phone
////
////                // See BTPostalAddress.h for details
////                let billingAddress = tokenizedPayPalAccount.billingAddress
////                let shippingAddress = tokenizedPayPalAccount.shippingAddress
////            } else if let error = error {
////                // Handle error here...
////            } else {
////                // Buyer canceled payment approval
////            }
////        }
////    }
////}
//
//
////
////  PaymentViewController.swift
////  SeniorProject
////
////  Created by Angie on 4/27/18.
////  Copyright © 2018 DrifterDistribution. All rights reserved.
////
//
//import UIKit
//import Braintree
//import BraintreeDropIn
//
//
//class PaymentViewController: UIViewController, BTAppSwitchDelegate, BTViewControllerPresentingDelegate {
//
//    var braintreeClient: BTAPIClient?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        startCheckout()
//        // Do any additional setup after loading the view.
//    }
//
//    func startCheckout() {
//        // Example: Initialize BTAPIClient, if you haven't already
//        braintreeClient = BTAPIClient(authorization: "sandbox_5d39p2mf_twyzk448zdktwxz5")!
//        let payPalDriver = BTPayPalDriver(APIClient: braintreeClient)
//        payPalDriver.viewControllerPresentingDelegate = self
//        payPalDriver.appSwitchDelegate = self // Optional
//
//        // Specify the transaction amount here. "2.32" is used in this example.
//        let request = BTPayPalRequest(amount: "2.32")
//        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
//
//        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
//            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
//                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
//
//                // Access additional information
//                let email = tokenizedPayPalAccount.email
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
//
//                // See BTPostalAddress.h for details
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddress
//            } else if let error = error {
//                // Handle error here...
//            } else {
//                // Buyer canceled payment approval
//            }
//        }
//    }
//}
//
////
////class PaymentViewController: UIViewController {
////
////    var braintreeClient: BTAPIClient!
//////    let apiClient = BTAPIClient(authorization: "sandbox_5d39p2mf_twyzk448zdktwxz5")
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        self.braintreeClient = BTAPIClient(authorization: "sandbox_5d39p2mf_twyzk448zdktwxz5")
////        let customPayPalButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 120))
////        customPayPalButton.addTarget(self, action: #selector(customPayPalButtonTapped(button:)), for: UIControlEvents.touchUpInside)
////        self.view.addSubview(customPayPalButton)
//////        showDropIn(clientTokenOrTokenizationKey: "sandbox_5d39p2mf_twyzk448zdktwxz5")
////
////        // Do any additional setup after loading the view.
////    }
////
////    func customPayPalButtonTapped(button: UIButton) {
////        let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
////        payPalDriver.viewControllerPresentingDelegate = self
////        payPalDriver.appSwitchDelegate = self
////
////        // Start the Vault flow, or...
////        payPalDriver.authorizeAccount() { (tokenizedPayPalAccount, error) -> Void in
////            //...
////        }
////
////        // ...start the Checkout flow
////        let payPalRequest = BTPayPalRequest(amount: "1.00")
////        payPalDriver.requestOneTimePayment(payPalRequest) { (tokenizedPayPalAccount, error) -> Void in
////            //...
////        }
////    }
////
////    func showDropIn(clientTokenOrTokenizationKey: String) {
////        let request =  BTDropInRequest()
////        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
////        { (controller, result, error) in
////            if (error != nil) {
////                print("ERROR")
////            } else if (result?.isCancelled == true) {
////                print("CANCELLED")
////            } else if let result = result {
////                // Use the BTDropInResult properties to update your UI
//////                 result.paymentOptionType
//////                 result.paymentMethod
//////                 result.paymentIcon
//////                 result.paymentDescription
////                print(result)
//////              self.postNonceToServer(paymentMethodNonce: "fake-valid-nonce")
////            }
////            controller.dismiss(animated: true, completion: nil)
////        }
////        self.present(dropIn!, animated: true, completion: nil)
////    }
////
////    func postNonceToServer(paymentMethodNonce: String) {
////        // Update URL with your server
////        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
////        var request = URLRequest(url: paymentURL)
////        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
////        request.httpMethod = "POST"
////
////        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
////            // TODO: Handle success or failure
////            }.resume()
////    }
////
////    /*
////    // MARK: - Navigation
////
////    // In a storyboard-based application, you will often want to do a little preparation before navigation
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        // Get the new view controller using segue.destinationViewController.
////        // Pass the selected object to the new view controller.
////    }
////    */
////
////}
////
////
