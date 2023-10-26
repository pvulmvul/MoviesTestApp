//
//  MovieDetails.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import Foundation

// MARK: - MovieDetails
struct MovieDetails: Decodable {
    let genres: [Genre]
    let id: Int
    let posterPath: String?
    let overview: String
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case genres
        case overview
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
