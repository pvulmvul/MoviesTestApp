//
//  Connectivity.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import Foundation
import Alamofire

final class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
