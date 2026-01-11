//
//  WatchListResponse.swift
//  TmdbAppTeam
//
//  Created by Durdana on 09.01.26.
//

import Foundation

struct WatchListResponse: Decodable {
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
