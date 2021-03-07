//
//  Movie.swift
//  Movies
//
//  Created by Giorgi on 3/6/21.
//

import Foundation

struct MovieItem: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let releaseDate: String
    let title: String
    let language: String
    let posterUrl: String?
    let rating: Double
    let description: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case releaseDate = "first_air_date"
        case title = "name"
        case language = "original_language"
        case posterUrl = "poster_path"
        case rating = "vote_average"
        case description = "overview"
        case id = "id"
    }
}
