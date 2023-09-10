//
//  PaymentHandlerStub.swift
//  FoodAppTests
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Foundation
@testable import FoodApp

final class PaymentHandlerStub: PaymentProcessor {
    // MARK: Stubs

    lazy var startPaymentStub = stub(of: startPayment)
    
    // MARK: API
    
    func startPayment(products: [Food], total: Double, completion: @escaping PaymentCompletionHandler) {
        startPaymentStub(products, total, completion)
    }
}
