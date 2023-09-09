//
//  PaymentHandler+PKPaymentAuthorizationControllerDelegate.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation
import PassKit

// Set up PKPaymentAuthorizationControllerDelegate conformance
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    // Handle success and errors related to the payment
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success

        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // The payment sheet doesn't automatically dismiss once it has finished, so dismiss the payment sheet
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    if let completionHandler = self.completionHandler {
                        completionHandler(true)
                    }
                } else {
                    if let completionHandler = self.completionHandler {
                        completionHandler(false)
                    }
                }
            }
        }
    }
}

