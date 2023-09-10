//
//  NetWorkError.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 10/09/23.
//

import Foundation

enum NetWorkError: Error {
    case invalidURL
    case imageDownloadingFailure
    case sessionNotStarted
    case unknown
}
