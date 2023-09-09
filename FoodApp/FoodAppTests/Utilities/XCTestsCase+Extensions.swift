//
//  XCTestsCase+Extensions.swift
//  FoodAppTests
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import Combine
import Foundation
import XCTest

extension XCTestCase {
    func wait(for expectations: XCTestExpectation...) {
        wait(for: expectations, timeout: 0.01)
    }
    
    func waitUntil<ObjectType>(
        _ propertyPublisher: Published<ObjectType>.Publisher,
        _ test: @escaping (ObjectType) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Awaiting test to pass")
        
        var cancellable: AnyCancellable?
        
        cancellable = propertyPublisher
            .first(where: test)
            .sink { value in
                cancellable?.cancel()
                expectation.fulfill()
            }
        wait(for: expectation)
    }
}
