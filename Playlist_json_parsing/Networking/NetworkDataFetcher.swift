//
//  NetworkDataFetcher.swift
//  Playlist_json_parsing
//
//  Created by Maxim Mitin on 2.12.21.
//

import Foundation

class NetworkDataFetcher {
    let networkService = NetworkService()
    
    func fetchTracks(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError{
                    print("Failed to decode data ", jsonError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
}
