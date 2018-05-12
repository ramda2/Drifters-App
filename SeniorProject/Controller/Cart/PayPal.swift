//
//  Paypal.swift
//  SeniorProject
//
//  Created by Angie on 4/28/18.
//  Copyright © 2018 DrifterDistribution. All rights reserved.
//

import Foundation

import UIKit
import Braintree
import BraintreeDropIn

class PaymentViewController: UIViewController, BTAppSwitchDelegate, BTViewControllerPresentingDelegate {
    
    var braintreeClient: BTAPIClient?
    
    func startCheckout() {
        // Example: Initialize BTAPIClient, if you haven't already
        braintreeClient = BTAPIClient(authorization: "sandbox_5d39p2mf_twyzk448zdktwxz5")!
        let payPalDriver = BTPayPalDriver(APIClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
}
