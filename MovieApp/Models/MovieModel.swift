//
//  MovieModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.11.2023.
//

import Foundation

struct MoviesResponse : Codable {
    let results: [Movie]
}

struct Movie : Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
