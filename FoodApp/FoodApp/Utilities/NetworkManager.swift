//
//  NetworkManager.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 08/09/23.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "https://seanallen-course-backend.herokuapp.com/"
    let appetizerURL = baseURL + "swiftui-fundamentals/appetizers"
}

enum NetWorkError: Error {
    case invalidURL
    case imageDownloadingFailure
}
