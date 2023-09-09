//
//  PaymentHandler.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

// Note: The code below was taken from the sample app from https://developer.apple.com/documentation/passkit/apple_pay/offering_apple_pay_in_your_app - shortened and adapted for this application

import Foundation
import PassKit

final class PaymentHandler: NSObject, PaymentProcessor {
    // MARK: Properties

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
    ]
    
    // This applePayStatus function is not used in this app. Use it to check for the ability to make payments using canMakePayments(), and check for available payment cards using canMakePayments(usingNetworks:). You can also display a custom PaymentButton according to the result. See https://developer.apple.com/documentation/passkit/apple_pay/offering_apple_pay_in_your_app under "Add the Apple Pay Button" section
    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    // MARK: Private Methods
    
    // Define the shipping methods (this app only offers delivery) and the delivery dates
    private func shippingMethodCalculator() -> [PKShippingMethod] {
        
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 5, to: today)
        let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
        
        if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            
            let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            shippingDelivery.detail = "Order sent to your address"
            shippingDelivery.identifier = "DELIVERY"
            
            return [shippingDelivery]
        }
        return []
    }
    
    // MARK: PaymentProcessor Method Impl

    func startPayment(products: [Food], total: Double, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        // Reset the paymentSummaryItems array before adding to it
        paymentSummaryItems = []
        
        // Iterate over the products array, create a PKPaymentSummaryItem for each and append to the paymentSummaryItems array
        products.forEach { product in
            let item = PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(value: product.price), type: .final)
            paymentSummaryItems.append(item)
        }
        
        // Add a PKPaymentSummaryItem for the total to the paymentSummaryItems array
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: total), type: .final)
        paymentSummaryItems.append(total)
        
        // Create a payment request and add all data to it
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems // Set paymentSummaryItems to the paymentRequest
        paymentRequest.merchantIdentifier = "merchant.com.example.FoodApp"
        paymentRequest.merchantCapabilities = .capability3DS // A security protocol used to authenticate users
        paymentRequest.countryCode = "GB"
        paymentRequest.currencyCode = "GBP"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks // Types of cards supported
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        // Display the payment request in a sheet presentation
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
        })
    }
}
