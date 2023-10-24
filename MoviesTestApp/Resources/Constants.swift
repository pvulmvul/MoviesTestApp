//
//  Constants.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

struct Constant {
    
    struct Server {
        static let baseURL = "https://api.themoviedb.org/3"
        //NOTE: I've hardcoded this, because it's just a test project. In real project I'd store this in Keychain
        static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMmFiZGU1MGZjZTc2ZDY3NGIwYzhkZDI2OWI0YjhlNSIsInN1YiI6IjY1MzZiZGMxYzhhNWFjMDBhYzM5ZmYwMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.bPMEYp0gbLz2M_pl8N5W4E41USbf55K7LDH2yyf7Bfk"
    }
    
}

enum Header: String {
    case acceptType = "Accept"
    case contentType = "Content-Type"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
