//
//  YoutubeSearchResultsModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 25.11.2023.
//

import Foundation

struct YoutubeSearchResponse : Codable {
    let items: [VideoElement]
}

struct VideoElement : Codable {
    let id: IdVideoElement
}

struct IdVideoElement : Codable {
    let kind: String
    let videoId: String
}
