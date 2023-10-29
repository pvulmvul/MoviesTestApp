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
    let totalPages: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

// MARK: - Movie
struct Movie: Decodable {
    let id: Int
    let genreIDS: [Int]
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case genreIDS = "genre_ids"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

struct MovieViewModel {
    let id: Int
    let genres: String
    let overview: String
    let posterPath: String?
    let title: String
    let voteAverage: String
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


