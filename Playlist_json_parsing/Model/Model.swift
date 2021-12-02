//
//  Model.swift
//  Playlist_json_parsing
//
//  Created by Maxim Mitin on 2.12.21.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String
    var artworkUrl60: String?
}
