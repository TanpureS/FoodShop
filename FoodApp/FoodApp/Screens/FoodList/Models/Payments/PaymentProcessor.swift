//
//  PaymentProcessor.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation

// Typealias so we don't always need to rewrite the type (Bool) -> Void
typealias PaymentCompletionHandler = (Bool) -> Void

protocol PaymentProcessor: AnyObject {
    func startPayment(products: [Food], total: Double, completion: @escaping PaymentCompletionHandler)
}
