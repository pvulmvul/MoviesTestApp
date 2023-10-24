//
//  Movies.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

// MARK: - Movies
struct Movies: Decodable {
    let page: Int
    let results: [MoviesResult]

    enum CodingKeys: String, CodingKey {
        case page, results
    }
}

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - Result
struct MoviesResult: Decodable {
    let genreIDS: [Int]
    let overview: String
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
    }
}
