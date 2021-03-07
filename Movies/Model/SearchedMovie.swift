//
//  SearchedMovie.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import Foundation

struct SearchedMovieItem: Codable {
    let results: [SearchedMovie]
}

struct SearchedMovie: Codable {
    let releaseDate: String
    let title: String
    let language: String
    let rating: Double
    let description: String
    let posterUrl: String?

    let id: Int

    enum CodingKeys: String, CodingKey {
        case releaseDate = "release_date"
        case title = "title"
        case language = "original_language"
        case rating = "popularity"
        case description = "overview"
        case posterUrl = "poster_path"
        case id = "id"
    }
}
